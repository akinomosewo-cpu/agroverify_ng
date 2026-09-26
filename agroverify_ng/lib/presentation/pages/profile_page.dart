import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

import '../../core/localization/app_localizations.dart';
import '../../core/theme/app_theme.dart';
import '../blocs/auth/auth_cubit.dart';
import '../widgets/page_transitions.dart';
import 'login_page.dart';
import 'signup_page.dart';

/// The one place a farmer can, if they want to, create a local account or
/// log out. Reached from the home screen; entirely optional to visit.
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: Text(l10n.profile)),
      body: SafeArea(
        child: BlocBuilder<AuthCubit, AuthState>(
          builder: (context, state) {
            if (state is AuthAuthenticated) {
              return ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: AppColors.cardShadow,
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(gradient: AppColors.primaryGradient, shape: BoxShape.circle),
                          child: const Icon(Icons.person_rounded, color: Colors.white, size: 26),
                        ),
                        const Gap(14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(state.user.name, style: AppTextStyles.headlineSmall.copyWith(color: AppColors.textPrimary)),
                              const Gap(2),
                              Text(state.user.phone, style: AppTextStyles.labelMedium.copyWith(color: AppColors.textSecondary)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ).animate().fadeIn().slideY(begin: 0.08, end: 0),
                  const Gap(24),
                  OutlinedButton.icon(
                    onPressed: () => context.read<AuthCubit>().logOut(),
                    icon: const Icon(Icons.logout_rounded),
                    label: Text(l10n.logout),
                  ).animate(delay: 100.ms).fadeIn(),
                ],
              );
            }

            return ListView(
              padding: const EdgeInsets.all(20),
              children: [
                Center(
                  child: Column(
                    children: [
                      Icon(Icons.person_outline_rounded, size: 56, color: AppColors.primary)
                          .animate()
                          .fadeIn()
                          .scale(begin: const Offset(0.7, 0.7), end: const Offset(1, 1)),
                      const Gap(16),
                      Text(
                        l10n.guestUser,
                        style: AppTextStyles.headlineSmall.copyWith(color: AppColors.textPrimary),
                        textAlign: TextAlign.center,
                      ),
                      const Gap(6),
                      Text(
                        l10n.signUpToSaveHistory,
                        style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ).animate(delay: 100.ms).fadeIn(),
                ),
                const Gap(28),
                ElevatedButton(
                  onPressed: () => Navigator.of(context).push(SlideUpRoute(page: const SignUpPage())),
                  child: Text(l10n.createAccount),
                ).animate(delay: 200.ms).fadeIn().slideY(begin: 0.1, end: 0),
                const Gap(12),
                TextButton(
                  onPressed: () => Navigator.of(context).push(SlideUpRoute(page: const LoginPage())),
                  child: Text(l10n.login),
                ).animate(delay: 250.ms).fadeIn(),
              ],
            );
          },
        ),
      ),
    );
  }
}
