import 'package:flutter/material.dart';
import 'package:netstats_pro/core/design_system/tokens/app_colors.dart';

/// AppColors compatibility shim.
/// New code should use AppColors from the design system directly:
///   import 'package:netstats_pro/core/design_system/design_system.dart';
export 'package:netstats_pro/core/design_system/tokens/app_colors.dart'
    show AppColors;

/// NetStatsColors — kept for backward compatibility.
/// @Deprecated Prefer AppColors in new code.
class NetStatsColors {
  static const Color primary = AppColors.primary;
  static const Color accentTeal = AppColors.info;
  static const Color accentCoral = AppColors.error;
  static const Color backgroundDark = AppColors.darkBackground;
  static const Color backgroundLight = AppColors.lightBackground;
  static const Color staminaPurple = Color(0xFF8B5CF6);
}
