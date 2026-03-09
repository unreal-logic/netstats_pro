import 'package:flutter/material.dart';
import 'package:netstats_pro/core/design_system/tokens/app_spacing.dart';
import 'package:netstats_pro/core/design_system/tokens/app_typography.dart';

/// AppButton variant enum
enum AppButtonVariant { primary, secondary, outlined, ghost, danger }

/// AppButton size enum
enum AppButtonSize { sm, md, lg }

/// AppButton — Unified button component
///
/// Wraps Material 3 button types with consistent design system tokens.
///
/// ```dart
/// AppButton(
///   label: 'Continue',
///   onPressed: () {},
/// )
///
/// AppButton(
///   label: 'Cancel',
///   variant: AppButtonVariant.outlined,
///   onPressed: () {},
/// )
/// ```
class AppButton extends StatelessWidget {
  const AppButton({
    required this.label,
    super.key,
    this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.size = AppButtonSize.md,
    this.prefixIcon,
    this.suffixIcon,
    this.isLoading = false,
    this.isFullWidth = true,
  });

  final String label;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final AppButtonSize size;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final bool isLoading;
  final bool isFullWidth;

  // ─── Sizing helpers ───────────────────────────────────────────────────────

  EdgeInsets get _padding => switch (size) {
    AppButtonSize.sm => const EdgeInsets.symmetric(
      horizontal: AppSpacing.md,
      vertical: AppSpacing.sm,
    ),
    AppButtonSize.md => AppSpacing.buttonPadding,
    AppButtonSize.lg => const EdgeInsets.symmetric(
      horizontal: AppSpacing.xl,
      vertical: AppSpacing.px20,
    ),
  };

  double get _minHeight => switch (size) {
    AppButtonSize.sm => 36,
    AppButtonSize.md => 52,
    AppButtonSize.lg => 58,
  };

  TextStyle get _textStyle => switch (size) {
    AppButtonSize.sm => AppTypography.labelMedium,
    AppButtonSize.md => AppTypography.button,
    AppButtonSize.lg => AppTypography.button.copyWith(fontSize: 15),
  };

  double get _iconSize => switch (size) {
    AppButtonSize.sm => 16,
    AppButtonSize.md => 18,
    AppButtonSize.lg => 20,
  };

  // ─── Build ────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    final Widget child = isLoading
        ? SizedBox(
            width: _iconSize,
            height: _iconSize,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: _loaderColor(cs),
            ),
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (prefixIcon != null) ...[
                Icon(prefixIcon, size: _iconSize),
                const SizedBox(width: AppSpacing.sm),
              ],
              Flexible(
                child: Text(
                  label,
                  style: _textStyle,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
              if (suffixIcon != null) ...[
                const SizedBox(width: AppSpacing.sm),
                Icon(suffixIcon, size: _iconSize),
              ],
            ],
          );

    final btn = _buildButton(context, cs, child);
    return isFullWidth ? SizedBox(width: double.infinity, child: btn) : btn;
  }

  Color _loaderColor(ColorScheme cs) => switch (variant) {
    AppButtonVariant.primary => cs.onPrimary,
    AppButtonVariant.secondary => cs.onPrimary,
    AppButtonVariant.outlined => cs.primary,
    AppButtonVariant.ghost => cs.primary,
    AppButtonVariant.danger => cs.onError,
  };

  Widget _buildButton(BuildContext context, ColorScheme cs, Widget child) {
    const shape = AppRadius.shapeLg;
    final minSize = Size(0, _minHeight);

    return switch (variant) {
      AppButtonVariant.primary => FilledButton(
        onPressed: isLoading ? null : onPressed,
        style:
            FilledButton.styleFrom(
              backgroundColor: cs.primary,
              foregroundColor: cs.onPrimary,
              padding: _padding,
              shape: shape,
              minimumSize: minSize,
              shadowColor: Colors.transparent,
            ).copyWith(
              overlayColor: WidgetStateProperty.all(
                cs.onPrimary.withValues(alpha: 0.1),
              ),
            ),
        child: child,
      ),

      AppButtonVariant.secondary => FilledButton(
        onPressed: isLoading ? null : onPressed,
        style: FilledButton.styleFrom(
          backgroundColor: cs.secondaryContainer,
          foregroundColor: cs.onSecondaryContainer,
          padding: _padding,
          shape: shape,
          minimumSize: minSize,
          shadowColor: Colors.transparent,
        ),
        child: child,
      ),

      AppButtonVariant.outlined => OutlinedButton(
        onPressed: isLoading ? null : onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: cs.primary,
          side: BorderSide(color: cs.outline, width: 1.5),
          padding: _padding,
          shape: shape,
          minimumSize: minSize,
        ),
        child: child,
      ),

      AppButtonVariant.ghost => TextButton(
        onPressed: isLoading ? null : onPressed,
        style: TextButton.styleFrom(
          foregroundColor: cs.primary,
          padding: _padding,
          shape: shape,
          minimumSize: minSize,
        ),
        child: child,
      ),

      AppButtonVariant.danger => FilledButton(
        onPressed: isLoading ? null : onPressed,
        style: FilledButton.styleFrom(
          backgroundColor: cs.error,
          foregroundColor: cs.onError,
          padding: _padding,
          shape: shape,
          minimumSize: minSize,
          shadowColor: Colors.transparent,
        ),
        child: child,
      ),
    };
  }
}

/// AppIconButton — circular icon button with variants
class AppIconButton extends StatelessWidget {
  const AppIconButton({
    required this.icon,
    super.key,
    this.onPressed,
    this.variant = AppButtonVariant.ghost,
    this.size = 40.0,
    this.tooltip,
  });

  final IconData icon;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final double size;
  final String? tooltip;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    final bg = switch (variant) {
      AppButtonVariant.primary => cs.primary,
      AppButtonVariant.secondary => cs.secondaryContainer,
      AppButtonVariant.outlined => Colors.transparent,
      AppButtonVariant.ghost => cs.surfaceContainerHighest,
      AppButtonVariant.danger => cs.error,
    };

    final fg = switch (variant) {
      AppButtonVariant.primary => cs.onPrimary,
      AppButtonVariant.secondary => cs.onSecondaryContainer,
      AppButtonVariant.outlined => cs.primary,
      AppButtonVariant.ghost => cs.onSurfaceVariant,
      AppButtonVariant.danger => cs.onError,
    };

    final Widget btn = Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: bg,
        shape: BoxShape.circle,
        border: variant == AppButtonVariant.outlined
            ? Border.all(color: cs.outline, width: 1.5)
            : null,
      ),
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(icon, color: fg, size: size * 0.48),
        padding: EdgeInsets.zero,
        style: IconButton.styleFrom(
          shape: const CircleBorder(),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
      ),
    );

    return tooltip != null ? Tooltip(message: tooltip, child: btn) : btn;
  }
}
