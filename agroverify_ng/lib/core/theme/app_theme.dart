import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

/// Warm, earthy-green light palette — soft off-white backgrounds, rounded
/// cards with gentle shadows instead of hard borders, and a single vibrant
/// brand-green accent used sparingly for primary actions and highlights.
class AppColors {
  AppColors._();
  static const Color primary = Color(0xFF2E8B57); // sea green, agro brand accent
  static const Color primaryDark = Color(0xFF1F6B41);
  static const Color success = Color(0xFF2E8B57);
  static const Color warning = Color(0xFFE9A63B);
  static const Color danger = Color(0xFFE5533D);
  static const Color info = Color(0xFF4A90D9);
  static const Color background = Color(0xFFFAF6EE); // warm off-white
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceElevated = Color(0xFFFFFFFF);
  static const Color surfaceMuted = Color(0xFFF1ECDF); // soft pastel card fill
  static const Color textPrimary = Color(0xFF20241F);
  static const Color textSecondary = Color(0xFF6B7266);
  static const Color textTertiary = Color(0xFFA3A99B);
  static const Color border = Color(0xFFEAE3D2);
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF3CA066), Color(0xFF2E8B57)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Soft, low-opacity drop shadow used in place of flat borders on cards.
  static List<BoxShadow> cardShadow = [
    BoxShadow(
      color: const Color(0xFF20241F).withOpacity(0.06),
      blurRadius: 20,
      offset: const Offset(0, 8),
    ),
  ];
}

class AppTextStyles {
  AppTextStyles._();
  static TextStyle get displayLarge => GoogleFonts.plusJakartaSans(fontSize: 40, fontWeight: FontWeight.w800, letterSpacing: -0.8, height: 1.05);
  static TextStyle get displayMedium => GoogleFonts.plusJakartaSans(fontSize: 32, fontWeight: FontWeight.w800, letterSpacing: -0.5, height: 1.1);
  static TextStyle get displaySmall => GoogleFonts.plusJakartaSans(fontSize: 26, fontWeight: FontWeight.w800, letterSpacing: -0.3);
  static TextStyle get headlineLarge => GoogleFonts.plusJakartaSans(fontSize: 21, fontWeight: FontWeight.w700);
  static TextStyle get headlineMedium => GoogleFonts.plusJakartaSans(fontSize: 18, fontWeight: FontWeight.w700);
  static TextStyle get headlineSmall => GoogleFonts.plusJakartaSans(fontSize: 16, fontWeight: FontWeight.w700);
  static TextStyle get bodyLarge => GoogleFonts.inter(fontSize: 17, fontWeight: FontWeight.w400, height: 1.5);
  static TextStyle get bodyMedium => GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w400, height: 1.5);
  static TextStyle get bodySmall => GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w400, height: 1.5);
  static TextStyle get labelLarge => GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600);
  static TextStyle get labelMedium => GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600);
  static TextStyle get labelSmall => GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 0.3);
}

class AppTheme {
  AppTheme._();

  /// The app's single theme: a warm, airy, agro-earthy light design —
  /// soft off-white surfaces, generously rounded cards with soft shadows,
  /// and a vibrant green accent. Kept as `dark` so existing references
  /// (main.dart, tests) don't need to change.
  static ThemeData get dark => ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    scaffoldBackgroundColor: AppColors.background,
    colorScheme: const ColorScheme.light(
      primary: AppColors.primary,
      surface: AppColors.surface,
      error: AppColors.danger,
      onPrimary: Colors.white,
      onSurface: AppColors.textPrimary,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.background,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: true,
      systemOverlayStyle: SystemUiOverlayStyle.dark,
      titleTextStyle: AppTextStyles.headlineMedium.copyWith(color: AppColors.textPrimary),
      iconTheme: const IconThemeData(color: AppColors.textPrimary),
    ),
    cardTheme: CardThemeData(
      color: AppColors.surface,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      margin: EdgeInsets.zero,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        minimumSize: const Size(double.infinity, 58),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        textStyle: AppTextStyles.headlineSmall,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.surfaceMuted,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: BorderSide.none),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: BorderSide.none),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: const BorderSide(color: AppColors.primary, width: 2)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
      hintStyle: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
    ),
    dividerTheme: const DividerThemeData(color: AppColors.border, thickness: 0.5),
  );
}
