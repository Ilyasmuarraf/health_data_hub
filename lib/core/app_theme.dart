import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Central color palette. Every screen pulls from here so the
/// "biotech / neon dashboard" look stays consistent app-wide.
class AppColors {
  AppColors._();

  static const Color background = Color(0xFF030303);
  static const Color cardSurface = Color(0xFF0A0C10);
  static const Color cardBorder = Color(0xFF1A1C23);
  static const Color glassOverlay = Color(0xCC1A1A24);

  // Status colors
  static const Color optimalGreen = Color(0xFF00FF41);
  static const Color moderateYellow = Color(0xFFFFD600);
  static const Color criticalRed = Color(0xFFFF2A2A);

  // Secondary accents seen in the "healthy" condition cards
  static const Color accentCyan = Color(0xFF29B6F6);
  static const Color accentBlue = Color(0xFF3D7BFF);

  static const Color textPrimary = Colors.white;
  static const Color textSecondary = Color(0xFFA0A0A5);
  static const Color textTertiary = Color(0xFF6E6E76);

  static Color tint(Color base, [double opacity = 0.14]) =>
      base.withOpacity(opacity);
}

/// Maps a 0-100 health score to the traffic-light color used by every
/// circular gauge in the app (thresholds match the reference screens:
/// 76 -> green, 66 -> amber, 30 -> red).
Color gaugeColorForScore(int score) {
  if (score >= 70) return AppColors.optimalGreen;
  if (score >= 40) return AppColors.moderateYellow;
  return AppColors.criticalRed;
}

/// Every detail screen in the reference has a soft radial glow behind the
/// header, tinted to match that screen's theme color (warm amber on the
/// LDL screen, green on healthy-organ screens, red on flagged-condition
/// screens). This enum lets each screen declare its tint once.
enum ScreenGlowTint { amber, green, red, yellow }

extension ScreenGlowTintColors on ScreenGlowTint {
  Color get color {
    switch (this) {
      case ScreenGlowTint.amber:
        return const Color(0xFFB8860B);
      case ScreenGlowTint.green:
        return AppColors.optimalGreen;
      case ScreenGlowTint.red:
        return AppColors.criticalRed;
      case ScreenGlowTint.yellow:
        return AppColors.moderateYellow;
    }
  }
}

enum RiskStatus { good, moderate, critical }

extension RiskStatusStyle on RiskStatus {
  Color get color {
    switch (this) {
      case RiskStatus.good:
        return AppColors.optimalGreen;
      case RiskStatus.moderate:
        return AppColors.moderateYellow;
      case RiskStatus.critical:
        return AppColors.criticalRed;
    }
  }

  Color get tintedBackground => color.withOpacity(0.12);
}

class AppTheme {
  AppTheme._();

  /// The reference screens use TWO distinct type systems, confirmed by
  /// close inspection of the exported frames:
  ///  - "Orbitron" (geometric/technical) for every screen & section
  ///    title — "Mentzer", "RANGES", "Heart Condition", "Strengths :",
  ///    etc. — plus the standalone LDL hero stat ("36.7").
  ///  - A rounded geometric Google Font ("Manrope") for absolutely
  ///    everything else: gauge percentages & tick numbers, body copy,
  ///    callout text, list values, buttons.
  /// This mirrors the two families you flagged ("google font and
  /// Orbitron"). If Figma's dev-mode inspector shows a different exact
  /// family for either role, these three getters are the only place that
  /// needs to change.
  static String get headingFontFamily => GoogleFonts.orbitron().fontFamily!;
  static String get bodyFontFamily => GoogleFonts.manrope().fontFamily!;

  /// Back-compat alias used by widgets that don't yet distinguish role.
  static String get fontFamily => bodyFontFamily;

  static TextStyle heading({
    required double fontSize,
    Color color = AppColors.textPrimary,
    FontWeight fontWeight = FontWeight.w600,
    double? letterSpacing,
  }) =>
      GoogleFonts.orbitron(
        fontSize: fontSize,
        color: color,
        fontWeight: fontWeight,
        letterSpacing: letterSpacing ?? 0.6,
      );

  static TextStyle body({
    required double fontSize,
    Color color = AppColors.textSecondary,
    FontWeight fontWeight = FontWeight.w500,
    double? letterSpacing,
    double? height,
  }) =>
      GoogleFonts.manrope(
        fontSize: fontSize,
        color: color,
        fontWeight: fontWeight,
        letterSpacing: letterSpacing,
        height: height,
      );

  /// Used directly inside CustomPainter classes (gauges, charts), which
  /// have no BuildContext/Theme to inherit from. [isHeading] switches
  /// between the two families documented above.
  static TextStyle painterText({
    required double fontSize,
    required Color color,
    FontWeight fontWeight = FontWeight.w600,
    double? letterSpacing,
    bool isHeading = false,
  }) =>
      isHeading
          ? heading(fontSize: fontSize, color: color, fontWeight: fontWeight, letterSpacing: letterSpacing)
          : GoogleFonts.manrope(
              fontSize: fontSize,
              color: color,
              fontWeight: fontWeight,
              letterSpacing: letterSpacing,
            );

  static ThemeData get darkTheme {
    final base = ThemeData(brightness: Brightness.dark);
    return base.copyWith(
      scaffoldBackgroundColor: AppColors.background,
      splashFactory: NoSplash.splashFactory,
      textTheme: GoogleFonts.manropeTextTheme(base.textTheme).apply(
        bodyColor: AppColors.textPrimary,
        displayColor: AppColors.textPrimary,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
        titleTextStyle: heading(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          letterSpacing: 1.0,
        ),
      ),
      colorScheme: const ColorScheme.dark(
        primary: AppColors.accentCyan,
        surface: AppColors.cardSurface,
      ),
    );
  }
}
