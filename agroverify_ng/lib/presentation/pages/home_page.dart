import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gap/gap.dart';
import '../../core/localization/app_localizations.dart';
import '../../core/theme/app_theme.dart';
import '../blocs/app_bloc.dart';
import '../widgets/language_switcher.dart';
import 'dealers_page.dart';
import 'report_page.dart';
import 'scanner_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    context.read<AppBloc>().add(const AppStarted());
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: BlocBuilder<AppBloc, AppState>(
          builder: (context, state) {
            return CustomScrollView(
              slivers: [
                SliverAppBar(
                  floating: true, snap: true,
                  backgroundColor: AppColors.background,
                  title: Row(children: [
                    Container(
                      width: 32, height: 32,
                      decoration: BoxDecoration(gradient: AppColors.primaryGradient, borderRadius: BorderRadius.circular(10)),
                      child: const Icon(Icons.agriculture_rounded, color: Colors.white, size: 17),
                    ),
                    const Gap(10),
                    Text(l10n.appTitle, style: AppTextStyles.headlineLarge.copyWith(color: AppColors.textPrimary)),
                  ]),
                  actions: [
                    const LanguageSwitcher(),
                    IconButton(icon: const Icon(Icons.add_rounded, color: AppColors.primary), onPressed: () => _showAddSheet(context)),
                    const Gap(4),
                  ],
                ),
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  sliver: SliverList(delegate: SliverChildListDelegate([
                    const Gap(8),
                    Row(children: [
                      Expanded(child: _StatCard(label: 'Scans', value: state is AppLoaded ? state.items.length.toString() : '0', color: AppColors.primary).animate(delay: 50.ms).fadeIn().slideY(begin: 0.1)),
                      const Gap(12),
                      Expanded(child: _StatCard(label: 'Verified', value: state is AppLoaded ? state.items.where((i) => i['status'] == 'active').length.toString() : '0', color: AppColors.success).animate(delay: 100.ms).fadeIn().slideY(begin: 0.1)),
                      const Gap(12),
                      Expanded(child: _StatCard(label: 'Dealers', value: state is AppLoaded ? state.items.where((i) => i['status'] == 'pending').length.toString() : '0', color: AppColors.warning).animate(delay: 150.ms).fadeIn().slideY(begin: 0.1)),
                    ]),
                    const Gap(28),
                    Text(l10n.whatYouCanDo, style: AppTextStyles.headlineLarge.copyWith(color: AppColors.textPrimary)),
                    const Gap(14),
                    _FeatureCard(
                      icon: Icons.check_circle_outline_rounded,
                      label: l10n.scanInputs,
                      color: AppColors.primary,
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ScannerPage())),
                    ).animate(delay: 200.ms).fadeIn().slideX(begin: -0.1),
                    const Gap(8),
                    _FeatureCard(
                      icon: Icons.bar_chart_rounded,
                      label: l10n.rateDealers,
                      color: AppColors.success,
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => DealersPage())),
                    ).animate(delay: 250.ms).fadeIn().slideX(begin: -0.1),
                    const Gap(8),
                    _FeatureCard(
                      icon: Icons.send_rounded,
                      label: l10n.reportFake,
                      color: AppColors.warning,
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ReportPage())),
                    ).animate(delay: 300.ms).fadeIn().slideX(begin: -0.1),
                    const Gap(28),
                    Text(l10n.recentActivity, style: AppTextStyles.headlineLarge.copyWith(color: AppColors.textPrimary)),
                    const Gap(14),
                    if (state is AppLoaded && state.items.isEmpty)
                      Container(
                        padding: const EdgeInsets.all(32),
                        decoration: BoxDecoration(color: AppColors.surfaceMuted, borderRadius: BorderRadius.circular(24)),
                        child: Column(children: [
                          Icon(Icons.agriculture_rounded, color: AppColors.primary, size: 44),
                          const Gap(12),
                          Text(l10n.nothingHereYet, style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary)),
                          const Gap(4),
                          Text(l10n.tapToStart, style: AppTextStyles.labelMedium.copyWith(color: AppColors.textTertiary)),
                        ]),
                      ).animate().fadeIn(delay: 350.ms),
                    if (state is AppLoaded)
                      ...state.items.asMap().entries.map((e) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: _ItemTile(
                          title: e.value['title'] ?? 'Item',
                          subtitle: e.value['subtitle'] ?? '',
                          status: e.value['status'] ?? 'active',
                          onDelete: () => context.read<AppBloc>().add(ItemDeleted(e.value['id'] ?? '')),
                        ).animate(delay: Duration(milliseconds: 50 * e.key)).fadeIn(),
                      )),
                    const Gap(32),
                  ])),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  void _showAddSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(28))),
      builder: (_) => BlocProvider.value(value: context.read<AppBloc>(), child: const _AddSheet()),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label, value;
  final Color color;
  const _StatCard({required this.label, required this.value, required this.color});
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
    decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(22), boxShadow: AppColors.cardShadow),
    child: Column(children: [
      Text(value, style: AppTextStyles.displaySmall.copyWith(color: color)),
      const Gap(4),
      Text(label, style: AppTextStyles.labelSmall.copyWith(color: AppColors.textSecondary), textAlign: TextAlign.center),
    ]),
  );
}

