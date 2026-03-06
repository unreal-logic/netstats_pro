import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:netstats_pro/core/design_system/tokens/app_colors.dart';
import 'package:netstats_pro/core/design_system/tokens/app_spacing.dart';
import 'package:netstats_pro/core/design_system/tokens/app_typography.dart';

/// AppTheme — Material 3 ThemeData for light and dark modes
///
/// Usage:
/// ```dart
/// MaterialApp(
///   theme:      AppTheme.light,
///   darkTheme:  AppTheme.dark,
///   themeMode:  ThemeMode.system,
/// )
/// ```
abstract final class AppTheme {
  // ─── Color Schemes ────────────────────────────────────────────────────────

  static ColorScheme get _darkColorScheme => const ColorScheme(
    brightness: Brightness.dark,
    // Primary
    primary: AppColors.primary,
    onPrimary: AppColors.onPrimary,
    primaryContainer: AppColors.primaryContainer,
    onPrimaryContainer: AppColors.onPrimaryContainer,
    // Secondary (slate tones)
    secondary: AppColors.slate500,
    onSecondary: AppColors.slate100,
    secondaryContainer: AppColors.slate700,
    onSecondaryContainer: AppColors.slate200,
    // Tertiary (cyan accent)
    tertiary: AppColors.info,
    onTertiary: AppColors.onInfo,
    tertiaryContainer: Color(0xFF164E63), // cyan-900
    onTertiaryContainer: Color(0xFFA5F3FC), // cyan-200
    // Error
    error: AppColors.error,
    onError: AppColors.onError,
    errorContainer: Color(0xFF7F1D1D), // red-900
    onErrorContainer: Color(0xFFFECACA), // red-200
    // Surface / Background
    surface: AppColors.darkSurface,
    onSurface: AppColors.darkOnSurface,
    surfaceContainerHighest: AppColors.darkSurfaceVariant,
    onSurfaceVariant: AppColors.darkOnSurfaceVariant,
    // Outline
    outline: AppColors.darkOutline,
    outlineVariant: AppColors.darkOutlineVariant,
    // Misc
    shadow: Colors.black,
    scrim: Colors.black,
    inverseSurface: AppColors.slate100,
    onInverseSurface: AppColors.slate900,
    inversePrimary: AppColors.primaryContainer,
  );

  static ColorScheme get _lightColorScheme => const ColorScheme(
    brightness: Brightness.light,
    primary: AppColors.primary,
    onPrimary: AppColors.onPrimary,
    primaryContainer: Color(0xFFDBEAFE), // blue-100
    onPrimaryContainer: Color(0xFF1E3A5F),
    secondary: AppColors.slate600,
    onSecondary: AppColors.lightSurface,
    secondaryContainer: AppColors.lightSurfaceContainer,
    onSecondaryContainer: AppColors.slate700,
    tertiary: AppColors.info,
    onTertiary: AppColors.onInfo,
    tertiaryContainer: Color(0xFFCFFAFE),
    onTertiaryContainer: Color(0xFF164E63),
    error: AppColors.error,
    onError: AppColors.onError,
    errorContainer: Color(0xFFFEE2E2),
    onErrorContainer: Color(0xFF7F1D1D),
    surface: AppColors.lightSurface,
    onSurface: AppColors.lightOnSurface,
    surfaceContainerHighest: AppColors.lightSurfaceVariant,
    onSurfaceVariant: AppColors.lightOnSurfaceVariant,
    outline: AppColors.lightOutline,
    outlineVariant: AppColors.lightOutlineVariant,
    shadow: Color(0xFF0F172A),
    scrim: Colors.black,
    inverseSurface: AppColors.slate800,
    onInverseSurface: AppColors.slate100,
    inversePrimary: Color(0xFF93C5FD), // blue-300
  );

  // ─── Shared component themes ──────────────────────────────────────────────

  static AppBarTheme _appBarTheme(ColorScheme cs) => AppBarTheme(
    backgroundColor: cs.surface,
    foregroundColor: cs.onSurface,
    elevation: 0,
    scrolledUnderElevation: 0,
    systemOverlayStyle: cs.brightness == Brightness.dark
        ? SystemUiOverlayStyle.light
        : SystemUiOverlayStyle.dark,
    titleTextStyle: AppTypography.titleLarge.copyWith(color: cs.onSurface),
    iconTheme: IconThemeData(color: cs.onSurface),
    actionsIconTheme: IconThemeData(color: cs.onSurface),
    centerTitle: true,
  );

