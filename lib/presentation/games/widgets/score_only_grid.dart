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
    final colorHome = isDecrement
        ? cs.error
        : (isHomePowerPlay ? AppColors.warning : AppColors.success);
    final colorAway = isDecrement
        ? cs.error
        : (isAwayPowerPlay ? AppColors.warning : AppColors.success);

    return Row(
      children: [
        // Home Increment/Decrement
        Expanded(
          child: _StepButton(
            icon: isDecrement
                ? Icons.remove
                : (isHomePowerPlay ? Icons.whatshot : Icons.add),
            color: colorHome,
            onTap: onHomeTap,
            isEnabled: isEnabled,
            isPowerPlay: !isDecrement && isHomePowerPlay,
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
                : (isAwayPowerPlay ? Icons.whatshot : Icons.add),
            color: colorAway,
            onTap: onAwayTap,
            isEnabled: isEnabled,
            isPowerPlay: !isDecrement && isAwayPowerPlay,
          ),
        ),
      ],
    );
  }
}

class _StepButton extends StatelessWidget {
  const _StepButton({
    required this.icon,
    required this.color,
    required this.onTap,
    this.isEnabled = true,
    this.isPowerPlay = false,
  });

  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  final bool isEnabled;
  final bool isPowerPlay;

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
                color: color.withValues(alpha: 0.5),
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
                if (isPowerPlay && isEnabled)
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
