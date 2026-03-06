import 'package:flutter/material.dart';
import 'package:netstats_pro/core/design_system/tokens/app_colors.dart';
import 'package:netstats_pro/core/design_system/tokens/app_spacing.dart';
import 'package:netstats_pro/core/design_system/tokens/app_typography.dart';

// ─────────────────────────────────────────────────────────────────────────────
// AppCard
// ─────────────────────────────────────────────────────────────────────────────

/// AppCard — surface container with optional border and padding
///
/// ```dart
/// AppCard(
///   child: Text('Hello'),
/// )
/// ```
class AppCard extends StatelessWidget {
  const AppCard({
    required this.child,
    super.key,
    this.padding,
    this.hasBorder = true,
    this.isSelected = false,
    this.onTap,
    this.borderRadius,
  });

  final Widget child;
  final EdgeInsets? padding;
  final bool hasBorder;
  final bool isSelected;
  final VoidCallback? onTap;
  final BorderRadius? borderRadius;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final br = borderRadius ?? AppRadius.brLg;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      decoration: BoxDecoration(
        color: isSelected ? AppColors.primarySubtle : cs.surface,
        borderRadius: br,
        border: hasBorder
            ? Border.all(
                color: isSelected ? cs.primary : cs.outline,
                width: isSelected ? 2 : 1,
              )
            : null,
      ),
      child: Material(
        type: MaterialType.transparency,
        borderRadius: br,
        child: InkWell(
          onTap: onTap,
          borderRadius: br,
          splashColor: cs.primary.withValues(alpha: 0.06),
          highlightColor: Colors.transparent,
          child: Padding(
            padding: padding ?? AppSpacing.cardPaddingLg,
            child: child,
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// RadioTile
// ─────────────────────────────────────────────────────────────────────────────

/// RadioTile — the selection card from the Match Setup screen
///
/// Shows a radio indicator, title, badge label, and subtitle.
/// ```dart
/// RadioTile(
///   title: '7 Aside',
///   subtitle: 'Standard Match / Super Netball',
///   badgeLabel: '7 Players',
///   isSelected: true,
///   onTap: () {},
/// )
/// ```
class RadioTile extends StatelessWidget {
  const RadioTile({
    required this.title,
    required this.subtitle,
    required this.badgeLabel,
    required this.isSelected,
    required this.onTap,
    super.key,
    this.leadingIcon,
  });

  final String title;
  final String subtitle;
  final String badgeLabel;
  final bool isSelected;
  final VoidCallback onTap;
  final IconData? leadingIcon;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return AppCard(
      isSelected: isSelected,
      onTap: onTap,
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Row(
        children: [
          // Radio indicator
          AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: isSelected ? cs.primary : cs.outline,
                width: 2,
              ),
            ),
            child: isSelected
                ? Center(
                    child: Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: cs.primary,
                        shape: BoxShape.circle,
                      ),
                    ),
                  )
                : const SizedBox.shrink(),
          ),

          AppSpacing.hGap16,

          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      title.toUpperCase(),
                      style: AppTypography.titleSmall.copyWith(
                        color: isSelected ? cs.onSurface : cs.onSurfaceVariant,
                        letterSpacing: 0.5,
                      ),
                    ),
                    _BadgePill(label: badgeLabel, isSelected: isSelected),
                  ],
                ),
                AppSpacing.vGap4,
                Text(
                  subtitle,
                  style: AppTypography.bodySmall.copyWith(
                    color: cs.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _BadgePill extends StatelessWidget {
  const _BadgePill({required this.label, required this.isSelected});
  final String label;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: isSelected
            ? AppColors.primarySubtle
            : cs.surfaceContainerHighest,
        borderRadius: AppRadius.brPill,
      ),
      child: Text(
        label.toUpperCase(),
        style: AppTypography.labelSmall.copyWith(
          color: isSelected ? cs.primary : cs.onSurfaceVariant,
          letterSpacing: 1,
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// ProgressDots
// ─────────────────────────────────────────────────────────────────────────────

/// ProgressDots — step indicator (1 wide active dot + N small dots)
///
/// ```dart
/// ProgressDots(totalSteps: 4, currentStep: 0)
/// ```
class ProgressDots extends StatelessWidget {
  const ProgressDots({
    required this.totalSteps,
    required this.currentStep,
    super.key,
  });

  final int totalSteps;
  final int currentStep;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(totalSteps, (i) {
        final isActive = i == currentStep;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeInOut,
          width: isActive ? 32 : 6,
          height: 6,
          margin: const EdgeInsets.symmetric(horizontal: 3),
          decoration: BoxDecoration(
            color: isActive ? cs.primary : cs.surfaceContainerHighest,
            borderRadius: AppRadius.brPill,
          ),
        );
      }),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// AppChip
// ─────────────────────────────────────────────────────────────────────────────

enum AppChipVariant { filled, outlined, tonal }

/// AppChip — compact label pill with optional icon and selection state
class AppChip extends StatelessWidget {
  const AppChip({
    required this.label,
    super.key,
    this.icon,
    this.isSelected = false,
    this.onTap,
    this.variant = AppChipVariant.tonal,
    this.onDeleted,
  });

  final String label;
  final IconData? icon;
  final bool isSelected;
  final VoidCallback? onTap;
  final AppChipVariant variant;
  final VoidCallback? onDeleted;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    final bg = switch (variant) {
      AppChipVariant.filled =>
        isSelected ? cs.primary : cs.surfaceContainerHighest,
      AppChipVariant.outlined => Colors.transparent,
      AppChipVariant.tonal =>
        isSelected ? AppColors.primarySubtle : cs.surfaceContainerHighest,
    };

    final fg = switch (variant) {
      AppChipVariant.filled => isSelected ? cs.onPrimary : cs.onSurface,
      AppChipVariant.outlined => isSelected ? cs.primary : cs.onSurfaceVariant,
      AppChipVariant.tonal => isSelected ? cs.primary : cs.onSurface,
    };

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.xs + 2,
        ),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: AppRadius.brPill,
          border: variant == AppChipVariant.outlined
              ? Border.all(
                  color: isSelected ? cs.primary : cs.outline,
                  width: 1.5,
                )
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 14, color: fg),
              AppSpacing.hGap4,
            ],
            Text(label, style: AppTypography.labelMedium.copyWith(color: fg)),
            if (onDeleted != null) ...[
              AppSpacing.hGap4,
              GestureDetector(
                onTap: onDeleted,
                child: Icon(Icons.close, size: 14, color: fg),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// AppBadge
// ─────────────────────────────────────────────────────────────────────────────

enum AppBadgeColor { primary, success, warning, error, info, neutral }

/// AppBadge — status pill for counts or semantic status labels
class AppBadge extends StatelessWidget {
  const AppBadge({
    required this.label,
    super.key,
    this.color = AppBadgeColor.primary,
    this.icon,
  });

  final String label;
  final AppBadgeColor color;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final (bg, fg) = switch (color) {
      AppBadgeColor.primary => (AppColors.primarySubtle, AppColors.primary),
      AppBadgeColor.success => (const Color(0x1A22C55E), AppColors.success),
      AppBadgeColor.warning => (const Color(0x1AF59E0B), AppColors.warning),
      AppBadgeColor.error => (const Color(0x1AEF4444), AppColors.error),
      AppBadgeColor.info => (const Color(0x1A06B6D4), AppColors.info),
      AppBadgeColor.neutral => (
        Theme.of(context).colorScheme.surfaceContainerHighest,
        Theme.of(context).colorScheme.onSurfaceVariant,
      ),
    };

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: 3,
      ),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: AppRadius.brPill,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 10, color: fg),
            AppSpacing.hGap4,
          ],
          Text(
            label.toUpperCase(),
            style: AppTypography.labelSmall.copyWith(
              color: fg,
              letterSpacing: 1,
              fontSize: 9,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// AppDropdownTile
// ─────────────────────────────────────────────────────────────────────────────

/// AppDropdownTile — the tap-to-open selector row from Match Setup
///
/// ```dart
/// AppDropdownTile(
///   label: 'Competition',
///   placeholder: 'Select a Competition',
///   onTap: () {},
/// )
/// ```
class AppDropdownTile extends StatelessWidget {
  const AppDropdownTile({
    required this.label,
    super.key,
    this.placeholder,
    this.value,
    this.prefixIcon,
    this.onTap,
    this.hasError = false,
    this.errorText,
  });

  final String label;
  final String? placeholder;
  final String? value;
  final IconData? prefixIcon;
  final VoidCallback? onTap;
  final bool hasError;
  final String? errorText;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final hasValue = value != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label
        Text(
          label.toUpperCase(),
          style: AppTypography.sectionLabel.copyWith(
            color: cs.onSurfaceVariant,
          ),
        ),
        AppSpacing.vGap8,

        // Selector row
        GestureDetector(
          onTap: onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            padding: AppSpacing.inputPadding,
            decoration: BoxDecoration(
              color: isDark
                  ? AppColors.darkSurface
                  : cs.surfaceContainerHighest,
              borderRadius: AppRadius.brMd,
              border: Border.all(
                color: hasError ? cs.error : cs.outline,
              ),
            ),
            child: Row(
              children: [
                if (prefixIcon != null) ...[
                  Icon(prefixIcon, size: 20, color: cs.onSurfaceVariant),
                  AppSpacing.hGap12,
                ],
                Expanded(
                  child: Text(
                    hasValue ? value! : (placeholder ?? 'Select...'),
                    style: AppTypography.bodyMedium.copyWith(
                      color: hasValue ? cs.onSurface : cs.onSurfaceVariant,
                      fontWeight: hasValue ? FontWeight.w600 : FontWeight.w400,
                    ),
                  ),
                ),
                Icon(Icons.expand_more, size: 22, color: cs.onSurfaceVariant),
              ],
            ),
          ),
        ),

        if (hasError && errorText != null) ...[
          AppSpacing.vGap4,
          Text(
            errorText!,
            style: AppTypography.bodySmall.copyWith(color: cs.error),
          ),
        ],
      ],
    );
  }
}
