import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import '../../core/localization/app_localizations.dart';
import '../../core/theme/app_theme.dart';
import '../blocs/report/report_bloc.dart';

/// Report-a-fake-batch flow: batch/product code, a short description,
/// an optional photo, and an optional GPS fix, all fed into [ReportBloc].
class ReportPage extends StatefulWidget {
  const ReportPage({super.key});
  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  final _codeController = TextEditingController();
  final _descriptionController = TextEditingController();
  String? _photoPath;
  double? _latitude;
  double? _longitude;
  bool _capturingLocation = false;
  String? _locationError;

  @override
  void dispose() {
    _codeController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickPhoto() async {
    try {
      final picker = ImagePicker();
      final photo = await picker.pickImage(source: ImageSource.camera, maxWidth: 1600);
      if (photo != null) setState(() => _photoPath = photo.path);
    } catch (_) {
      // Camera unavailable (e.g. in tests/emulators without one) — ignore.
    }
  }

  Future<void> _captureLocation() async {
    setState(() {
      _capturingLocation = true;
      _locationError = null;
    });
    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) throw Exception('Location services are disabled');

      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
        throw Exception('Location permission denied');
      }

      final position = await Geolocator.getCurrentPosition();
      setState(() {
        _latitude = position.latitude;
        _longitude = position.longitude;
      });
    } catch (e) {
      setState(() => _locationError = e.toString());
    } finally {
      if (mounted) setState(() => _capturingLocation = false);
    }
  }

  void _submit() {
    context.read<ReportBloc>().add(ReportSubmitted(
          productCode: _codeController.text,
          description: _descriptionController.text,
          photoPath: _photoPath,
          latitude: _latitude,
          longitude: _longitude,
        ));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: Text(l10n.reportBatch)),
      body: SafeArea(
        child: BlocListener<ReportBloc, ReportState>(
          listenWhen: (previous, current) =>
              current is ReportListState && current.lastSubmitted != null && current.lastSubmitted != (previous as ReportListState?)?.lastSubmitted,
          listener: (context, state) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.reportSubmitted)));
            _codeController.clear();
            _descriptionController.clear();
            setState(() {
              _photoPath = null;
              _latitude = null;
              _longitude = null;
            });
          },
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              TextField(
                controller: _codeController,
                textCapitalization: TextCapitalization.characters,
                decoration: InputDecoration(hintText: l10n.batchCode),
              ),
              const Gap(12),
              TextField(
                controller: _descriptionController,
                minLines: 3,
                maxLines: 5,
                decoration: InputDecoration(hintText: l10n.description),
              ),
              const Gap(16),
              _ActionTile(
                icon: Icons.camera_alt_rounded,
                label: l10n.addPhoto,
                trailing: _photoPath != null ? const Icon(Icons.check_circle_rounded, color: AppColors.success) : null,
                onTap: _pickPhoto,
              ),
              if (_photoPath != null) ...[
                const Gap(10),
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.file(File(_photoPath!), height: 160, width: double.infinity, fit: BoxFit.cover),
                ),
              ],
              const Gap(10),
              _ActionTile(
                icon: Icons.my_location_rounded,
                label: l10n.captureLocation,
                trailing: _capturingLocation
                    ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))
                    : (_latitude != null ? const Icon(Icons.check_circle_rounded, color: AppColors.success) : null),
                onTap: _capturingLocation ? null : _captureLocation,
              ),
              if (_latitude != null && _longitude != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    '${_latitude!.toStringAsFixed(5)}, ${_longitude!.toStringAsFixed(5)}',
                    style: AppTextStyles.labelMedium.copyWith(color: AppColors.textSecondary),
                  ),
                ),
              if (_locationError != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(_locationError!, style: AppTextStyles.labelMedium.copyWith(color: AppColors.danger)),
                ),
              const Gap(24),
              ElevatedButton(onPressed: _submit, child: Text(l10n.submitReport)),
            ],
          ),
        ),
      ),
    );
  }
}

class _ActionTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final Widget? trailing;
  final VoidCallback? onTap;
  const _ActionTile({required this.icon, required this.label, this.trailing, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(children: [
          Icon(icon, color: AppColors.primary, size: 20),
          const Gap(14),
          Expanded(child: Text(label, style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textPrimary))),
          if (trailing != null) trailing!,
        ]),
      ),
    );
  }
}
