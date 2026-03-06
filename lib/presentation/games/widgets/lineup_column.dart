import 'package:flutter/material.dart';

class LineupColumn extends StatelessWidget {
  const LineupColumn({
    required this.teamName,
    required this.teamColor,
    required this.lineup,
    required this.onPlayerTap,
    this.activePlayerId,
    this.isRightAligned = false,
    super.key,
  });

  final String teamName;
  final Color teamColor;
  final List<LineupPlayer> lineup; // Define a simple record or class below
  final int? activePlayerId;
  final bool isRightAligned;
  final void Function(int playerId, String position) onPlayerTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120, // Fixed width for the column
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border(
          right: isRightAligned
              ? BorderSide.none
              : BorderSide(color: Theme.of(context).colorScheme.outlineVariant),
          left: isRightAligned
              ? BorderSide(color: Theme.of(context).colorScheme.outlineVariant)
              : BorderSide.none,
        ),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12),
            width: double.infinity,
            color: teamColor.withValues(alpha: 0.1),
            child: Text(
              teamName.toUpperCase(),
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: teamColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: lineup.length,
            itemBuilder: (context, index) {
              final player = lineup[index];
              final isSelected = player.id == activePlayerId;

              return Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 4,
                ),
                child: Material(
                  color: isSelected
                      ? teamColor.withValues(alpha: 0.2)
                      : Theme.of(context).colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(12),
                  clipBehavior: Clip.antiAlias,
                  child: InkWell(
                    onTap: () => onPlayerTap(player.id, player.position),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 8,
                      ),
                      decoration: BoxDecoration(
                        border: isSelected
                            ? Border.all(color: teamColor, width: 2)
                            : Border.all(color: Colors.transparent, width: 2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: teamColor,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              player.position,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            player.name,
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(
                                  fontWeight: isSelected
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                  color: isSelected
                                      ? Theme.of(
                                          context,
                                        ).colorScheme.onSurface
                                      : Theme.of(
                                          context,
                                        ).colorScheme.onSurfaceVariant,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

// Temporary class until we link to the actual Lineup entity in Drift
class LineupPlayer {
  const LineupPlayer({
    required this.id,
    required this.name,
    required this.position,
  });
  final int id;
  final String name;
  final String position;
}
