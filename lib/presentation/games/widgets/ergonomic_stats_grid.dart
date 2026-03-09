import 'package:flutter/material.dart';
import 'package:netstats_pro/core/design_system/design_system.dart';
import 'package:netstats_pro/domain/entities/match_event.dart';

class ErgonomicStatsGrid extends StatelessWidget {
  const ErgonomicStatsGrid({
    required this.onStatSelected,
    this.isActivePlayerSelected = false,
    this.activeTeamColor,
    super.key,
  });

  final bool isActivePlayerSelected;
  final Color? activeTeamColor;
  final void Function(MatchEventType) onStatSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.5),
        borderRadius: AppRadius.brXl,
        border: Border.all(
          color: Theme.of(
            context,
          ).colorScheme.outlineVariant.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Offensive Stats Row
          Row(
            children: [
              Expanded(
                child: _buildErgoButton(
                  context,
                  MatchEventType.goal,
                  'Goal',
                  Icons.sports_score,
                  teamColor: activeTeamColor,
                ),
              ),
              AppSpacing.hGap8,
              Expanded(
                child: _buildErgoButton(
                  context,
                  MatchEventType.assist,
                  'Assist',
                  Icons.handshake,
                  teamColor: activeTeamColor,
                ),
              ),
            ],
          ),
          AppSpacing.vGap8,
          // Defensive Row
          Row(
            children: [
              Expanded(
                child: _buildErgoButton(
                  context,
                  MatchEventType.intercept,
                  'Intercept',
                  Icons.back_hand,
                  teamColor: activeTeamColor,
                ),
              ),
              AppSpacing.hGap8,
              Expanded(
                child: _buildErgoButton(
                  context,
                  MatchEventType.deflection,
                  'Deflect',
                  Icons.touch_app,
                  teamColor: activeTeamColor,
                ),
              ),
            ],
          ),
          AppSpacing.vGap8,
          Row(
            children: [
              Expanded(
                child: _buildErgoButton(
                  context,
                  MatchEventType.offensiveRebound,
                  'Off. Reb',
                  Icons.arrow_upward,
                  teamColor: activeTeamColor,
                ),
              ),
              AppSpacing.hGap8,
              Expanded(
                child: _buildErgoButton(
                  context,
                  MatchEventType.defensiveRebound,
                  'Def. Reb',
                  Icons.arrow_upward,
                  teamColor: activeTeamColor,
                ),
              ),
            ],
          ),
          AppSpacing.vGap8,
          Row(
            children: [
              Expanded(
                child: _buildErgoButton(
                  context,
                  MatchEventType.pickup,
                  'Pickup',
                  Icons.pan_tool_alt,
                  teamColor: activeTeamColor,
                ),
              ),
              AppSpacing.hGap8,
              Expanded(
                child: _buildErgoButton(
                  context,
                  MatchEventType.centerPass,
                  'Centre',
                  Icons.adjust,
                  isNeutralStat: true,
                ),
              ),
            ],
          ),
          AppSpacing.vGap16,

          // Errors / Penalties Section (Negative)
          Row(
            children: [
              Expanded(
                child: _buildErgoButton(
                  context,
                  MatchEventType.miss,
                  'Miss',
                  Icons.close,
                  isNegativeStat: true,
                ),
              ),
              AppSpacing.hGap8,
              Expanded(
                child: _buildErgoButton(
                  context,
                  MatchEventType.turnover,
                  'Turnover',
                  Icons.sync_problem,
                  isNegativeStat: true,
                ),
              ),
            ],
          ),
          AppSpacing.vGap8,
          Row(
            children: [
              Expanded(
                child: _buildErgoButton(
                  context,
                  MatchEventType.penaltyContact,
                  'Contact',
                  Icons.gavel,
                  isNegativeStat: true,
                ),
              ),
              AppSpacing.hGap8,
              Expanded(
                child: _buildErgoButton(
                  context,
                  MatchEventType.penaltyObstruction,
                  'Obstruct',
                  Icons.front_hand,
                  isNegativeStat: true,
                ),
              ),
            ],
          ),
          AppSpacing.vGap8,
          Row(
            children: [
              Expanded(
                child: _buildErgoButton(
                  context,
                  MatchEventType.heldBall,
                  'Held Ball',
                  Icons.timer_off,
                  isNegativeStat: true,
                ),
              ),
              const Spacer(),
            ],
          ),

          AppSpacing.vGap24,

          // Dominant Thumb-Zone GOAL Button (Refined/Toned Down)
          SizedBox(
            width: double.infinity,
            height: 120,
            child: AppCard(
              onTap: () => onStatSelected(MatchEventType.goal),
              borderRadius: AppRadius.brXxl,
              padding: EdgeInsets.zero,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: AppRadius.brXxl,
                  border: Border.all(
                    color:
                        activeTeamColor ??
                        Theme.of(context).colorScheme.primary,
                    width: 3,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.sports_basketball,
                      size: 40,
                      color:
                          activeTeamColor ??
                          Theme.of(context).colorScheme.primary,
                    ),
                    AppSpacing.vGap4,
                    Text(
                      'GOAL',
                      style: AppTypography.displaySmall.copyWith(
                        color: Theme.of(context).colorScheme.onSurface,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 4,
                        fontSize: 32,
                      ),
                    ),
                    Text(
                      'Tap to record',
                      style: AppTypography.labelSmall.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                        letterSpacing: 1,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErgoButton(
    BuildContext context,
    MatchEventType type,
    String label,
    IconData icon, {
    Color? teamColor,
    bool isNegativeStat = false,
    bool isNeutralStat = false,
  }) {
    final cs = Theme.of(context).colorScheme;

    // Determine accent color (border and icon)
    final Color accentColor;
    if (isNegativeStat) {
      accentColor = AppColors.error;
    } else if (isNeutralStat) {
      accentColor = cs.outline;
    } else {
      accentColor = teamColor ?? cs.primary;
    }

    return SizedBox(
      height: 64,
      child: Material(
        color: cs.surfaceContainerHighest.withValues(alpha: 0.3),
        borderRadius: AppRadius.brLg,
        child: InkWell(
          onTap: () => onStatSelected(type),
          borderRadius: AppRadius.brLg,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: AppRadius.brLg,
              border: Border.all(
                color: accentColor.withValues(alpha: 0.5),
                width: 1.5,
              ),
            ),
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 20, color: accentColor),
                AppSpacing.hGap8,
                Flexible(
                  child: Text(
                    label.toUpperCase(),
                    style: AppTypography.labelSmall.copyWith(
                      color: cs.onSurface,
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.5,
                    ),
                    overflow: TextOverflow.ellipsis,
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
