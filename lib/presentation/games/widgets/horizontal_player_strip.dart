import 'package:flutter/material.dart';
import 'package:netstats_pro/presentation/games/widgets/lineup_column.dart'; // Reuse LineupPlayer for POC

class HorizontalPlayerStrip extends StatelessWidget {
  const HorizontalPlayerStrip({
    required this.lineup,
    required this.activeTeamColor,
    required this.onPlayerTap,
    this.activePlayerId,
    super.key,
  });

  final List<LineupPlayer> lineup;
  final Color activeTeamColor;
  final int? activePlayerId;
  final void Function(int playerId, String position) onPlayerTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      color: Theme.of(context).colorScheme.surface,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        itemCount: lineup.length,
        itemBuilder: (context, index) {
          final player = lineup[index];
          final isSelected = player.id == activePlayerId;

          return Padding(
            padding: const EdgeInsets.only(right: 12),
            child: GestureDetector(
              onTap: () => onPlayerTap(player.id, player.position),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 72,
                decoration: BoxDecoration(
                  color: isSelected
                      ? activeTeamColor
                      : activeTeamColor.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(36), // Pill shape
                  border: Border.all(
                    color: isSelected
                        ? Colors.white
                        : activeTeamColor.withValues(alpha: 0.3),
                    width: isSelected ? 2 : 1.5,
                  ),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: activeTeamColor.withValues(alpha: 0.4),
                            blurRadius: 8,
                            spreadRadius: 1,
                          ),
                        ]
                      : [],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      player.position,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        color: isSelected ? Colors.white : activeTeamColor,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      player.name.split(' ').first.toUpperCase(),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.w800,
                        color: isSelected
                            ? Colors.white.withValues(alpha: 0.8)
                            : activeTeamColor.withValues(alpha: 0.7),
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
