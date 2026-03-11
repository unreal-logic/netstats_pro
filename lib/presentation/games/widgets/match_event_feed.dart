import 'package:flutter/material.dart';
import 'package:netstats_pro/core/design_system/design_system.dart';
import 'package:netstats_pro/domain/entities/match_event.dart';

class MatchEventFeed extends StatefulWidget {
  const MatchEventFeed({
    required this.events,
    required this.homeTeamColor,
    required this.opponentTeamColor,
    required this.onUndoLast,
    super.key,
  });

  final List<MatchEvent> events;
  final Color homeTeamColor;
  final Color opponentTeamColor;
  final VoidCallback onUndoLast;

  @override
  State<MatchEventFeed> createState() => _MatchEventFeedState();
}

class _MatchEventFeedState extends State<MatchEventFeed> {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  final List<MatchEvent> _internalEvents = [];
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _internalEvents.addAll(widget.events.reversed.take(20));
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(MatchEventFeed oldWidget) {
    super.didUpdateWidget(oldWidget);
    final newEvents = widget.events.reversed.take(20).toList();

    // Handle additions at the front (index 0)
    if (newEvents.isNotEmpty &&
        (_internalEvents.isEmpty || newEvents.first != _internalEvents.first)) {
      // Find how many items are new at the front
      var newItems = 0;
      if (_internalEvents.isEmpty) {
        newItems = newEvents.length;
      } else {
        // Find if the old first item exists in new list
        final index = newEvents.indexOf(_internalEvents.first);
        if (index != -1) {
          newItems = index;
        } else {
          // Entirely new batch or many new items
          newItems = newEvents.length;
        }
      }

      for (var i = newItems - 1; i >= 0; i--) {
        _internalEvents.insert(0, newEvents[i]);
        _listKey.currentState?.insertItem(
          0,
          duration: const Duration(milliseconds: 600),
        );
      }

      // Auto-scroll to start to show the new event
      if (newItems > 0) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (_scrollController.hasClients) {
            _scrollController.animateTo(
              0,
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeOut,
            );
          }
        });
      }
    }

    // Handle removals from any position (usually front during undo, or end due to 20-cap)
    // Synchronize internal list length with 20-cap
    while (_internalEvents.length > 20) {
      final lastItem = _internalEvents.removeLast();
      _listKey.currentState?.removeItem(
        _internalEvents.length,
        (context, animation) => _buildItem(lastItem, animation),
      );
    }

    // Handle Undo specifically (if newest item was removed)
    if (newEvents.length < _internalEvents.length ||
        (newEvents.isNotEmpty &&
            _internalEvents.isNotEmpty &&
            newEvents.first != _internalEvents.first &&
            _internalEvents.contains(newEvents.first))) {
      // If internal has items that aren't in newEvents (at the front)
      while (_internalEvents.isNotEmpty &&
          !newEvents.contains(_internalEvents.first)) {
        final removedItem = _internalEvents.removeAt(0);
        _listKey.currentState?.removeItem(
          0,
          (context, animation) => _buildItem(removedItem, animation),
          duration: const Duration(milliseconds: 400),
        );
      }
    }
  }

  Widget _buildItem(MatchEvent event, Animation<double> animation) {
    return SizeTransition(
      sizeFactor: animation,
      axis: Axis.horizontal,
      axisAlignment: -1,
      child: FadeTransition(
        opacity: animation,
        child: ScaleTransition(
          scale: CurvedAnimation(
            parent: animation,
            curve: Curves.easeOutBack,
          ),
          child: Padding(
            padding: const EdgeInsets.only(right: AppSpacing.px8),
            child: _MatchEventCard(
              event: event,
              teamColor: event.isHomeTeam
                  ? widget.homeTeamColor
                  : widget.opponentTeamColor,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_internalEvents.isEmpty && widget.events.isEmpty) {
      return const SizedBox.shrink();
    }

    return SizedBox(
      height: 48,
      child: Row(
        children: [
          // Fixed Undo Button
          _FixedUndoButton(onUndo: widget.onUndoLast),
          const VerticalDivider(
            width: 1,
            thickness: 1,
            indent: 12,
            endIndent: 12,
          ),
          // Scrollable Animated Events
          Expanded(
            child: AnimatedList(
              key: _listKey,
              controller: _scrollController,
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.px8),
              initialItemCount: _internalEvents.length,
              itemBuilder: (context, index, animation) {
                return _buildItem(_internalEvents[index], animation);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _FixedUndoButton extends StatelessWidget {
  const _FixedUndoButton({required this.onUndo});
  final VoidCallback onUndo;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onUndo,
        child: SizedBox(
          width: 48,
          height: 48,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.undo_rounded,
                size: 18,
                color: cs.onSurfaceVariant.withValues(alpha: 0.7),
              ),
              const SizedBox(height: 2),
              Text(
                'UNDO',
                style: AppTypography.labelSmall.copyWith(
                  fontSize: 7,
                  fontWeight: FontWeight.w900,
                  color: cs.onSurfaceVariant.withValues(alpha: 0.5),
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MatchEventCard extends StatelessWidget {
  const _MatchEventCard({
    required this.event,
    required this.teamColor,
  });

  final MatchEvent event;
  final Color teamColor;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Container(
      width: 110, // Slightly narrower since undo is gone
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.px4,
      ),
      decoration: const BoxDecoration(),
      child: Row(
        children: [
          // Simplified Team/Position Indicator
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: teamColor, // Changed from accentColor to teamColor
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                event.position ?? '?',
                style: AppTypography.labelSmall.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                  fontSize: 9,
                ),
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.px8),
          // Event Details
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _getEventShortName(event.type).toUpperCase(),
                  style: AppTypography.labelSmall.copyWith(
                    color: cs.onSurfaceVariant.withValues(alpha: 0.8),
                    fontWeight: FontWeight.w800,
                    fontSize: 10,
                    letterSpacing: 0,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  event.matchTimeFormatted,
                  style: AppTypography.labelSmall.copyWith(
                    color: cs.onSurfaceVariant.withValues(alpha: 0.5),
                    fontSize: 8,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getEventShortName(MatchEventType type) {
    switch (type) {
      case MatchEventType.goal:
        return '1pt Goal';
      case MatchEventType.goal2pt:
        return '2pt Goal';
      case MatchEventType.goal3pt:
        return '3pt Goal';
      case MatchEventType.miss:
        return '1pt Miss';
      case MatchEventType.miss2pt:
        return '2pt Miss';
      case MatchEventType.miss3pt:
        return '3pt Miss';
      case MatchEventType.turnover:
        return 'Turnover';
      case MatchEventType.intercept:
        return 'Intercept';
      case MatchEventType.deflection:
        return 'Deflect';
      case MatchEventType.offensiveRebound:
        return 'Off Rebound';
      case MatchEventType.defensiveRebound:
        return 'Def Rebound';
      case MatchEventType.assist:
        return 'Assist';
      case MatchEventType.pickup:
        return 'Pickup';
      case MatchEventType.heldBall:
        return 'Held Ball';
      case MatchEventType.centerPass:
        return 'Center Pass';
      case MatchEventType.penaltyContact:
        return 'Penalty: Contact';
      case MatchEventType.penaltyObstruction:
        return 'Penalty: Obstruction';
      case MatchEventType.penalty:
        return 'Penalty';
      case MatchEventType.substitution:
        return 'Substitution';
      case MatchEventType.quarterStart:
        return 'Start';
      case MatchEventType.quarterEnd:
        return 'End';
      case MatchEventType.adjustment:
        return 'Adjustment';
    }
  }
}

extension on MatchEvent {
  String get matchTimeFormatted {
    final m = matchTime.inMinutes.toString().padLeft(2, '0');
    final s = (matchTime.inSeconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }
}
