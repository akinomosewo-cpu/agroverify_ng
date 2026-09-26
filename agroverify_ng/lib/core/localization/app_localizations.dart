import 'package:flutter/material.dart';

/// Lightweight, dependency-free localization for AgroVerify NG.
///
/// Supports English, Hausa and Yoruba. This is a hand-rolled scaffold
/// (rather than generated ARB/gen-l10n output) so it works without running
/// the Flutter toolchain's code generator, while still giving the app a
/// real `Locale`-driven translation lookup that can later be swapped for
/// full `flutter gen-l10n` output without changing call sites.
class AppLocalizations {
  final Locale locale;
  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    final localizations = Localizations.of<AppLocalizations>(context, AppLocalizations);
    return localizations ?? AppLocalizations(const Locale('en'));
  }

  static const supportedLocales = [
    Locale('en'),
    Locale('ha'),
    Locale('yo'),
  ];

  static const localeNames = {
    'en': 'English',
    'ha': 'Hausa',
    'yo': 'Yorùbá',
  };

  static const _strings = <String, Map<String, String>>{
    'appTitle': {
      'en': 'AgroVerify NG',
      'ha': 'AgroVerify NG',
      'yo': 'AgroVerify NG',
    },
    'scan': {
      'en': 'Scan a product code',
      'ha': 'Duba lambar kaya',
      'yo': 'Ṣayẹwo koodu ọja',
    },
    'scanInputs': {
      'en': 'Scan inputs to verify',
      'ha': 'Duba kayayyaki don tabbatarwa',
      'yo': 'Ṣayẹwo ohun elo lati fọwọsi',
    },
    'rateDealers': {
      'en': 'Rate agro-dealers',
      'ha': 'Kimanta dilolin noma',
      'yo': 'Ṣe ìdíwọ̀n oníṣòwò ọ̀gbìn',
    },
    'reportFake': {
      'en': 'Report fake products',
      'ha': 'Kai rahoton bogin kaya',
      'yo': 'Jabọ ọja èké',
    },
    'recentActivity': {
      'en': 'Recent Activity',
      'ha': 'Ayyukan Kwanan Nan',
      'yo': 'Ìgbésẹ̀ Àìpẹ́',
    },
    'whatYouCanDo': {
      'en': 'What you can do',
      'ha': 'Abin da za ka iya yi',
      'yo': 'Ohun tí o lè ṣe',
    },
    'nothingHereYet': {
      'en': 'Nothing here yet',
      'ha': 'Babu wani abu tukuna',
      'yo': 'Ko si nnkan síbẹ̀',
    },
    'tapToStart': {
      'en': 'Tap + to get started',
      'ha': 'Danna + don farawa',
      'yo': 'Tẹ + láti bẹ̀rẹ̀',
    },
    'enterCode': {
      'en': 'Enter product code',
      'ha': 'Shigar da lambar kaya',
      'yo': 'Tẹ koodu ọja sí',
    },
    'verify': {
      'en': 'Verify',
      'ha': 'Tabbatar',
      'yo': 'Fọwọsi',
    },
    'verifiedGenuine': {
      'en': 'Genuine product',
      'ha': 'Kayan gaskiya ne',
      'yo': 'Ọja tòótọ́',
    },
    'suspectedFake': {
      'en': 'Suspected counterfeit',
      'ha': 'Ana zargin bogi ne',
      'yo': 'A fura sí pé ó jẹ́ èké',
    },
    'unknownCode': {
      'en': 'Code not recognised — verify with dealer',
      'ha': 'Ba a gane lambar ba — tabbatar da dila',
      'yo': 'A kò dá koodu náà mọ̀ — jẹ́rìí sí ọ̀dọ̀ oníṣòwò',
    },
    'reportBatch': {
      'en': 'Report a bad batch',
      'ha': 'Kai rahoton bogin kaya',
      'yo': 'Jabọ ìdìpọ̀ tí kò dára',
    },
    'batchCode': {
      'en': 'Batch / product code',
      'ha': 'Lambar kaya',
      'yo': 'Koodu ìdìpọ̀ / ọja',
    },
    'description': {
      'en': 'What did you notice?',
      'ha': 'Me ka lura da shi?',
      'yo': 'Kí ni o ṣàkíyèsí?',
    },
    'addPhoto': {
      'en': 'Add photo evidence',
      'ha': 'Ƙara hoto',
      'yo': 'Fi àwòrán kún un',
    },
    'captureLocation': {
      'en': 'Capture GPS location',
      'ha': 'Ɗauki wurin GPS',
      'yo': 'Mú ipò GPS',
    },
    'submitReport': {
      'en': 'Submit report',
      'ha': 'Aika rahoto',
      'yo': 'Fi ìjábọ̀ ránṣẹ́',
    },
    'reportSubmitted': {
      'en': 'Report submitted. Thank you for protecting other farmers.',
      'ha': 'An aika rahoto. Na gode da kare sauran manoma.',
      'yo': 'A ti fi ìjábọ̀ ránṣẹ́. A dúpẹ́ pé o ń dáàbò bo àwọn àgbẹ̀ mìíràn.',
    },
    'dealers': {
      'en': 'Dealers near you',
      'ha': 'Dilolin da ke kusa da kai',
      'yo': 'Àwọn oníṣòwò tó wà nítòsí',
    },
    'trusted': {
      'en': 'Trusted',
      'ha': 'Amintacce',
      'yo': 'Ẹni ìgbẹ́kẹ̀lé',
    },
    'untrustworthy': {
      'en': 'Untrustworthy',
      'ha': 'Ba abin dogaro ba',
      'yo': 'Aláìṣeṣe',
    },
    'listenToPage': {
      'en': 'Listen',
      'ha': 'Saurara',
      'yo': 'Tẹ́tí sílẹ̀',
    },
  };

  String t(String key) {
    final entry = _strings[key];
    if (entry == null) return key;
    return entry[locale.languageCode] ?? entry['en'] ?? key;
  }

  // Convenience getters for the most-used strings.
  String get appTitle => t('appTitle');
  String get scan => t('scan');
  String get scanInputs => t('scanInputs');
  String get rateDealers => t('rateDealers');
  String get reportFake => t('reportFake');
  String get recentActivity => t('recentActivity');
  String get whatYouCanDo => t('whatYouCanDo');
  String get nothingHereYet => t('nothingHereYet');
  String get tapToStart => t('tapToStart');
  String get enterCode => t('enterCode');
  String get verify => t('verify');
  String get verifiedGenuine => t('verifiedGenuine');
  String get suspectedFake => t('suspectedFake');
  String get unknownCode => t('unknownCode');
  String get reportBatch => t('reportBatch');
  String get batchCode => t('batchCode');
  String get description => t('description');
  String get addPhoto => t('addPhoto');
  String get captureLocation => t('captureLocation');
  String get submitReport => t('submitReport');
  String get reportSubmitted => t('reportSubmitted');
  String get dealers => t('dealers');
  String get trusted => t('trusted');
  String get untrustworthy => t('untrustworthy');
  String get listenToPage => t('listenToPage');
}

class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) =>
      AppLocalizations.supportedLocales.any((l) => l.languageCode == locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) async => AppLocalizations(locale);

  @override
  bool shouldReload(AppLocalizationsDelegate old) => false;
}
