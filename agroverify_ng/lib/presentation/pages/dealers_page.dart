import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import '../../core/localization/app_localizations.dart';
import '../../core/theme/app_theme.dart';
import '../../domain/models/dealer.dart';
import '../../domain/repositories/dealer_repository.dart';

/// Trusted-vs-untrustworthy dealer directory.
///
/// A full interactive map (flutter_map + latlong2, already in
/// pubspec.yaml) is the natural next step once dealer coordinates are
/// backed by a live API; this list view surfaces the same trust signal
/// (rating + report count) in a farmer-friendly, low-bandwidth form.
class DealersPage extends StatelessWidget {
  DealersPage({super.key, DealerRepository? repository}) : _repository = repository ?? DealerRepository();

  final DealerRepository _repository;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final dealers = _repository.getDealers();
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: Text(l10n.dealers)),
      body: SafeArea(
        child: ListView.separated(
          padding: const EdgeInsets.all(20),
          itemCount: dealers.length,
          separatorBuilder: (_, __) => const Gap(12),
          itemBuilder: (context, index) => _DealerCard(dealer: dealers[index], l10n: l10n),
        ),
      ),
    );
  }
}

class _DealerCard extends StatelessWidget {
  final Dealer dealer;
  final AppLocalizations l10n;
  const _DealerCard({required this.dealer, required this.l10n});

  @override
  Widget build(BuildContext context) {
    final trusted = dealer.isTrusted;
    final badgeColor = trusted ? AppColors.success : AppColors.danger;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Expanded(
              child: Text(dealer.name, style: AppTextStyles.headlineSmall.copyWith(color: AppColors.textPrimary)),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(color: badgeColor.withOpacity(0.15), borderRadius: BorderRadius.circular(6)),
              child: Text(
                trusted ? l10n.trusted : l10n.untrustworthy,
                style: AppTextStyles.labelSmall.copyWith(color: badgeColor, fontWeight: FontWeight.w700),
              ),
            ),
          ]),
          const Gap(4),
          Text(dealer.location, style: AppTextStyles.labelMedium.copyWith(color: AppColors.textSecondary)),
          const Gap(10),
          Row(children: [
            _RatingStars(rating: dealer.rating),
            const Gap(8),
            Text(dealer.rating.toStringAsFixed(1), style: AppTextStyles.labelMedium.copyWith(color: AppColors.textSecondary)),
            const Spacer(),
            if (dealer.reportsCount > 0)
              Text('${dealer.reportsCount} reports', style: AppTextStyles.labelSmall.copyWith(color: AppColors.warning)),
          ]),
        ],
      ),
    );
  }
}

class _RatingStars extends StatelessWidget {
  final double rating;
  const _RatingStars({required this.rating});

  @override
  Widget build(BuildContext context) {
    final fullStars = rating.floor().clamp(0, 5);
    return Row(
      children: List.generate(5, (i) {
        return Icon(
          i < fullStars ? Icons.star_rounded : Icons.star_border_rounded,
          size: 16,
          color: AppColors.warning,
        );
      }),
    );
  }
}
