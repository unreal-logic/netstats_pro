import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:netstats_pro/core/theme/colors.dart';
import 'package:netstats_pro/domain/entities/game.dart';
import 'package:netstats_pro/domain/entities/match_event.dart';
import 'package:netstats_pro/presentation/games/bloc/live_match_bloc.dart';
import 'package:netstats_pro/presentation/games/bloc/live_match_event.dart';
import 'package:netstats_pro/presentation/games/bloc/live_match_state.dart';
import 'package:netstats_pro/presentation/games/widgets/ergonomic_stats_grid.dart';
import 'package:netstats_pro/presentation/games/widgets/horizontal_player_strip.dart';
import 'package:netstats_pro/presentation/games/widgets/lineup_column.dart';
import 'package:netstats_pro/presentation/games/widgets/stats_input_grid.dart';
import 'package:netstats_pro/presentation/widgets/premium_app_bar.dart';

class LiveMatchScreen extends StatefulWidget {
  const LiveMatchScreen({required this.gameId, super.key});
  final int gameId;

  @override
  State<LiveMatchScreen> createState() => _LiveMatchScreenState();
}

class _LiveMatchScreenState extends State<LiveMatchScreen> {
  final List<LineupPlayer> mockAwayLineup = [
    const LineupPlayer(id: 8, name: 'D. Wallam', position: 'GS'),
    const LineupPlayer(id: 9, name: 'H. Glasgow', position: 'GA'),
    const LineupPlayer(id: 10, name: 'K. Moloney', position: 'WA'),
    const LineupPlayer(id: 11, name: 'J. Price', position: 'C'),
    const LineupPlayer(id: 12, name: 'A. Brazill', position: 'WD'),
    const LineupPlayer(id: 13, name: 'S. Weston', position: 'GD'),
    const LineupPlayer(id: 14, name: 'S. Klau', position: 'GK'),
  ];

