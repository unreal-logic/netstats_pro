import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:netstats_pro/domain/entities/team.dart';
import 'package:netstats_pro/presentation/team/bloc/teams_bloc.dart';
import 'package:netstats_pro/presentation/team/bloc/teams_event.dart';
import 'package:netstats_pro/presentation/team/bloc/teams_state.dart';
import 'package:netstats_pro/presentation/widgets/premium_app_bar.dart';

class TeamScreen extends StatefulWidget {
  const TeamScreen({super.key});

  @override
  State<TeamScreen> createState() => _TeamScreenState();
}

class _TeamScreenState extends State<TeamScreen> {
  @override
  void initState() {
    super.initState();
    context.read<TeamsBloc>().add(LoadTeams());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PremiumAppBar(
        title: 'TEAMS',
      ),
      body: BlocBuilder<TeamsBloc, TeamsState>(
        builder: (context, state) {
          if (state is TeamsLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is TeamsError) {
            return Center(child: Text(state.message));
          }
          if (state is TeamsLoaded) {
            if (state.teams.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.group_outlined,
                      size: 64,
                      color: Theme.of(
                        context,
                      ).colorScheme.outline.withValues(alpha: 0.5),
                    ),
                    const SizedBox(height: 16),
                    const Text('No teams found. Create your first team!'),
                  ],
                ),
              );
            }
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: state.teams.length,
              itemBuilder: (context, index) {
                final team = state.teams[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor:
                          team.color ??
                          Theme.of(context).colorScheme.primaryContainer,
                      child: const Icon(
                        Icons.shield_outlined,
                        color: Colors.white,
                      ),
                    ),
                    title: Text(
                      team.name,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: const Text('View player roster and stats'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => context.push('/team/profile/${team.id}'),
                  ),
                );
              },
            );
          }
          return const SizedBox();
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => unawaited(_showAddTeamDialog(context)),
        icon: const Icon(Icons.add),
        label: const Text('New Team'),
      ),
    );
  }

  Future<void> _showAddTeamDialog(BuildContext context) async {
    final teamsBloc = context.read<TeamsBloc>();
    final nameController = TextEditingController();
    var selectedColor = Theme.of(context).colorScheme.primary;

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
                'Create New Team',
                style: Theme.of(stateContext).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: 'Team Name',
                  hintText: 'e.g. Melbourne Phoenix',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: const Icon(Icons.group_outlined),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Team Color',
                style: Theme.of(stateContext).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 50,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    _colorOption(
                      stateContext,
                      Colors.red,
                      selectedColor,
                      (c) => setModalState(() => selectedColor = c),
                    ),
                    _colorOption(
                      stateContext,
                      Colors.blue,
                      selectedColor,
                      (c) => setModalState(() => selectedColor = c),
                    ),
                    _colorOption(
                      stateContext,
                      Colors.green,
                      selectedColor,
                      (c) => setModalState(() => selectedColor = c),
                    ),
                    _colorOption(
                      stateContext,
                      Colors.orange,
                      selectedColor,
                      (c) => setModalState(() => selectedColor = c),
                    ),
                    _colorOption(
                      stateContext,
                      Colors.purple,
                      selectedColor,
                      (c) => setModalState(() => selectedColor = c),
                    ),
                    _colorOption(
                      stateContext,
                      Colors.teal,
                      selectedColor,
                      (c) => setModalState(() => selectedColor = c),
                    ),
                    _colorOption(
                      stateContext,
                      Colors.pink,
                      selectedColor,
                      (c) => setModalState(() => selectedColor = c),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () {
                    if (nameController.text.isNotEmpty) {
                      final team = Team(
                        id: 0,
                        name: nameController.text,
                        color: selectedColor,
                        createdAt: DateTime.now(),
                      );
                      teamsBloc.add(AddTeam(team));
                      Navigator.pop(stateContext);
                    }
                  },
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Create Team'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _colorOption(
    BuildContext context,
    Color color,
    Color selectedColor,
    void Function(Color) onSelect,
  ) {
    final isSelected = color == selectedColor;
    return GestureDetector(
      onTap: () => onSelect(color),
      child: Container(
        margin: const EdgeInsets.only(right: 12),
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: isSelected ? Border.all(color: Colors.white, width: 3) : null,
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: color.withValues(alpha: 0.4),
                    blurRadius: 8,
                    spreadRadius: 2,
                  ),
                ]
              : null,
        ),
      ),
    );
  }
}
