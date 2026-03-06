import 'package:flutter/material.dart';

class AppColors extends ThemeExtension<AppColors> {
  final Color brandPrimary;
  final Color surfaceSubtle;

  const AppColors({required this.brandPrimary, required this.surfaceSubtle});

  @override
  ThemeExtension<AppColors> copyWith({
    Color? brandPrimary,
    Color? surfaceSubtle,
  }) {
    return AppColors(
      brandPrimary: brandPrimary ?? this.brandPrimary,
      surfaceSubtle: surfaceSubtle ?? this.surfaceSubtle,
    );
  }

  @override
  ThemeExtension<AppColors> lerp(
    covariant ThemeExtension<AppColors>? other,
    double t,
  ) {
    if (other is! AppColors) {
      return this;
    }
    return AppColors(
      brandPrimary: Color.lerp(brandPrimary, other.brandPrimary, t)!,
      surfaceSubtle: Color.lerp(surfaceSubtle, other.surfaceSubtle, t)!,
    );
  }
}

// Usage in ThemeData:
// ThemeData(
//   extensions: const <ThemeExtension<dynamic>>[
//     AppColors(
//       brandPrimary: Color(0xFF00FF00),
//       surfaceSubtle: Color(0xFFF0F0F0),
//     ),
//   ],
// )

// Usage in UI:
// final colors = Theme.of(context).extension<AppColors>()!;
// colors.brandPrimary
