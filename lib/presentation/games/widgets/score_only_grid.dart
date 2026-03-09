import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:netstats_pro/core/design_system/design_system.dart';
import 'package:netstats_pro/domain/entities/game.dart';
import 'package:netstats_pro/domain/entities/match_event.dart';

class ScoreOnlyGrid extends StatelessWidget {
  const ScoreOnlyGrid({
    required this.game,
    required this.onStatSelected,
    required this.homeColor,
    required this.awayColor,
    this.isSpecialScoringActive = false,
    this.isHomePowerPlayActive = false,
    this.isAwayPowerPlayActive = false,
    super.key,
  });

  final Game game;
  final Color homeColor;
  final Color awayColor;
  final bool isSpecialScoringActive;
  final bool isHomePowerPlayActive;
  final bool isAwayPowerPlayActive;
  final void Function(MatchEventType type, {required bool isHome})
  onStatSelected;

  @override
  Widget build(BuildContext context) {
    final show2pt = game.format != GameFormat.sevenAside || game.isSuperShot;
    final show3pt = game.format == GameFormat.fiveAside;
    final is2ptEnabled =
        game.format != GameFormat.sevenAside || isSpecialScoringActive;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        children: [
          _ScoreStepper(
            game: game,
            label: '1PT',
            subLabel: 'GOAL',
            onHomeTap: () => onStatSelected(MatchEventType.goal, isHome: true),
            onAwayTap: () => onStatSelected(MatchEventType.goal, isHome: false),
            homeColor: homeColor,
            awayColor: awayColor,
            isHomePowerPlay: isHomePowerPlayActive || isSpecialScoringActive,
            isAwayPowerPlay: isAwayPowerPlayActive || isSpecialScoringActive,
          ),
          if (show2pt) ...[
            AppSpacing.vGap16,
            _ScoreStepper(
              game: game,
              label: '2PT',
              subLabel: 'GOAL',
              icon: game.format == GameFormat.sixAside ? null : Icons.bolt,
              isEnabled: is2ptEnabled,
              onHomeTap: () =>
                  onStatSelected(MatchEventType.goal2pt, isHome: true),
              onAwayTap: () =>
                  onStatSelected(MatchEventType.goal2pt, isHome: false),
              homeColor: homeColor,
              awayColor: awayColor,
              isHomePowerPlay: isHomePowerPlayActive || isSpecialScoringActive,
              isAwayPowerPlay: isAwayPowerPlayActive || isSpecialScoringActive,
            ),
          ],
          if (show3pt) ...[
            AppSpacing.vGap16,
            _ScoreStepper(
              game: game,
              label: '3PT',
              subLabel: 'GOAL',
              icon: Icons.bolt,
              onHomeTap: () =>
                  onStatSelected(MatchEventType.goal3pt, isHome: true),
              onAwayTap: () =>
                  onStatSelected(MatchEventType.goal3pt, isHome: false),
              homeColor: homeColor,
              awayColor: awayColor,
              isHomePowerPlay: isHomePowerPlayActive || isSpecialScoringActive,
              isAwayPowerPlay: isAwayPowerPlayActive || isSpecialScoringActive,
            ),
          ],
          Padding(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
            child: Divider(
              color: Theme.of(
                context,
              ).colorScheme.outlineVariant.withValues(alpha: 0.5),
              thickness: 1,
            ),
          ),
          _ScoreStepper(
            game: game,
            label: '1PT',
            subLabel: 'CORRECTION',
            isDecrement: true,
            onHomeTap: () =>
                onStatSelected(MatchEventType.adjustment, isHome: true),
            onAwayTap: () =>
                onStatSelected(MatchEventType.adjustment, isHome: false),
            homeColor: homeColor,
            awayColor: awayColor,
          ),
        ],
      ),
    );
  }
}

class _ScoreStepper extends StatelessWidget {
  const _ScoreStepper({
    required this.game,
    required this.label,
    required this.onHomeTap,
    required this.onAwayTap,
    required this.homeColor,
    required this.awayColor,
    this.subLabel,
    this.icon,
    this.isDecrement = false,
    this.isEnabled = true,
    this.isHomePowerPlay = false,
    this.isAwayPowerPlay = false,
  });

  final Game game;

