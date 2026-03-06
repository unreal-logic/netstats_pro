import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:netstats_pro/domain/entities/player.dart';
import 'package:netstats_pro/presentation/management/bloc/players_bloc.dart';
import 'package:netstats_pro/presentation/management/bloc/players_event.dart';
import 'package:netstats_pro/presentation/management/bloc/players_state.dart';
import 'package:netstats_pro/presentation/widgets/premium_app_bar.dart';

class PlayersScreen extends StatefulWidget {
  const PlayersScreen({super.key, this.teamId});
  final int? teamId;

  @override
  State<PlayersScreen> createState() => _PlayersScreenState();
}

class _PlayersScreenState extends State<PlayersScreen> {
  @override
  void initState() {
    super.initState();
    // Handled in main.dart or here
    if (context.read<PlayersBloc>().state is PlayersInitial) {
      context.read<PlayersBloc>().add(LoadPlayers(teamId: widget.teamId));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PremiumAppBar(
        title: 'Player Roster',
      ),
      body: BlocBuilder<PlayersBloc, PlayersState>(
        builder: (context, state) {
          if (state is PlayersLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is PlayersError) {
            return Center(child: Text(state.message));
          }
          if (state is PlayersLoaded) {
            if (state.players.isEmpty) {
              return const Center(
                child: Text('No players yet. Add one below.'),
              );
            }
            return ListView.builder(
              itemCount: state.players.length,
              itemBuilder: (context, index) {
                final player = state.players[index];
                return ListTile(
                  leading: CircleAvatar(
                    child: Text(player.firstName[0] + player.lastName[0]),
                  ),
                  title: Text('${player.firstName} ${player.lastName}'),
                  subtitle: Text(
                    player.preferredPositions.isNotEmpty
                        ? player.preferredPositions.join(', ')
                        : 'Any',
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.grey),
                    onPressed: () {
                      context.read<PlayersBloc>().add(
                        DeletePlayer(player.id),
                      );
                    },
                  ),
                );
              },
            );
          }
          return const SizedBox();
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => unawaited(_showAddPlayerDialog(context)),
        icon: const Icon(Icons.person_add),
        label: const Text('Add Player'),
      ),
    );
  }

  Future<void> _showAddPlayerDialog(BuildContext context) async {
    final playersBloc = context.read<PlayersBloc>();
    final firstNameController = TextEditingController();
    final lastNameController = TextEditingController();
    final numberController = TextEditingController();
    final selectedPositions = <NetballPosition>[];

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (modalContext) => StatefulBuilder(
        builder: (stateContext, setModalState) => Container(
          decoration: BoxDecoration(
            color: Theme.of(stateContext).colorScheme.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: EdgeInsets.only(
            left: 24,
            right: 24,
            top: 16,
            bottom: MediaQuery.of(stateContext).viewInsets.bottom + 24,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 32,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Theme.of(stateContext).colorScheme.outlineVariant,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'Add New Player',
                  style: Theme.of(stateContext).textTheme.headlineSmall
                      ?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: firstNameController,
                        decoration: InputDecoration(
                          labelText: 'First Name',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextField(
                        controller: lastNameController,
                        decoration: InputDecoration(
                          labelText: 'Last Name',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: numberController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Jersey Number (Optional)',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    prefixIcon: const Icon(Icons.numbers_outlined),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'Preferred Positions',
                  style: Theme.of(stateContext).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: NetballPosition.values
                      .where((p) => p.index < 7)
                      .map((pos) {
                        final isSelected = selectedPositions.contains(pos);
                        return FilterChip(
                          label: Text(pos.name.toUpperCase()),
                          selected: isSelected,
                          onSelected: (selected) {
                            setModalState(() {
                              if (selected) {
                                selectedPositions.add(pos);
                              } else {
                                selectedPositions.remove(pos);
                              }
                            });
                          },
                        );
                      })
                      .toList(),
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: () {
                      if (firstNameController.text.isNotEmpty &&
                          lastNameController.text.isNotEmpty) {
                        final player = Player(
                          id: 0,
                          firstName: firstNameController.text,
                          lastName: lastNameController.text,
                          primaryNumber: int.tryParse(numberController.text),
                          preferredPositions: selectedPositions,
                          teamId: widget.teamId,
                          createdAt: DateTime.now(),
                        );
                        playersBloc.add(AddPlayer(player));
                        Navigator.pop(stateContext);
                      }
                    },
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Save Player'),
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
