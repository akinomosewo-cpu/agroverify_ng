import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/localization/app_localizations.dart';
import '../blocs/locale/locale_cubit.dart';

/// Lets the farmer switch between English, Hausa and Yoruba anywhere in
/// the app; wraps [LocaleCubit] so the whole app rebuilds under the new
/// locale immediately.
class LanguageSwitcher extends StatelessWidget {
  const LanguageSwitcher({super.key});

  @override
  Widget build(BuildContext context) {
    final current = context.watch<LocaleCubit>().state;
    return PopupMenuButton<Locale>(
      tooltip: 'Language / Harshe / Èdè',
      icon: const Icon(Icons.translate_rounded),
      initialValue: current,
      onSelected: (locale) => context.read<LocaleCubit>().setLocale(locale),
      itemBuilder: (context) => AppLocalizations.supportedLocales
          .map((locale) => PopupMenuItem<Locale>(
                value: locale,
                child: Text(AppLocalizations.localeNames[locale.languageCode] ?? locale.languageCode),
              ))
          .toList(),
    );
  }
}
