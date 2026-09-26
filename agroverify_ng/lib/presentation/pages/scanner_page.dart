import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../../core/localization/app_localizations.dart';
import '../../core/services/verification_service.dart';
import '../../core/services/voice_service.dart';
import '../../core/theme/app_theme.dart';
import '../blocs/verification/verification_bloc.dart';

/// Scan or type a product code, then verify it against the (stubbed)
/// SEEDCODEX-style backend via [VerificationBloc].
class ScannerPage extends StatefulWidget {
  const ScannerPage({super.key});
  @override
  State<ScannerPage> createState() => _ScannerPageState();
}

class _ScannerPageState extends State<ScannerPage> {
  final _codeController = TextEditingController();
  MobileScannerController? _scannerController;
  bool _cameraActive = false;
  final _voiceService = const VoiceService();

  @override
  void dispose() {
    _codeController.dispose();
    _scannerController?.dispose();
    super.dispose();
  }

  void _toggleCamera() {
    setState(() {
      _cameraActive = !_cameraActive;
      if (_cameraActive) {
        _scannerController ??= MobileScannerController();
      }
    });
  }

  void _onDetect(BarcodeCapture capture) {
    final barcode = capture.barcodes.isNotEmpty ? capture.barcodes.first : null;
    final value = barcode?.rawValue;
    if (value == null || value.isEmpty) return;
    _codeController.text = value;
    context.read<VerificationBloc>().add(CodeSubmitted(value));
    setState(() => _cameraActive = false);
  }

  void _submitTypedCode() {
    final code = _codeController.text.trim();
    if (code.isEmpty) return;
    context.read<VerificationBloc>().add(CodeSubmitted(code));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Semantics(
          header: true,
          child: Text(l10n.scan),
        ),
        actions: [
          IconButton(
            tooltip: l10n.listenToPage,
            icon: const Icon(Icons.volume_up_rounded),
            onPressed: () => _voiceService.speak(l10n.scan),
          ),
        ],
      ),
      body: SafeArea(
        child: BlocConsumer<VerificationBloc, VerificationState>(
          listener: (context, state) {
            if (state is VerificationSuccess) {
              _voiceService.speak(_statusMessage(state.result, l10n));
            }
          },
          builder: (context, state) {
            return ListView(
              padding: const EdgeInsets.all(20),
              children: [
                if (_cameraActive)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: SizedBox(
                      height: 260,
                      child: Stack(
                        children: [
                          MobileScanner(
                            controller: _scannerController,
                            onDetect: _onDetect,
                          ),
                          const Positioned.fill(child: _ScanLineOverlay()),
                        ],
                      ),
                    ),
                  )
                else
                  GestureDetector(
                    onTap: _toggleCamera,
                    child: Container(
                      height: 200,
                      decoration: BoxDecoration(
                        gradient: AppColors.primaryGradient,
                        borderRadius: BorderRadius.circular(28),
                        boxShadow: AppColors.cardShadow,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(color: Colors.white.withOpacity(0.18), shape: BoxShape.circle),
                            child: const Icon(Icons.qr_code_scanner_rounded, color: Colors.white, size: 36),
                          )
                              .animate(onPlay: (c) => c.repeat(reverse: true))
                              .scaleXY(end: 1.08, duration: 900.ms, curve: Curves.easeInOut),
                          const Gap(12),
                          Text(l10n.scan, style: AppTextStyles.headlineSmall.copyWith(color: Colors.white)),
                        ],
                      ),
                    ),
                  ),
                if (_cameraActive)
                  TextButton(onPressed: _toggleCamera, child: const Text('Close camera')),
                const Gap(20),
                TextField(
                  controller: _codeController,
                  textCapitalization: TextCapitalization.characters,
                  decoration: InputDecoration(hintText: l10n.enterCode),
                  onSubmitted: (_) => _submitTypedCode(),
                ),
                const Gap(12),
                ElevatedButton(onPressed: _submitTypedCode, child: Text(l10n.verify)),
                const Gap(24),
                if (state is VerificationInProgress) const Center(child: CircularProgressIndicator()),
                if (state is VerificationSuccess)
                  _ResultCard(result: state.result, l10n: l10n)
                      .animate()
                      .fadeIn(duration: 350.ms, curve: Curves.easeOut)
                      .scale(begin: const Offset(0.9, 0.9), end: const Offset(1, 1), duration: 350.ms, curve: Curves.easeOutBack),
              ],
            );
          },
        ),
      ),
    );
  }

  String _statusMessage(VerificationResult result, AppLocalizations l10n) {
    switch (result.status) {
      case VerificationStatus.genuine:
        return l10n.verifiedGenuine;
      case VerificationStatus.counterfeit:
        return l10n.suspectedFake;
      case VerificationStatus.unknown:
        return l10n.unknownCode;
    }
  }
}

/// A thin highlight line that sweeps down the camera preview while the
/// scanner is active, echoing a real barcode/QR scanner's scan beam.
class _ScanLineOverlay extends StatelessWidget {
  const _ScanLineOverlay();

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Align(
        alignment: Alignment.topCenter,
        child: Container(
          height: 3,
          margin: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            gradient: LinearGradient(
              colors: [
                AppColors.primary.withOpacity(0),
                AppColors.primary,
                AppColors.primary.withOpacity(0),
              ],
            ),
            boxShadow: [BoxShadow(color: AppColors.primary.withOpacity(0.6), blurRadius: 8)],
          ),
        )
            .animate(onPlay: (c) => c.repeat(reverse: true))
            .moveY(begin: 0, end: 240, duration: 1600.ms, curve: Curves.easeInOut),
      ),
    );
  }
}

class _ResultCard extends StatelessWidget {
  final VerificationResult result;
  final AppLocalizations l10n;
  const _ResultCard({required this.result, required this.l10n});

  @override
  Widget build(BuildContext context) {
    final Color color;
    final IconData icon;
    final String message;
    switch (result.status) {
      case VerificationStatus.genuine:
        color = AppColors.success;
        icon = Icons.verified_rounded;
        message = l10n.verifiedGenuine;
        break;
      case VerificationStatus.counterfeit:
        color = AppColors.danger;
        icon = Icons.dangerous_rounded;
        message = l10n.suspectedFake;
        break;
      case VerificationStatus.unknown:
        color = AppColors.warning;
        icon = Icons.help_outline_rounded;
        message = l10n.unknownCode;
        break;
    }
    return Semantics(
      liveRegion: true,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(24),
          boxShadow: AppColors.cardShadow,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(color: color.withOpacity(0.14), shape: BoxShape.circle),
                child: Icon(icon, color: color),
              ),
              const Gap(12),
              Expanded(
                child: Text(message, style: AppTextStyles.headlineSmall.copyWith(color: color)),
              ),
            ]),
            if (result.productName != null) ...[
              const Gap(14),
              Text('${result.productName} · ${result.brand ?? ''}',
                  style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textPrimary, fontWeight: FontWeight.w600)),
            ],
            const Gap(8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(color: AppColors.surfaceMuted, borderRadius: BorderRadius.circular(100)),
              child: Text(result.code, style: AppTextStyles.labelMedium.copyWith(color: AppColors.textSecondary)),
            ),
          ],
        ),
      ),
    );
  }
}
