import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

/// Holds the app's currently selected language (English/Hausa/Yoruba).
///
/// Kept as a small standalone cubit rather than folded into [AppBloc] so
/// language switching cannot be affected by, or affect, unrelated app
/// state (scans, reports, dealer lists).
class LocaleCubit extends Cubit<Locale> {
  LocaleCubit() : super(const Locale('en'));

  void setLocale(Locale locale) => emit(locale);

  void setLanguageCode(String languageCode) => emit(Locale(languageCode));
}
