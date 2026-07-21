import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Design tokens straight from Stitch DESIGN.md ("Warm PetConnect").
class AppColors {
  // Brand
  static const primary = Color(0xFFAE2F34);
  static const primaryContainer = Color(0xFFFF6B6B); // warm coral
  static const onPrimaryContainer = Color(0xFF6D0010);
  static const primaryFixedDim = Color(0xFFFFB3B0);

  static const secondary = Color(0xFF006A65); // teal
  static const secondaryContainer = Color(0xFF79F3EA);
  static const onSecondaryContainer = Color(0xFF006F69);

  static const tertiary = Color(0xFF705D00); // gold (verified badges)
  static const tertiaryContainer = Color(0xFFCAA800);
  static const tertiaryFixed = Color(0xFFFFE173);

  // Surface (Light)
  static const surface = Color(0xFFF7F9FF);
  static const surfaceBright = Color(0xFFF7F9FF);
  static const surfaceVariant = Color(0xFFD1E4FB);
  static const surfaceContainerLow = Color(0xFFEDF4FF);
  static const surfaceContainer = Color(0xFFE3EFFF);
  static const surfaceContainerHigh = Color(0xFFD9EAFF);

  static const onSurface = Color(0xFF091D2E);
  static const onSurfaceVariant = Color(0xFF584140);
  static const outline = Color(0xFF8C706F);
  static const outlineVariant = Color(0xFFE0BFBD);

  // Surface (Dark) — Deep Slate warmth
  static const darkBg = Color(0xFF1A2632);
  static const darkSurfaceLow = Color(0xFF203243);
  static const darkSurface = Color(0xFF243447);
  static const darkSurfaceHigh = Color(0xFF2C4058);

  static const error = Color(0xFFBA1A1A);
  static const success = Color(0xFF006A65);
}

class AppRadius {
  static const base = 8.0;
  static const lg = 16.0; // base components
  static const xl = 24.0; // containers
  static const full = 9999.0; // pill
}

class AppElevation {
  static const cardShadow = [
    BoxShadow(color: Color(0x14203243), offset: Offset(0, 4), blurRadius: 20),
  ];
  static const floatingShadow = [
    BoxShadow(color: Color(0x1F203243), offset: Offset(0, 12), blurRadius: 32),
  ];
}

class AppTheme {
  static TextTheme _text({required Color ink}) {
    final heading = GoogleFonts.plusJakartaSans;
    final body = GoogleFonts.inter;
    return TextTheme(
      displayLarge: heading(
        fontSize: 40,
        fontWeight: FontWeight.w700,
        height: 48 / 40,
        letterSpacing: -0.8,
        color: ink,
      ),
      headlineLarge: heading(
        fontSize: 32,
        fontWeight: FontWeight.w700,
        height: 40 / 32,
        letterSpacing: -0.32,
        color: ink,
      ),
      headlineMedium: heading(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        height: 32 / 24,
        color: ink,
      ),
      titleLarge: heading(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: ink,
      ),
      bodyLarge: body(
        fontSize: 18,
        fontWeight: FontWeight.w400,
        height: 28 / 18,
        color: ink,
      ),
      bodyMedium: body(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        height: 24 / 16,
        color: ink,
      ),
      labelLarge: body(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        height: 20 / 14,
        letterSpacing: 0.14,
      ),
      labelSmall: body(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        height: 16 / 12,
      ),
    );
  }