  final String label;
  final String? subLabel;
  final IconData? icon;
  final VoidCallback onHomeTap;
  final VoidCallback onAwayTap;
  final Color homeColor;
  final Color awayColor;
  final bool isDecrement;
  final bool isEnabled;
  final bool isHomePowerPlay;
  final bool isAwayPowerPlay;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Row(
      children: [
        // Home Increment/Decrement
        Expanded(
          child: _StepButton(
            icon: isDecrement ? Icons.remove : (_getIcon(context)),
            color: _getColor(cs),
            onTap: onHomeTap,
            isEnabled: isEnabled,
            isPowerPlayBadgeVisible: _isPowerPlayBadgeVisible(isHomePowerPlay),
          ),
        ),

        // Center Label
        SizedBox(
          width: 120,
          child: Opacity(
            opacity: isEnabled ? 1.0 : 0.4,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  label,
                  style: AppTypography.headlineSmall.copyWith(
                    fontWeight: FontWeight.w900,
                    color: cs.onSurface,
                  ),
                ),
                if (subLabel != null)
                  Text(
                    subLabel!.toUpperCase(),
                    style: AppTypography.labelSmall.copyWith(
                      color: cs.onSurfaceVariant.withValues(alpha: 0.6),
                      letterSpacing: 0.5,
                    ),
                  ),
              ],
            ),
          ),
        ),

        // Away Increment/Decrement
        Expanded(
          child: _StepButton(
            icon: isDecrement
                ? Icons.remove
                : (_getIcon(context, isAway: true)),
            color: _getColor(cs, isAway: true),
            onTap: onAwayTap,
            isEnabled: isEnabled,
            isPowerPlayBadgeVisible: _isPowerPlayBadgeVisible(isAwayPowerPlay),
          ),
        ),
      ],
    );
  }

  IconData _getIcon(BuildContext context, {bool isAway = false}) {
    // 1PT always remains standard plus icon in 7-aside
    if (label == '1PT' && game.format == GameFormat.sevenAside) {
      return Icons.add;
    }

    // 2PT always uses bolt icon in 7-aside
    if (label == '2PT' && game.format == GameFormat.sevenAside) {
      return Icons.bolt;
    }

    final isPowerPlay = isAway ? isAwayPowerPlay : isHomePowerPlay;
    if (!isPowerPlay) return Icons.add;

    // 5-aside Power Play (or other formats) uses flame
    return Icons.whatshot;
  }

  Color _getColor(ColorScheme cs, {bool isAway = false}) {
    if (isDecrement) return cs.error;
    final isPowerPlay = isAway ? isAwayPowerPlay : isHomePowerPlay;

    if (isPowerPlay) {
      // 7-aside Super Shot 1PT stays green, 2PT uses warning/orange
      if (game.format == GameFormat.sevenAside) {
        return label == '1PT' ? AppColors.success : AppColors.warning;
      }
      return AppColors.warning;
    }

    return AppColors.success;
  }

  bool _isPowerPlayBadgeVisible(bool isActive) {
    if (isDecrement) return false;
    if (!isActive) return false;

    // No x2 badge for 7-aside Super Shot or 6-aside
    if (game.format != GameFormat.fiveAside) return false;

    return true;
  }
}

class _StepButton extends StatelessWidget {
  const _StepButton({
    required this.icon,
    required this.color,
    required this.onTap,
    this.isEnabled = true,
    this.isPowerPlayBadgeVisible = false,
  });

  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  final bool isEnabled;
  final bool isPowerPlayBadgeVisible;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return SizedBox(
      height: 72,
      child: Material(
        color: isEnabled
            ? color.withValues(alpha: 0.15)
            : cs.surfaceContainerHighest.withValues(alpha: 0.1),
        borderRadius: AppRadius.brLg,
        child: InkWell(
          onTap: isEnabled
              ? () {
                  unawaited(HapticFeedback.lightImpact());
                  onTap();
                }
              : null,
          borderRadius: AppRadius.brLg,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: AppRadius.brLg,
              border: Border.all(
                color: isEnabled
                    ? color.withValues(alpha: 0.5)
                    : cs.outline.withValues(alpha: 0.2),
                width: 1.5,
              ),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Icon(
                  icon,
                  color: isEnabled ? color : cs.outline.withValues(alpha: 0.3),
                  size: 32,
                ),
                if (isPowerPlayBadgeVisible && isEnabled)
                  Positioned(
                    right: 8,
                    top: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 4,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: color,
                        borderRadius: AppRadius.brSm,
                      ),
                      child: Text(
                        'x2',
                        style: AppTypography.labelMedium.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                          fontSize: 10,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