  static ElevatedButtonThemeData _elevatedButtonTheme(ColorScheme cs) =>
      ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: cs.primary,
          foregroundColor: cs.onPrimary,
          disabledBackgroundColor: cs.onSurface.withValues(alpha: 0.12),
          disabledForegroundColor: cs.onSurface.withValues(alpha: 0.38),
          elevation: 0,
          shadowColor: Colors.transparent,
          padding: AppSpacing.buttonPadding,
          textStyle: AppTypography.button,
          shape: AppRadius.shapeLg,
          minimumSize: const Size(0, 52),
        ),
      );

  static FilledButtonThemeData _filledButtonTheme(ColorScheme cs) =>
      FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: cs.primary,
          foregroundColor: cs.onPrimary,
          padding: AppSpacing.buttonPadding,
          textStyle: AppTypography.button,
          shape: AppRadius.shapeLg,
          minimumSize: const Size(0, 52),
        ),
      );

  static OutlinedButtonThemeData _outlinedButtonTheme(ColorScheme cs) =>
      OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: cs.primary,
          side: BorderSide(color: cs.outline, width: 1.5),
          padding: AppSpacing.buttonPadding,
          textStyle: AppTypography.button,
          shape: AppRadius.shapeLg,
          minimumSize: const Size(0, 52),
        ),
      );

  static TextButtonThemeData _textButtonTheme(ColorScheme cs) =>
      TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: cs.primary,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
          textStyle: AppTypography.button,
          shape: AppRadius.shapeMd,
          minimumSize: const Size(0, 40),
        ),
      );

  static CardThemeData _cardTheme(ColorScheme cs) => CardThemeData(
    color: cs.surface,
    surfaceTintColor: Colors.transparent,
    elevation: 0,
    shape: AppRadius.shapeLg,
    margin: EdgeInsets.zero,
  );

  static InputDecorationTheme _inputDecorationTheme(
    ColorScheme cs,
  ) => InputDecorationTheme(
    filled: true,
    fillColor: cs.brightness == Brightness.dark
        ? AppColors.darkSurface
        : AppColors.lightSurfaceVariant,
    contentPadding: AppSpacing.inputPadding,
    border: OutlineInputBorder(
      borderRadius: AppRadius.brMd,
      borderSide: BorderSide(color: cs.outline),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: AppRadius.brMd,
      borderSide: BorderSide(color: cs.outline),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: AppRadius.brMd,
      borderSide: BorderSide(color: cs.primary, width: 2),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: AppRadius.brMd,
      borderSide: BorderSide(color: cs.error),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: AppRadius.brMd,
      borderSide: BorderSide(color: cs.error, width: 2),
    ),
    hintStyle: AppTypography.bodyMedium.copyWith(color: cs.onSurfaceVariant),
    labelStyle: AppTypography.bodyMedium.copyWith(color: cs.onSurfaceVariant),
    floatingLabelStyle: AppTypography.labelMedium.copyWith(color: cs.primary),
    helperStyle: AppTypography.bodySmall.copyWith(color: cs.onSurfaceVariant),
    errorStyle: AppTypography.bodySmall.copyWith(color: cs.error),
    isDense: false,
  );

  static ChipThemeData _chipTheme(ColorScheme cs) => ChipThemeData(
    backgroundColor: cs.brightness == Brightness.dark
        ? AppColors.darkSurfaceVariant
        : AppColors.lightSurfaceContainer,
    selectedColor: AppColors.primarySubtle,
    labelStyle: AppTypography.labelMedium.copyWith(color: cs.onSurface),
    padding: AppSpacing.chipPadding,
    shape: const RoundedRectangleBorder(borderRadius: AppRadius.brPill),
    side: BorderSide.none,
    elevation: 0,
  );

  static BottomNavigationBarThemeData _bottomNavTheme(ColorScheme cs) =>
      BottomNavigationBarThemeData(
        backgroundColor: cs.surface,
        selectedItemColor: cs.primary,
        unselectedItemColor: cs.onSurfaceVariant,
        selectedLabelStyle: AppTypography.labelSmall,
        unselectedLabelStyle: AppTypography.labelSmall,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
      );

  static NavigationBarThemeData _navigationBarTheme(ColorScheme cs) =>
      NavigationBarThemeData(
        backgroundColor: cs.surface,
        indicatorColor: AppColors.primarySubtle,
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return IconThemeData(color: cs.primary);
          }
          return IconThemeData(color: cs.onSurfaceVariant);
        }),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppTypography.labelSmall.copyWith(color: cs.primary);
          }
          return AppTypography.labelSmall.copyWith(color: cs.onSurfaceVariant);
        }),
        elevation: 0,
        height: 72,
      );

  static DividerThemeData _dividerTheme(ColorScheme cs) => DividerThemeData(
    color: cs.outline,
    thickness: 1,
    space: 1,
  );

  static SnackBarThemeData _snackBarTheme(ColorScheme cs) => SnackBarThemeData(
    backgroundColor: cs.inverseSurface,
    contentTextStyle: AppTypography.bodyMedium.copyWith(
      color: cs.onInverseSurface,
    ),
    shape: AppRadius.shapeMd,
    behavior: SnackBarBehavior.floating,
  );

  static DialogThemeData _dialogTheme(ColorScheme cs) => DialogThemeData(
    backgroundColor: cs.surface,
    surfaceTintColor: Colors.transparent,
    elevation: 0,
    shape: AppRadius.shapeXl,
    titleTextStyle: AppTypography.titleLarge.copyWith(color: cs.onSurface),
    contentTextStyle: AppTypography.bodyMedium.copyWith(
      color: cs.onSurfaceVariant,
    ),
  );

  static BottomSheetThemeData _bottomSheetTheme(ColorScheme cs) =>
      BottomSheetThemeData(
        backgroundColor: cs.surface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppRadius.xl),
          ),
        ),
      );

  static SwitchThemeData _switchTheme(ColorScheme cs) => SwitchThemeData(
    thumbColor: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) return cs.onPrimary;
      return cs.onSurfaceVariant;
    }),
    trackColor: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) return cs.primary;
      return cs.surfaceContainerHighest;
    }),
  );

  static CheckboxThemeData _checkboxTheme(ColorScheme cs) => CheckboxThemeData(
    fillColor: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) return cs.primary;
      return Colors.transparent;
    }),
    checkColor: WidgetStateProperty.all(cs.onPrimary),
    side: BorderSide(color: cs.outline, width: 2),
    shape: const RoundedRectangleBorder(borderRadius: AppRadius.brXs),
  );

  static RadioThemeData _radioTheme(ColorScheme cs) => RadioThemeData(
    fillColor: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) return cs.primary;
      return cs.onSurfaceVariant;
    }),
  );

  static ProgressIndicatorThemeData _progressIndicatorTheme(ColorScheme cs) =>
      ProgressIndicatorThemeData(
        color: cs.primary,
        linearTrackColor: cs.surfaceContainerHighest,
        circularTrackColor: cs.surfaceContainerHighest,
        linearMinHeight: 6,
      );

  // ─── ThemeData builders ───────────────────────────────────────────────────

  static ThemeData get light {
    final cs = _lightColorScheme;
    return ThemeData(
      useMaterial3: true,
      colorScheme: cs,
      scaffoldBackgroundColor: AppColors.lightBackground,
      textTheme: AppTypography.textTheme.apply(
        bodyColor: cs.onSurface,
        displayColor: cs.onSurface,
      ),
      appBarTheme: _appBarTheme(cs),
      elevatedButtonTheme: _elevatedButtonTheme(cs),
      filledButtonTheme: _filledButtonTheme(cs),
      outlinedButtonTheme: _outlinedButtonTheme(cs),
      textButtonTheme: _textButtonTheme(cs),
      cardTheme: _cardTheme(cs),
      inputDecorationTheme: _inputDecorationTheme(cs),
      chipTheme: _chipTheme(cs),
      bottomNavigationBarTheme: _bottomNavTheme(cs),
      navigationBarTheme: _navigationBarTheme(cs),
      dividerTheme: _dividerTheme(cs),
      snackBarTheme: _snackBarTheme(cs),
      dialogTheme: _dialogTheme(cs),
      bottomSheetTheme: _bottomSheetTheme(cs),
      switchTheme: _switchTheme(cs),
      checkboxTheme: _checkboxTheme(cs),
      radioTheme: _radioTheme(cs),
      progressIndicatorTheme: _progressIndicatorTheme(cs),
      splashColor: cs.primary.withValues(alpha: 0.08),
      highlightColor: Colors.transparent,
      fontFamily: 'Inter',
    );
  }

  static ThemeData get dark {
    final cs = _darkColorScheme;
    return ThemeData(
      useMaterial3: true,
      colorScheme: cs,
      scaffoldBackgroundColor: AppColors.darkBackground,
      textTheme: AppTypography.textTheme.apply(
        bodyColor: cs.onSurface,
        displayColor: cs.onSurface,
      ),
      appBarTheme: _appBarTheme(cs),
      elevatedButtonTheme: _elevatedButtonTheme(cs),
      filledButtonTheme: _filledButtonTheme(cs),
      outlinedButtonTheme: _outlinedButtonTheme(cs),
      textButtonTheme: _textButtonTheme(cs),
      cardTheme: _cardTheme(cs),
      inputDecorationTheme: _inputDecorationTheme(cs),
      chipTheme: _chipTheme(cs),
      bottomNavigationBarTheme: _bottomNavTheme(cs),
      navigationBarTheme: _navigationBarTheme(cs),
      dividerTheme: _dividerTheme(cs),
      snackBarTheme: _snackBarTheme(cs),
      dialogTheme: _dialogTheme(cs),
      bottomSheetTheme: _bottomSheetTheme(cs),
      switchTheme: _switchTheme(cs),
      checkboxTheme: _checkboxTheme(cs),
      radioTheme: _radioTheme(cs),
      progressIndicatorTheme: _progressIndicatorTheme(cs),
      splashColor: cs.primary.withValues(alpha: 0.08),
      highlightColor: Colors.transparent,
      fontFamily: 'Inter',
    );
  }
}