  static ThemeData get light => ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    scaffoldBackgroundColor: AppColors.surface,
    colorScheme: const ColorScheme(
      brightness: Brightness.light,
      primary: AppColors.primaryContainer, // coral for actions
      onPrimary: Color(0xFF6D0010),
      primaryContainer: AppColors.primaryContainer,
      onPrimaryContainer: AppColors.onPrimaryContainer,
      secondary: AppColors.secondary,
      onSecondary: Colors.white,
      secondaryContainer: AppColors.secondaryContainer,
      onSecondaryContainer: AppColors.onSecondaryContainer,
      tertiary: AppColors.tertiaryContainer,
      onTertiary: Colors.white,
      tertiaryContainer: AppColors.tertiaryFixed,
      onTertiaryContainer: Color(0xFF4C3E00),
      error: AppColors.error,
      onError: Colors.white,
      errorContainer: Color(0xFFFFDAD6),
      onErrorContainer: Color(0xFF93000A),
      surface: AppColors.surface,
      onSurface: AppColors.onSurface,
      surfaceContainerLowest: Colors.white,
      surfaceContainerLow: AppColors.surfaceContainerLow,
      surfaceContainer: AppColors.surfaceContainer,
      surfaceContainerHigh: AppColors.surfaceContainerHigh,
      surfaceContainerHighest: AppColors.surfaceVariant,
      onSurfaceVariant: AppColors.onSurfaceVariant,
      outline: AppColors.outline,
      outlineVariant: AppColors.outlineVariant,
      inverseSurface: Color(0xFF203243),
      onInverseSurface: Color(0xFFE8F2FF),
      inversePrimary: Color(0xFFFFB3B0),
      shadow: Colors.black,
      scrim: Colors.black,
    ),
    textTheme: _text(ink: AppColors.onSurface),
    cardTheme: CardThemeData(
      color: Colors.white,
      elevation: 0,
      shadowColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.xl),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primaryContainer,
        foregroundColor: AppColors.onPrimaryContainer,
        minimumSize: const Size.fromHeight(56),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.lg),
        ),
        textStyle: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.surfaceBright,
      hintStyle: GoogleFonts.inter(fontSize: 16, color: AppColors.outline),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.lg),
        borderSide: const BorderSide(color: AppColors.surfaceVariant),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.lg),
        borderSide: const BorderSide(color: AppColors.surfaceVariant),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.lg),
        borderSide: const BorderSide(color: AppColors.secondary, width: 2),
      ),
    ),
  );

  static ThemeData get dark => ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColors.darkBg,
    colorScheme: const ColorScheme(
      brightness: Brightness.dark,
      primary: AppColors.primaryContainer,
      onPrimary: Colors.white,
      primaryContainer: Color(0xFF8C1520),
      onPrimaryContainer: Color(0xFFFFDAD8),
      secondary: Color(0xFF5DD9D0),
      onSecondary: Color(0xFF00201E),
      secondaryContainer: Color(0xFF00504C),
      onSecondaryContainer: Color(0xFF7CF6EC),
      tertiary: Color(0xFFE8C426),
      onTertiary: Color(0xFF221B00),
      tertiaryContainer: Color(0xFF554500),
      onTertiaryContainer: Color(0xFFFFE173),
      error: Color(0xFFFFB4AB),
      onError: Color(0xFF690005),
      errorContainer: Color(0xFF93000A),
      onErrorContainer: Color(0xFFFFDAD6),
      surface: AppColors.darkBg,
      onSurface: Color(0xFFE8F2FF),
      surfaceContainerLowest: Color(0xFF141E28),
      surfaceContainerLow: AppColors.darkSurfaceLow,
      surfaceContainer: AppColors.darkSurface,
      surfaceContainerHigh: AppColors.darkSurfaceHigh,
      surfaceContainerHighest: Color(0xFF33475F),
      onSurfaceVariant: Color(0xFFCFC0BE),
      outline: Color(0xFF988A88),
      outlineVariant: Color(0xFF4E4342),
      inverseSurface: Color(0xFFE8F2FF),
      onInverseSurface: Color(0xFF203243),
      inversePrimary: AppColors.primary,
      shadow: Colors.black,
      scrim: Colors.black,
    ),
    textTheme: _text(ink: const Color(0xFFE8F2FF)),
    cardTheme: CardThemeData(
      color: AppColors.darkSurface,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.xl),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primaryContainer,
        foregroundColor: Colors.white,
        minimumSize: const Size.fromHeight(56),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.lg),
        ),
        textStyle: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.darkSurfaceLow,
      hintStyle: GoogleFonts.inter(
        fontSize: 16,
        color: const Color(0xFF988A88),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.lg),
        borderSide: const BorderSide(color: Color(0xFF4E4342)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.lg),
        borderSide: const BorderSide(color: Color(0xFF4E4342)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.lg),
        borderSide: const BorderSide(color: Color(0xFF5DD9D0), width: 2),
      ),
    ),
  );
}
