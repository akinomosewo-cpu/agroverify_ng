import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gap/gap.dart';

import '../../core/theme/app_theme.dart';
import '../widgets/page_transitions.dart';
import 'home_page.dart';

/// A brief, animated brand reveal shown on app start. It always lands the
/// farmer on the scanner-ready home page — there is no account requirement
/// to get past it.
///
/// The hold is driven by an [AnimationController] rather than a bare
/// `Timer` so it advances deterministically with `tester.pump(duration)` in
/// widget tests, instead of depending on real wall-clock time.
class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with SingleTickerProviderStateMixin {
  late final AnimationController _holdController;

  @override
  void initState() {
    super.initState();
    _holdController = AnimationController(vsync: this, duration: const Duration(milliseconds: 1300))
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) _goHome();
      })
      ..forward();
  }

  @override
  void dispose() {
    _holdController.dispose();
    super.dispose();
  }

  void _goHome() {
    if (!mounted) return;
    Navigator.of(context).pushReplacement(FadeThroughRoute(page: const HomePage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 96,
              height: 96,
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.circular(28),
                boxShadow: AppColors.cardShadow,
              ),
              child: const Icon(Icons.agriculture_rounded, color: Colors.white, size: 48),
            )
                .animate()
                .fadeIn(duration: 350.ms)
                .scale(begin: const Offset(0.6, 0.6), end: const Offset(1, 1), curve: Curves.easeOutBack, duration: 550.ms),
            const Gap(20),
            Text(
              'AgroVerify NG',
              style: AppTextStyles.headlineLarge.copyWith(color: AppColors.textPrimary),
            ).animate(delay: 250.ms).fadeIn(duration: 400.ms).slideY(begin: 0.2, end: 0),
            const Gap(6),
            Text(
              'Verify before you buy',
              style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
            ).animate(delay: 400.ms).fadeIn(duration: 400.ms),
          ],
        ),
      ),
    );
  }
}
