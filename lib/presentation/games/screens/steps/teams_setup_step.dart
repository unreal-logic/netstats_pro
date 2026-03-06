import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:netstats_pro/domain/entities/game.dart';
import 'package:netstats_pro/domain/entities/player.dart';
import 'package:netstats_pro/domain/entities/team.dart';
import 'package:netstats_pro/domain/repositories/player_repository.dart';
import 'package:netstats_pro/injection_container.dart';
import 'package:netstats_pro/presentation/games/bloc/setup_wizard_bloc.dart';
import 'package:netstats_pro/presentation/games/bloc/setup_wizard_event.dart';
import 'package:netstats_pro/presentation/games/bloc/setup_wizard_state.dart';

class TeamsSetupStep extends StatelessWidget {
  const TeamsSetupStep({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SetupWizardBloc, SetupWizardState>(
      builder: (context, state) {
        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'HOME TEAM',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.2,
                  color: Colors.blueGrey,
                ),
              ),
              const SizedBox(height: 8),
              _TeamSelector(
                label: 'Select Home Team',
                value: state.homeTeamId,
                teams: state.teams,
                onChanged: (id) {
                  if (id != null) {
                    final team = state.teams.firstWhere((t) => t.id == id);
                    context.read<SetupWizardBloc>().add(
                      HomeTeamNameChanged(team.name, teamId: id),
                    );
                  }
                },
              ),
              const SizedBox(height: 32),
              const Text(
                'OPPONENT',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.2,
                  color: Colors.blueGrey,
                ),
              ),
              const SizedBox(height: 8),
              _TeamSelector(
                label: 'Select Opponent',
                value: state.opponentTeamId,
                teams: state.teams,
                onChanged: (id) {
                  if (id != null) {
                    final team = state.teams.firstWhere((t) => t.id == id);
                    context.read<SetupWizardBloc>().add(
                      OpponentNameChanged(team.name, teamId: id),
                    );
                  }
                },
              ),
              const SizedBox(height: 12),
              Text(
                'Tip: You can manage your teams and players '
                'in the Management section.',
                style: TextStyle(
                  fontSize: 12,
                  fontStyle: FontStyle.italic,
                  color: Colors.blueGrey.withValues(alpha: 0.7),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _TeamSelector extends StatelessWidget {
  const _TeamSelector({
    required this.label,
    required this.value,
    required this.teams,
    required this.onChanged,
  });

  final String label;
  final int? value;
  final List<Team> teams;
  final ValueChanged<int?> onChanged;

  @override
  Widget build(BuildContext context) {
    // Ensure value is in items, or null if empty
    final currentValue = teams.any((t) => t.id == value) ? value : null;

    return DropdownButtonFormField<int>(
      initialValue: currentValue,
      hint: Text(label),
      isExpanded: true,
      decoration: InputDecoration(
        filled: true,
        fillColor: Theme.of(
          context,
        ).colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.all(16),
      ),
      items: teams.map((team) {
        return DropdownMenuItem<int>(
          value: team.id,
          child: Text(team.name),
        );
      }).toList(),
      onChanged: onChanged,
    );
  }
}