  @override
  void initState() {
    super.initState();
    context.read<LiveMatchBloc>().add(StartMatch(widget.gameId));
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LiveMatchBloc, LiveMatchState>(
      listener: (context, state) {
        if (state.status == LiveMatchStatus.finished) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Match completed and saved!')),
          );
          context.go('/games');
        }
        if (state.status == LiveMatchStatus.error &&
            state.errorMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage!),
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
          );
        }
      },
      builder: (context, state) {
        if (state.status == LiveMatchStatus.loading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (state.status == LiveMatchStatus.error) {
          return Scaffold(
            body: Center(child: Text(state.errorMessage ?? 'Error')),
          );
        }
        if (state.game == null) return const SizedBox();

        final homeLineup = state.game!.format.positions.map((
          pos,
        ) {
          final player = state.homeLineup[pos];
          return LineupPlayer(
            id: player?.id ?? 0,
            name: player?.fullName ?? 'EMPTY',
            position: pos.name.toUpperCase(),
          );
        }).toList();

        return Scaffold(
          appBar: PremiumAppBar(
            title: '${state.game!.opponentName} Match',
            actions: [
              IconButton(
                icon: const Icon(Icons.undo),
                onPressed: () => context.read<LiveMatchBloc>().add(UndoEvent()),
              ),
              IconButton(
                icon: const Icon(Icons.settings),
                onPressed: () => _showMatchSettings(context, state),
              ),
            ],
          ),
          body: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: _buildScoreboard(state),
              ),
              SliverToBoxAdapter(
                child: state.isErgonomicLayout
                    ? _buildErgonomicLayout(state, homeLineup)
                    : _buildClassicLayout(state, homeLineup),
              ),
              SliverFillRemaining(
                hasScrollBody: false,
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: _buildEventFeed(state),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showMatchSettings(BuildContext context, LiveMatchState state) {
    unawaited(
      showModalBottomSheet<void>(
        context: context,
        builder: (bottomSheetContext) => SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(
                  state.isErgonomicLayout
                      ? Icons.phone_iphone
                      : Icons.tablet_mac,
                  color: Theme.of(context).colorScheme.primary,
                ),
                title: const Text('Toggle UI Layout (POC)'),
                subtitle: Text(
                  state.isErgonomicLayout
                      ? 'Currently: Ergonomic (Option B)'
                      : 'Currently: Classic 3-Column (Option A)',
                ),
                onTap: () {
                  context.read<LiveMatchBloc>().add(ToggleLayout());
                  Navigator.pop(bottomSheetContext);
                },
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.next_plan),
                title: const Text('Change Quarter'),
                onTap: () {
                  final nextQuarter = state.currentQuarter + 1;
                  context.read<LiveMatchBloc>().add(ChangeQuarter(nextQuarter));
                  Navigator.pop(bottomSheetContext);
                },
              ),
              ListTile(
                leading: const Icon(Icons.stop_circle),
                title: const Text('End Match'),
                onTap: () {
                  context.read<LiveMatchBloc>().add(EndMatch());
                  Navigator.pop(bottomSheetContext);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildScoreboard(LiveMatchState state) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).colorScheme.outlineVariant,
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Align(
              alignment: Alignment.centerLeft,
              child: GestureDetector(
                onTap: () =>
                    context.read<LiveMatchBloc>().add(ToggleActiveTeam()),
                onLongPress: () =>
                    context.read<LiveMatchBloc>().add(TogglePossession()),
                child: _buildTeamScore(
                  state.game!.homeTeamName.toUpperCase(),
                  state.scoreHome,
                  NetStatsColors.primary,
                  hasPossession: state.homeHasPossession,
                  isActive: state.activeTeamId == 0,
                ),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Q${state.currentQuarter}',
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
                InkWell(
                  onTap: () {
                    if (state.isTimerRunning) {
                      context.read<LiveMatchBloc>().add(PauseTimer());
                    } else {
                      context.read<LiveMatchBloc>().add(StartTimer());
                    }
                  },
                  borderRadius: BorderRadius.circular(8),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          state.isTimerRunning ? Icons.pause : Icons.play_arrow,
                          size: 20,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          state.remainingTime.formatted,
                          style: Theme.of(context).textTheme.headlineMedium
                              ?.copyWith(
                                color: state.isPowerPlayActive
                                    ? NetStatsColors.accentCoral
                                    : Theme.of(context).colorScheme.onSurface,
                                fontFamily: 'Lexend',
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ],
                    ),
                  ),
                ),
                if (state.game!.format == GameFormat.fiveAside)
                  TextButton.icon(
                    onPressed: () =>
                        context.read<LiveMatchBloc>().add(TogglePowerPlay()),
                    icon: Icon(
                      state.isPowerPlayActive
                          ? Icons.flash_on
                          : Icons.flash_off,
                      color: state.isPowerPlayActive
                          ? NetStatsColors.accentCoral
                          : Theme.of(context).colorScheme.outline,
                    ),
                    label: Text(
                      'POWER PLAY',
                      style: TextStyle(
                        color: state.isPowerPlayActive
                            ? NetStatsColors.accentCoral
                            : Theme.of(context).colorScheme.outline,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          Expanded(
            child: Align(
              alignment: Alignment.centerRight,
              child: GestureDetector(
                onTap: () =>
                    context.read<LiveMatchBloc>().add(ToggleActiveTeam()),
                onLongPress: () =>
                    context.read<LiveMatchBloc>().add(TogglePossession()),
                child: _buildTeamScore(
                  state.game!.opponentName.toUpperCase(),
                  state.scoreAway,
                  NetStatsColors.accentTeal,
                  hasPossession: !state.homeHasPossession,
                  isActive: state.activeTeamId == 1,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTeamScore(
    String name,
    int score,
    Color color, {
    bool hasPossession = false,
    bool isActive = false,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: isActive ? color.withValues(alpha: 0.1) : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isActive ? color : Colors.transparent,
          width: 2,
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              if (hasPossession)
                Padding(
                  padding: const EdgeInsets.only(right: 4),
                  child: Icon(Icons.arrow_right, color: color, size: 20),
                ),
              Expanded(
                child: Text(
                  name,
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                    color: isActive ? color : null,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  textAlign: hasPossession ? TextAlign.left : TextAlign.center,
                ),
              ),
              if (hasPossession)
                const Padding(
                  padding: EdgeInsets.only(left: 4),
                  child: Icon(
                    Icons.arrow_left,
                    color: Colors.transparent,
                    size: 20,
                  ), // Balance
                ),
            ],
          ),
          Text(
            '$score',
            style: Theme.of(context).textTheme.displayLarge?.copyWith(
              color: color,
              fontWeight: FontWeight.bold,
              fontFamily: 'Lexend',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildClassicLayout(
    LiveMatchState state,
    List<LineupPlayer> homeLineup,
  ) {
    return Row(
      children: [
        // Left Column: Home Lineup
        LineupColumn(
          teamName: 'Home',
          teamColor: NetStatsColors.primary,
          lineup: homeLineup,
          activePlayerId: state.isHomeActive ? state.activePlayerId : null,
          onPlayerTap: (id, position) {
            context.read<LiveMatchBloc>().add(
              PlayerTap(playerId: id, position: position),
            );
          },
        ),

        // Center Column: Stats Grid
        Expanded(
          child: StatsInputGrid(
            isActivePlayerSelected: state.isPlayerSelected,
            activeTeamColor: state.isHomeActive
                ? NetStatsColors.primary
                : NetStatsColors.accentTeal,
            onStatSelected: (type) {
              if (type.name.contains('goal') && !state.isPlayerSelected) {
                context.read<LiveMatchBloc>().add(
                  SelectPendingStat(type),
                );
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Recording ${type.name}. Select a player!'),
                    duration: const Duration(seconds: 2),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              } else {
                context.read<LiveMatchBloc>().add(
                  LogEvent(type: type, isHomeTeam: state.isHomeActive),
                );
              }
            },
          ),
        ),

        // Right Column: Away Lineup
        LineupColumn(
          teamName: 'Away',
          teamColor: NetStatsColors.accentTeal,
          lineup: mockAwayLineup,
          activePlayerId: !state.isHomeActive ? state.activePlayerId : null,
          isRightAligned: true,
          onPlayerTap: (id, position) {
            context.read<LiveMatchBloc>().add(
              PlayerTap(playerId: id, position: position),
            );
          },
        ),
      ],
    );
  }

  Widget _buildErgonomicLayout(
    LiveMatchState state,
    List<LineupPlayer> homeLineup,
  ) {
    // Determine active team for the strip
    final activeLineup = state.activeTeamId == 0 ? homeLineup : mockAwayLineup;
    final activeColor = state.activeTeamId == 0
        ? NetStatsColors.primary
        : NetStatsColors.accentTeal;

    return Column(
      children: [
        // Horizontal Player Strip
        HorizontalPlayerStrip(
          lineup: activeLineup,
          activeTeamColor: activeColor,
          activePlayerId: state.activePlayerId,
          onPlayerTap: (id, position) {
            context.read<LiveMatchBloc>().add(
              PlayerTap(playerId: id, position: position),
            );
          },
        ),

        // Z-Pattern / Dominant Thumb Grid
        ErgonomicStatsGrid(
          isActivePlayerSelected: state.isPlayerSelected,
          activeTeamColor: activeColor,
          onStatSelected: (type) {
            if (type.name.contains('goal') && !state.isPlayerSelected) {
              context.read<LiveMatchBloc>().add(
                SelectPendingStat(type),
              );
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Recording ${type.name}. Select a player!'),
                  duration: const Duration(seconds: 2),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            } else {
              context.read<LiveMatchBloc>().add(
                LogEvent(type: type, isHomeTeam: state.isHomeActive),
              );
            }
          },
        ),
      ],
    );
  }

  Widget _buildEventFeed(LiveMatchState state) {
    final recentEvents = state.events.reversed.take(5).toList();
    if (recentEvents.isEmpty) return const SizedBox(height: 80);

    return Container(
      height: 120,
      padding: const EdgeInsets.all(16),
      color: Theme.of(context).colorScheme.surfaceContainerLowest,
      child: ListView.separated(
        itemCount: recentEvents.length,
        separatorBuilder: (_, _) => const SizedBox(height: 8),
        itemBuilder: (context, index) {
          final event = recentEvents[index];

          Color eventColor;
          if (event.isPowerPlay) {
            eventColor = NetStatsColors.accentCoral;
          } else if (event.type == MatchEventType.turnover ||
              event.type == MatchEventType.miss ||
              event.type.name.contains('penalty')) {
            eventColor = Theme.of(context).colorScheme.error;
          } else if (event.type == MatchEventType.intercept ||
              event.type.name.contains('Rebound') ||
              event.type == MatchEventType.deflection) {
            eventColor = event.isHomeTeam
                ? NetStatsColors.primary
                : NetStatsColors.accentTeal;
          } else {
            eventColor = Theme.of(context).colorScheme.onSurface;
          }

          return Row(
            children: [
              Text(
                event.matchTime.formatted,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.outline,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  '${event.isHomeTeam ? 'Home' : 'Away'}: '
                  '${event.type.name.toUpperCase()}'
                  '${event.isPowerPlay ? ' (POWER PLAY!)' : ''}',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight:
                        event.type.name.contains('goal') ||
                            eventColor !=
                                Theme.of(context).colorScheme.onSurface
                        ? FontWeight.bold
                        : FontWeight.normal,
                    color: eventColor,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

extension DurationFormat on Duration {
  String get formatted {
    final m = inMinutes.toString().padLeft(2, '0');
    final s = (inSeconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }
}
