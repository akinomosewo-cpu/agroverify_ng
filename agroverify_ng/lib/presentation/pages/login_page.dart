import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

import '../../core/localization/app_localizations.dart';
import '../../core/services/auth_service.dart';
import '../../core/theme/app_theme.dart';
import '../blocs/auth/auth_cubit.dart';
import '../widgets/page_transitions.dart';
import 'signup_page.dart';

/// Optional local login. A farmer only ever reaches this from the profile
/// screen — the scanner and every other feature work without it.
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _phoneCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  bool _submitting = false;
  String? _error;

  @override
  void dispose() {
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
      await context.read<AuthCubit>().logIn(phone: _phoneCtrl.text, password: _passwordCtrl.text);
      if (mounted) Navigator.of(context).pop();
    } on AuthException catch (e) {
      if (mounted) setState(() => _error = _messageFor(e.type, l10n));
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  String _messageFor(AuthErrorType type, AppLocalizations l10n) {
    switch (type) {
      case AuthErrorType.notFound:
        return l10n.accountNotFound;
      case AuthErrorType.wrongPassword:
        return l10n.wrongPassword;
      case AuthErrorType.invalidInput:
      case AuthErrorType.phoneExists:
        return l10n.invalidAuthInput;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: Text(l10n.login)),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Text(l10n.welcomeBack, style: AppTextStyles.headlineLarge.copyWith(color: AppColors.textPrimary))
                .animate()
                .fadeIn()
                .slideY(begin: 0.1, end: 0),
            const Gap(20),
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
                  : Text(l10n.login),
            ),
            const Gap(16),
            Center(
              child: TextButton(
                onPressed: () => Navigator.of(context).pushReplacement(SlideUpRoute(page: const SignUpPage())),
                child: Text(l10n.dontHaveAccount),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
