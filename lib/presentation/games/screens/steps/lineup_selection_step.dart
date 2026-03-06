import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:netstats_pro/domain/entities/player.dart';
import 'package:netstats_pro/domain/repositories/player_repository.dart';
import 'package:netstats_pro/injection_container.dart';
import 'package:netstats_pro/presentation/games/bloc/setup_wizard_bloc.dart';
import 'package:netstats_pro/presentation/games/bloc/setup_wizard_event.dart';
import 'package:netstats_pro/presentation/games/bloc/setup_wizard_state.dart';

class LineupSelectionStep extends StatelessWidget {
  const LineupSelectionStep({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SetupWizardBloc, SetupWizardState>(
      builder: (context, state) {
        final positions = state.format.positions;

        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      'ASSIGN STARTING LINEUP (${state.format.displayName})',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.2,
                        color: Colors.blueGrey,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  TextButton.icon(
                    onPressed: () =>
                        context.read<SetupWizardBloc>().add(AutoAssignLineup()),
                    icon: const Icon(Icons.auto_awesome, size: 16),
                    label: const Text(
                      'AUTO-ASSIGN',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ...positions.map((pos) {
                final player = state.lineup[pos];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _PositionSlot(
                    position: pos,
                    assignedPlayer: player,
                    onTap: () => _showPlayerPicker(
                      context,
                      pos,
                      state.lineup.values.whereType<Player>().toList(),
                    ),
                  ),
                );
              }),
            ],
          ),
        );
      },
    );
  }

  void _showPlayerPicker(
    BuildContext context,
    NetballPosition position,
    List<Player> alreadyAssigned,
  ) {
    final bloc = context.read<SetupWizardBloc>();

    unawaited(
      showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (bottomSheetContext) {
          return BlocProvider.value(
            value: bloc,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.7,
              decoration: BoxDecoration(
                color:
                    Theme.of(context).cardTheme.color ??
                    Theme.of(context).colorScheme.surface,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(24),
                ),
              ),
              child: Column(
                children: [
                  const SizedBox(height: 12),
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: Theme.of(
                            context,
                          ).colorScheme.primary,
                          child: Text(
                            position.bib,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        const Text(
                          'SELECT PLAYER',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: StreamBuilder<List<Player>>(
                      stream: sl<PlayerRepository>().watchAllPlayers(),
                      builder: (streamContext, snapshot) {
                        if (!snapshot.hasData) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        final players = snapshot.data!;
                        if (players.isEmpty) {
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.person_add_outlined,
                                  size: 48,
                                  color: Colors.blueGrey.withValues(alpha: 0.5),
                                ),
                                const SizedBox(height: 16),
                                const Text(
                                  'NO PLAYERS IN ROSTER',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blueGrey,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                const Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 48),
                                  child: Text(
                                    'Go to the Team tab to add players '
                                    'before setting up a match.',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.blueGrey,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }

                        return ListView.builder(
                          itemCount: players.length,
                          itemBuilder: (listContext, index) {
                            final player = players[index];
                            final isAlreadyAssigned = alreadyAssigned.any(
                              (p) => p.id == player.id,
                            );

                            return ListTile(
                              leading: CircleAvatar(
                                backgroundColor: Colors.blueGrey.withValues(
                                  alpha: 0.1,
                                ),
                                child: Text(player.firstName[0]),
                              ),
                              title: Text(player.fullName),
                              subtitle: Text(
                                player.preferredPositions
                                    .map((e) => e.name)
                                    .join(', '),
                              ),
                              trailing: isAlreadyAssigned
                                  ? const Icon(
                                      Icons.check_circle,
                                      color: Colors.grey,
                                    )
                                  : const Icon(Icons.add_circle_outline),
                              enabled: !isAlreadyAssigned,
                              onTap: () {
                                bloc.add(PositionAssigned(position, player));
                                Navigator.pop(bottomSheetContext);
                              },
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _PositionSlot extends StatelessWidget {
  const _PositionSlot({
    required this.position,
    required this.onTap,
    this.assignedPlayer,
  });
  final NetballPosition position;
  final Player? assignedPlayer;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: assignedPlayer != null
              ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.05)
              : Theme.of(
                  context,
                ).colorScheme.surfaceContainerHighest.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: assignedPlayer != null
                ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.3)
                : Colors.transparent,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  position.bib,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    assignedPlayer?.fullName ?? 'TAP TO ASSIGN PLAYER',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: assignedPlayer == null ? Colors.blueGrey : null,
                    ),
                  ),
                  if (assignedPlayer != null)
                    Text(
                      'Bib #${assignedPlayer?.primaryNumber ?? "—"}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.blueGrey,
                      ),
                    ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: Colors.blueGrey),
          ],
        ),
      ),
    );
  }
}
