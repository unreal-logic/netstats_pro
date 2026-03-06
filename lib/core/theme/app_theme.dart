import 'package:flutter/material.dart';
import 'package:netstats_pro/core/theme/colors.dart';
import 'package:netstats_pro/core/theme/typography.dart';

class AppTheme {
  /// Defines standard M3 light theme
  static ThemeData get lightTheme {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: NetStatsColors.primary,
      tertiary: NetStatsColors.accentTeal,
      error: NetStatsColors.accentCoral,
      surface: NetStatsColors.backgroundLight,
    );

    return _buildTheme(colorScheme);
  }

  /// Defines premium M3 dark theme (NetStats default)
  static ThemeData get darkTheme {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: NetStatsColors.primary,
      brightness: Brightness.dark,
      tertiary: NetStatsColors.accentTeal,
      error: NetStatsColors.accentCoral,
      surface: NetStatsColors.backgroundDark,
    );

    return _buildTheme(colorScheme);
  }

  static ThemeData _buildTheme(ColorScheme colorScheme) {
    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      textTheme: AppTypography.textTheme.apply(
        bodyColor: colorScheme.onSurface,
        displayColor: colorScheme.onSurface,
      ),
      scaffoldBackgroundColor: colorScheme.surface,
      cardTheme: CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: colorScheme.outlineVariant.withValues(alpha: 0.1),
          ),
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: AppTypography.textTheme.titleLarge?.copyWith(
          color: colorScheme.onSurface,
          fontWeight: FontWeight.w800,
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
      ),
    );
  }
}
