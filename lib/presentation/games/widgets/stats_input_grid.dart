import 'package:flutter/material.dart';
import 'package:netstats_pro/core/theme/colors.dart';
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
    return Padding(
      padding: const EdgeInsets.all(16),
      child: SingleChildScrollView(
        child: Column(
          children: [
            // Primary Action
            SizedBox(
              width: double.infinity,
              height: 100,
              child: FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor:
                      isActivePlayerSelected && activeTeamColor != null
                      ? activeTeamColor
                      : NetStatsColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
                onPressed: () => onStatSelected(MatchEventType.goal),
                child: const Text(
                  'GOAL',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Defensive stats row
            Row(
              children: [
                Expanded(
                  child: _buildStatButton(
                    context,
                    MatchEventType.intercept,
                    'Intercept',
                    Icons.back_hand,
                    color: NetStatsColors.accentTeal,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatButton(
                    context,
                    MatchEventType.deflection,
                    'Deflection',
                    Icons.touch_app,
                    color: NetStatsColors.accentTeal,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Rebounds row
            Row(
              children: [
                Expanded(
                  child: _buildStatButton(
                    context,
                    MatchEventType.offensiveRebound,
                    'Off. Reb',
                    Icons.arrow_upward,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatButton(
                    context,
                    MatchEventType.defensiveRebound,
                    'Def. Reb',
                    Icons.arrow_upward,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Possession stats row
            Row(
              children: [
                Expanded(
                  child: _buildStatButton(
                    context,
                    MatchEventType.assist,
                    'Assist',
                    Icons.handshake,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatButton(
                    context,
                    MatchEventType.pickup,
                    'Pickup',
                    Icons.pan_tool_alt,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Errors row
            Row(
              children: [
                Expanded(
                  child: _buildStatButton(
                    context,
                    MatchEventType.miss,
                    'Miss',
                    Icons.close,
                    color: Theme.of(context).colorScheme.error,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatButton(
                    context,
                    MatchEventType.turnover,
                    'Turnover',
                    Icons.sync_problem,
                    color: Theme.of(context).colorScheme.error,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Penalties row
            Row(
              children: [
                Expanded(
                  child: _buildStatButton(
                    context,
                    MatchEventType.penaltyContact,
                    'Contact',
                    Icons.gavel,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatButton(
                    context,
                    MatchEventType.penaltyObstruction,
                    'Obstruction',
                    Icons.front_hand,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Misc row
            Row(
              children: [
                Expanded(
                  child: _buildStatButton(
                    context,
                    MatchEventType.heldBall,
                    'Held Ball',
                    Icons.timer_off,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatButton(
                    context,
                    MatchEventType.centerPass,
                    'Centre Pass',
                    Icons.adjust,
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
    Color? color,
  }) {
    return SizedBox(
      height: 64,
      child: FilledButton.tonal(
        style: FilledButton.styleFrom(
          backgroundColor: color?.withValues(alpha: 0.15),
          foregroundColor: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          padding: EdgeInsets.zero,
        ),
        onPressed: () => onStatSelected(type),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 24),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
