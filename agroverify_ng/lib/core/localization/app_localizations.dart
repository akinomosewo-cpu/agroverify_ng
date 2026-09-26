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
    'profile': {
      'en': 'Profile',
      'ha': 'Bayanan ka',
      'yo': 'Àkọlé rẹ',
    },
    'login': {
      'en': 'Log in',
      'ha': 'Shiga',
      'yo': 'Wọlé',
    },
    'signUp': {
      'en': 'Sign up',
      'ha': 'Yi rijista',
      'yo': 'Forúkọsílẹ̀',
    },
    'logout': {
      'en': 'Log out',
      'ha': 'Fita',
      'yo': 'Jáde',
    },
    'createAccount': {
      'en': 'Create account',
      'ha': 'Ƙirƙiri asusu',
      'yo': 'Ṣẹ̀dá àkántì',
    },
    'fullName': {
      'en': 'Full name',
      'ha': 'Cikakken suna',
      'yo': 'Orúkọ kíkún',
    },
    'phoneNumber': {
      'en': 'Phone number',
      'ha': 'Lambar waya',
      'yo': 'Nọ́mbà fóònù',
    },
    'password': {
      'en': 'Password',
      'ha': 'Kalmar sirri',
      'yo': 'Ọ̀rọ̀ìpamọ́',
    },
    'welcomeBack': {
      'en': 'Welcome back',
      'ha': 'Barka da dawowa',
      'yo': 'Kábọ̀ padà',
    },
    'guestUser': {
      'en': 'You are browsing as a guest',
      'ha': 'Kana amfani da manhaja a matsayin baƙo',
      'yo': 'O ń lo ohun èlò gẹ́gẹ́ bí àlejò',
    },
    'signUpToSaveHistory': {
      'en': 'Create a free account to save your scan and report history on this phone.',
      'ha': 'Ƙirƙiri asusu kyauta don adana tarihin dubawa da rahotanninka a wayarka.',
      'yo': 'Ṣẹ̀dá àkántì ọ̀fẹ́ láti fi ìtàn ìṣàyẹ̀wò àti ìjábọ̀ rẹ pamọ́ sórí fóònù yìí.',
    },
    'dontHaveAccount': {
      'en': "New here? Create an account",
      'ha': 'Sabo ne a nan? Ƙirƙiri asusu',
      'yo': 'Ṣé o ṣẹ̀ṣẹ̀ dé? Ṣẹ̀dá àkántì',
    },
    'alreadyHaveAccount': {
      'en': 'Already have an account? Log in',
      'ha': 'Kana da asusu tuni? Shiga',
      'yo': 'Ṣé o ti ní àkántì? Wọlé',
    },
    'invalidAuthInput': {
      'en': 'Please check your details — password must be at least 4 characters.',
      'ha': 'Da fatan za a duba bayaninka — kalmar sirri dole ta zama aƙalla haruffa 4.',
      'yo': 'Jọ̀wọ́ ṣàyẹ̀wò àwọn àlàyé rẹ — ọ̀rọ̀ìpamọ́ gbọ́dọ̀ ní ó kéré tán àmì mẹ́rin.',
    },
    'phoneAlreadyRegistered': {
      'en': 'This phone number is already registered on this device.',
      'ha': 'An riga an yi rijistar wannan lambar waya a wannan na\'urar.',
      'yo': 'A ti forúkọsílẹ̀ nọ́mbà fóònù yìí tẹ́lẹ̀ lórí ẹ̀rọ yìí.',
    },
    'accountNotFound': {
      'en': 'No account found for this phone number on this device.',
      'ha': 'Ba a sami asusu don wannan lambar waya a wannan na\'urar ba.',
      'yo': 'A kò rí àkántì kankan fún nọ́mbà fóònù yìí lórí ẹ̀rọ yìí.',
    },
    'wrongPassword': {
      'en': 'Incorrect password.',
      'ha': 'Kalmar sirri ba daidai ba ce.',
      'yo': 'Ọ̀rọ̀ìpamọ́ kò tọ́.',
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
  String get profile => t('profile');
  String get login => t('login');
  String get signUp => t('signUp');
  String get logout => t('logout');
  String get createAccount => t('createAccount');
  String get fullName => t('fullName');
  String get phoneNumber => t('phoneNumber');
  String get password => t('password');
  String get welcomeBack => t('welcomeBack');
  String get guestUser => t('guestUser');
  String get signUpToSaveHistory => t('signUpToSaveHistory');
  String get dontHaveAccount => t('dontHaveAccount');
  String get alreadyHaveAccount => t('alreadyHaveAccount');
  String get invalidAuthInput => t('invalidAuthInput');
  String get phoneAlreadyRegistered => t('phoneAlreadyRegistered');
  String get accountNotFound => t('accountNotFound');
  String get wrongPassword => t('wrongPassword');
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
