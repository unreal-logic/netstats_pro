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
                      : Theme.of(context).colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(36), // Pill shape
                  border: isSelected
                      ? Border.all(color: Colors.white, width: 2)
                      : Border.all(color: Colors.transparent, width: 2),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: activeTeamColor.withValues(alpha: 0.5),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
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
                        fontWeight: FontWeight.bold,
                        color: isSelected
                            ? Colors.white
                            : Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      player.name.split(' ').first, // First name only for strip
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: isSelected
                            ? FontWeight.bold
                            : FontWeight.normal,
                        color: isSelected
                            ? Colors.white
                            : Theme.of(context).colorScheme.onSurfaceVariant,
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
