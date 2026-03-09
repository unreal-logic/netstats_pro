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
    final cs = Theme.of(context).colorScheme;

    return Container(
      width: 140, // Increased width to accommodate larger badges
      decoration: BoxDecoration(
        color: Colors.transparent, // More neutral, let the parent surface show
        border: Border(
          right: isRightAligned
              ? BorderSide.none
              : BorderSide(color: cs.outlineVariant.withValues(alpha: 0.5)),
          left: isRightAligned
              ? BorderSide(color: cs.outlineVariant.withValues(alpha: 0.5))
              : BorderSide.none,
        ),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 16),
            width: double.infinity,
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: cs.outlineVariant.withValues(alpha: 0.3),
                ),
              ),
            ),
            child: Text(
              teamName.toUpperCase(),
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: cs.onSurfaceVariant,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.5,
              ),
            ),
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(vertical: 12),
            itemCount: lineup.length,
            itemBuilder: (context, index) {
              final player = lineup[index];
              final isSelected = player.id == activePlayerId;

              return Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                child: Material(
                  color: isSelected
                      ? teamColor.withValues(alpha: 0.12)
                      : cs.surfaceContainerLowest.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(16),
                  clipBehavior: Clip.antiAlias,
                  child: InkWell(
                    onTap: () => onPlayerTap(player.id, player.position),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 14,
                        horizontal: 10,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: isSelected
                              ? teamColor
                              : cs.outline.withValues(alpha: 0.2),
                          width: isSelected ? 2 : 1,
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Large Round Position Badge (46x46)
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            width: 46,
                            height: 46,
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? teamColor
                                  : teamColor.withValues(alpha: 0.8),
                              shape: BoxShape.circle,
                              boxShadow: isSelected
                                  ? [
                                      BoxShadow(
                                        color: teamColor.withValues(
                                          alpha: 0.4,
                                        ),
                                        blurRadius: 10,
                                        offset: const Offset(0, 4),
                                      ),
                                    ]
                                  : null,
                            ),
                            child: Center(
                              child: Text(
                                player.position.toUpperCase(),
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w900,
                                  color: teamColor.computeLuminance() > 0.5
                                      ? Colors.black87
                                      : Colors.white,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            player.name,
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(
                                  fontWeight: isSelected
                                      ? FontWeight.w800
                                      : FontWeight.w500,
                                  color: isSelected
                                      ? cs.onSurface
                                      : cs.onSurfaceVariant,
                                  fontSize: 12,
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
