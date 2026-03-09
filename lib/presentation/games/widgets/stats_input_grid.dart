import 'package:flutter/material.dart';
import 'package:netstats_pro/core/design_system/design_system.dart';
import 'package:netstats_pro/domain/entities/match_event.dart';

class StatsInputGrid extends StatelessWidget {
  const StatsInputGrid({
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
    final cs = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: cs.surface.withValues(alpha: 0.5),
        borderRadius: AppRadius.brXl,
        border: Border.all(
          color: cs.outlineVariant.withValues(alpha: 0.3),
        ),
      ),
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Row 1: Primary Action (Goal) - Refined
            Row(
              children: [
                Expanded(
                  child: AppCard(
                    onTap: () => onStatSelected(MatchEventType.goal),
                    borderRadius: AppRadius.brLg,
                    padding: EdgeInsets.zero,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: AppSpacing.lg,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: AppRadius.brLg,
                        border: Border.all(
                          color: activeTeamColor ?? cs.primary,
                          width: 3,
                        ),
                      ),
                      child: Column(
                        children: [
                          Text(
                            'GOAL',
                            style: AppTypography.displaySmall.copyWith(
                              color: cs.onSurface,
                              fontWeight: FontWeight.w900,
                              fontSize: 32,
                              letterSpacing: 2,
                            ),
                          ),
                          if (!isActivePlayerSelected)
                            Text(
                              'Select player below to attribute',
                              style: AppTypography.labelSmall.copyWith(
                                color: cs.onSurfaceVariant,
                                fontSize: 10,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            AppSpacing.vGap12,

            // Defensive stats row
            Row(
              children: [
                Expanded(
                  child: _buildStatButton(
                    context,
                    MatchEventType.intercept,
                    'Intercept',
                    Icons.back_hand,
                    teamColor: activeTeamColor,
                  ),
                ),
                AppSpacing.hGap12,
                Expanded(
                  child: _buildStatButton(
                    context,
                    MatchEventType.deflection,
                    'Deflection',
                    Icons.touch_app,
                    teamColor: activeTeamColor,
                  ),
                ),
              ],
            ),
            AppSpacing.vGap12,

            // Rebounds row
            Row(
              children: [
                Expanded(
                  child: _buildStatButton(
                    context,
                    MatchEventType.offensiveRebound,
                    'Off. Reb',
                    Icons.arrow_upward,
                    teamColor: activeTeamColor,
                  ),
                ),
                AppSpacing.hGap12,
                Expanded(
                  child: _buildStatButton(
                    context,
                    MatchEventType.defensiveRebound,
                    'Def. Reb',
                    Icons.arrow_upward,
                    teamColor: activeTeamColor,
                  ),
                ),
              ],
            ),
            AppSpacing.vGap12,

            // Possession stats row
            Row(
              children: [
                Expanded(
                  child: _buildStatButton(
                    context,
                    MatchEventType.assist,
                    'Assist',
                    Icons.handshake,
                    teamColor: activeTeamColor,
                  ),
                ),
                AppSpacing.hGap12,
                Expanded(
                  child: _buildStatButton(
                    context,
                    MatchEventType.pickup,
                    'Pickup',
                    Icons.pan_tool_alt,
                    teamColor: activeTeamColor,
                  ),
                ),
              ],
            ),
            AppSpacing.vGap12,

            // Errors row
            Row(
              children: [
                Expanded(
                  child: _buildStatButton(
                    context,
                    MatchEventType.miss,
                    'Miss',
                    Icons.close,
                    isNegativeStat: true,
                  ),
                ),
                AppSpacing.hGap12,
                Expanded(
                  child: _buildStatButton(
                    context,
                    MatchEventType.turnover,
                    'Turnover',
                    Icons.sync_problem,
                    isNegativeStat: true,
                  ),
                ),
              ],
            ),
            AppSpacing.vGap12,

            // Penalties row
            Row(
              children: [
                Expanded(
                  child: _buildStatButton(
                    context,
                    MatchEventType.penaltyContact,
                    'Contact',
                    Icons.gavel,
                    isNegativeStat: true,
                  ),
                ),
                AppSpacing.hGap12,
                Expanded(
                  child: _buildStatButton(
                    context,
                    MatchEventType.penaltyObstruction,
                    'Obstruction',
                    Icons.front_hand,
                    isNegativeStat: true,
                  ),
                ),
              ],
            ),
            AppSpacing.vGap12,

            // Misc row
            Row(
              children: [
                Expanded(
                  child: _buildStatButton(
                    context,
                    MatchEventType.heldBall,
                    'Held Ball',
                    Icons.timer_off,
                    isNegativeStat: true,
                  ),
                ),
                AppSpacing.hGap12,
                Expanded(
                  child: _buildStatButton(
                    context,
                    MatchEventType.centerPass,
                    'Centre Pass',
                    Icons.adjust,
                    isNeutralStat: true,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatButton(
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
      height: 72,
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
            padding: EdgeInsets.zero,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  size: 24,
                  color: accentColor,
                ),
                AppSpacing.vGap4,
                Flexible(
                  child: Text(
                    label.toUpperCase(),
                    style: AppTypography.labelSmall.copyWith(
                      color: cs.onSurface,
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                    ),
                    textAlign: TextAlign.center,
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