class _FeatureCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback? onTap;
  const _FeatureCard({required this.icon, required this.label, required this.color, this.onTap});
  @override
  Widget build(BuildContext context) => InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(20),
    child: Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(20), boxShadow: AppColors.cardShadow),
      child: Row(children: [
        Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: color.withOpacity(0.14), borderRadius: BorderRadius.circular(14)),
          child: Icon(icon, color: color, size: 20)),
        const Gap(14),
        Expanded(child: Text(label, style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textPrimary, fontWeight: FontWeight.w600))),
        const Icon(Icons.chevron_right_rounded, color: AppColors.textTertiary, size: 20),
      ]),
    ),
  );
}

class _ItemTile extends StatelessWidget {
  final String title, subtitle, status;
  final VoidCallback onDelete;
  const _ItemTile({required this.title, required this.subtitle, required this.status, required this.onDelete});
  @override
  Widget build(BuildContext context) {
    final statusColor = status == 'active' ? AppColors.success : status == 'pending' ? AppColors.warning : AppColors.textSecondary;
    return Dismissible(
      key: Key(title + DateTime.now().toString()),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight, padding: const EdgeInsets.only(right: 24),
        decoration: BoxDecoration(color: AppColors.danger.withOpacity(0.15), borderRadius: BorderRadius.circular(20)),
        child: const Icon(Icons.delete_outline_rounded, color: AppColors.danger),
      ),
      onDismissed: (_) => onDelete(),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(20), boxShadow: AppColors.cardShadow),
        child: Row(children: [
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title, style: AppTextStyles.headlineSmall.copyWith(color: AppColors.textPrimary)),
            if (subtitle.isNotEmpty) Text(subtitle, style: AppTextStyles.labelMedium.copyWith(color: AppColors.textSecondary)),
          ])),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(color: statusColor.withOpacity(0.14), borderRadius: BorderRadius.circular(100)),
            child: Text(status, style: AppTextStyles.labelSmall.copyWith(color: statusColor)),
          ),
        ]),
      ),
    );
  }
}

class _AddSheet extends StatefulWidget {
  const _AddSheet();
  @override State<_AddSheet> createState() => _AddSheetState();
}

class _AddSheetState extends State<_AddSheet> {
  final _titleCtrl = TextEditingController();
  final _subtitleCtrl = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(20, 20, 20, MediaQuery.of(context).viewInsets.bottom + 20),
      child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('Add New', style: AppTextStyles.headlineLarge.copyWith(color: AppColors.textPrimary)),
        const Gap(20),
        TextField(controller: _titleCtrl, style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textPrimary), decoration: const InputDecoration(hintText: 'Title / Name')),
        const Gap(12),
        TextField(controller: _subtitleCtrl, style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textPrimary), decoration: const InputDecoration(hintText: 'Details')),
        const Gap(20),
        ElevatedButton(
          onPressed: () {
            if (_titleCtrl.text.isEmpty) return;
            context.read<AppBloc>().add(ItemAdded({
              'id': DateTime.now().millisecondsSinceEpoch.toString(),
              'title': _titleCtrl.text,
              'subtitle': _subtitleCtrl.text,
              'status': 'active',
            }));
            Navigator.pop(context);
          },
          child: const Text('Save'),
        ),
      ]),
    );
  }
}
