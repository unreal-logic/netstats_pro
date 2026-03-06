import 'package:flutter/material.dart';
import 'package:netstats_pro/core/theme/colors.dart';
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        children: [
          // Z-Pattern Row 1: Defenses
          Row(
            children: [
              Expanded(
                child: _buildZButton(
                  context,
                  MatchEventType.intercept,
                  'Intercept',
                  Icons.back_hand,
                  NetStatsColors.accentTeal,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildZButton(
                  context,
                  MatchEventType.deflection,
                  'Deflect',
                  Icons.touch_app,
                  NetStatsColors.accentTeal,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Z-Pattern Row 2: Rebounds
          Row(
            children: [
              Expanded(
                child: _buildZButton(
                  context,
                  MatchEventType.offensiveRebound,
                  'Off. Reb',
                  Icons.arrow_upward,
                  NetStatsColors.accentTeal,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildZButton(
                  context,
                  MatchEventType.defensiveRebound,
                  'Def. Reb',
                  Icons.arrow_upward,
                  NetStatsColors.accentTeal,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Z-Pattern Row 3: Possession
          Row(
            children: [
              Expanded(
                child: _buildZButton(
                  context,
                  MatchEventType.assist,
                  'Assist',
                  Icons.handshake,
                  NetStatsColors.accentTeal,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildZButton(
                  context,
                  MatchEventType.pickup,
                  'Pickup',
                  Icons.pan_tool_alt,
                  NetStatsColors.accentTeal,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Z-Pattern Row 4: Errors/Penalties
          Row(
            children: [
              Expanded(
                child: _buildZButton(
                  context,
                  MatchEventType.miss,
                  'Miss',
                  Icons.close,
                  Theme.of(context).colorScheme.error,
                  isOutlined: true,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildZButton(
                  context,
                  MatchEventType.turnover,
                  'Turnover',
                  Icons.sync_problem,
                  Theme.of(context).colorScheme.error,
                  isOutlined: true,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Dominant Thumb-Zone GOAL Button
          SizedBox(
            width: double.infinity,
            height: 120, // Massive height for thumb zone
            child: FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor:
                    isActivePlayerSelected && activeTeamColor != null
                    ? activeTeamColor
                    : NetStatsColors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(32),
                ),
                elevation: 8,
              ),
              onPressed: () => onStatSelected(MatchEventType.goal),
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.sports_basketball, size: 48, color: Colors.white),
                  SizedBox(height: 4),
                  Text(
                    'GOAL',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 4,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildZButton(
    BuildContext context,
    MatchEventType type,
    String label,
    IconData icon,
    Color color, {
    bool isOutlined = false,
  }) {
    return SizedBox(
      height: 60,
      child: isOutlined
          ? OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: color, width: 2),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 8),
              ),
              onPressed: () => onStatSelected(type),
              icon: Icon(icon, color: color, size: 20),
              label: Text(
                label,
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            )
          : FilledButton.icon(
              style: FilledButton.styleFrom(
                backgroundColor: color.withValues(alpha: 0.15),
                foregroundColor: color,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 8),
              ),
              onPressed: () => onStatSelected(type),
              icon: Icon(icon, size: 20),
              label: Text(
                label,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ),
    );
  }
}
