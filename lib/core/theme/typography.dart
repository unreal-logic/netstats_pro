import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// AppTypography establishes the global M3 TextTheme using Lexend.
class AppTypography {
  static TextTheme get textTheme {
    // Inter as base for body and labels
    final baseTheme = GoogleFonts.interTextTheme();

    return baseTheme.copyWith(
      // Keep Lexend for displays and headlines
      displayLarge: GoogleFonts.lexend(fontWeight: FontWeight.w700),
      displayMedium: GoogleFonts.lexend(fontWeight: FontWeight.w700),
      displaySmall: GoogleFonts.lexend(fontWeight: FontWeight.w700),
      headlineLarge: GoogleFonts.lexend(fontWeight: FontWeight.w600),
      headlineMedium: GoogleFonts.lexend(fontWeight: FontWeight.w600),
      headlineSmall: GoogleFonts.lexend(fontWeight: FontWeight.w600),
      titleLarge: GoogleFonts.lexend(fontWeight: FontWeight.w600),
      titleMedium: GoogleFonts.lexend(fontWeight: FontWeight.w600),
      titleSmall: GoogleFonts.lexend(fontWeight: FontWeight.w600),
    );
  }
}
