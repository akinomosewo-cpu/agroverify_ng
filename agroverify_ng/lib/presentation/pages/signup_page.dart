import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

import '../../core/localization/app_localizations.dart';
import '../../core/services/auth_service.dart';
import '../../core/theme/app_theme.dart';
import '../blocs/auth/auth_cubit.dart';
import '../widgets/page_transitions.dart';
import 'login_page.dart';

/// Optional local account creation: a name, phone number and password
/// stored only on this device, purely so a farmer can keep their scan and
/// report history across app restarts. Nothing about the app requires it.
class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _nameCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  bool _submitting = false;
  String? _error;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final l10n = AppLocalizations.of(context);
    setState(() {
      _submitting = true;
      _error = null;
    });
    try {
      await context.read<AuthCubit>().signUp(
            name: _nameCtrl.text,
            phone: _phoneCtrl.text,
            password: _passwordCtrl.text,
          );
      if (mounted) Navigator.of(context).pop();
    } on AuthException catch (e) {
      if (mounted) setState(() => _error = _messageFor(e.type, l10n));
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  String _messageFor(AuthErrorType type, AppLocalizations l10n) {
    switch (type) {
      case AuthErrorType.phoneExists:
        return l10n.phoneAlreadyRegistered;
      case AuthErrorType.notFound:
      case AuthErrorType.wrongPassword:
      case AuthErrorType.invalidInput:
        return l10n.invalidAuthInput;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: Text(l10n.createAccount)),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Text(l10n.signUpToSaveHistory, style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary))
                .animate()
                .fadeIn()
                .slideY(begin: 0.1, end: 0),
            const Gap(20),
            TextField(controller: _nameCtrl, decoration: InputDecoration(hintText: l10n.fullName)),
            const Gap(12),
            TextField(
              controller: _phoneCtrl,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(hintText: l10n.phoneNumber),
            ),
            const Gap(12),
            TextField(
              controller: _passwordCtrl,
              obscureText: true,
              decoration: InputDecoration(hintText: l10n.password),
              onSubmitted: (_) => _submit(),
            ),
            if (_error != null) ...[
              const Gap(12),
              Text(_error!, style: AppTextStyles.bodySmall.copyWith(color: AppColors.danger))
                  .animate()
                  .fadeIn()
                  .shake(hz: 4, offset: const Offset(6, 0)),
            ],
            const Gap(20),
            ElevatedButton(
              onPressed: _submitting ? null : _submit,
              child: _submitting
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                    )
                  : Text(l10n.createAccount),
            ),
            const Gap(16),
            Center(
              child: TextButton(
                onPressed: () => Navigator.of(context).pushReplacement(SlideUpRoute(page: const LoginPage())),
                child: Text(l10n.alreadyHaveAccount),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
