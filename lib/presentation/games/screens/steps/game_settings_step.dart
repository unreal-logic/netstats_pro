import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:netstats_pro/domain/entities/game.dart';
import 'package:netstats_pro/presentation/games/bloc/setup_wizard_bloc.dart';
import 'package:netstats_pro/presentation/games/bloc/setup_wizard_event.dart';
import 'package:netstats_pro/presentation/games/bloc/setup_wizard_state.dart';

class GameSettingsStep extends StatelessWidget {
  const GameSettingsStep({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SetupWizardBloc, SetupWizardState>(
      builder: (context, state) {
        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'GAME SETTINGS',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.2,
                  color: Colors.blueGrey,
                ),
              ),
              const SizedBox(height: 8),
              Card(
                child: SwitchListTile(
                  title: const Text(
                    'OUR FIRST CENTRE PASS',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: const Text('Toggle off if opponent has first pass'),
                  value: state.ourFirstCentrePass,
                  onChanged: (val) => context.read<SetupWizardBloc>().add(
                    FirstCentrePassToggled(ourPass: val),
                  ),
                  secondary: const Icon(Icons.sports),
                ),
              ),
              if (state.format == GameFormat.sevenAside) ...[
                const SizedBox(height: 16),
                Card(
                  child: SwitchListTile(
                    title: const Text(
                      'SUPER SHOT RULES',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: const Text(
                      'Enable 2-point shots and power plays',
                    ),
                    value: state.isSuperShot,
                    onChanged: (val) => context.read<SetupWizardBloc>().add(
                      IsSuperShotToggled(isSuperShot: val),
                    ),
                    secondary: const Icon(Icons.bolt, color: Colors.amber),
                  ),
                ),
              ],
              const SizedBox(height: 32),
              const Text(
                'MATCH SUMMARY',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.2,
                  color: Colors.blueGrey,
                ),
              ),
              const SizedBox(height: 12),
              _SummaryCard(state: state),
            ],
          ),
        );
      },
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({required this.state});
  final SetupWizardState state;

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('EEE, d MMM - HH:mm');

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(
          context,
        ).colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.blueGrey.withValues(alpha: 0.1)),
      ),
      child: Column(
        children: [
          _SummaryRow(
            label: 'Opponent',
            value: state.opponentName,
            icon: Icons.group,
          ),
          const Divider(height: 24),
          _SummaryRow(
            label: 'Competition',
            value:
                state.competitions
                    .where((c) => c.id == state.competitionId)
                    .map((c) => c.name)
                    .firstOrNull ??
                'N/A',
            icon: Icons.emoji_events,
          ),
          const Divider(height: 24),
          _SummaryRow(
            label: 'Venue',
            value:
                state.venues
                    .where((v) => v.id == state.venueId)
                    .map((v) => v.name)
                    .firstOrNull ??
                'N/A',
            icon: Icons.location_on,
          ),
          const Divider(height: 24),
          _SummaryRow(
            label: 'Scheduled',
            value: dateFormat.format(state.scheduledAt),
            icon: Icons.access_time,
          ),
          const Divider(height: 24),
          _SummaryRow(
            label: 'Format',
            value: state.format.displayName,
            icon: Icons.settings,
          ),
          if (state.isSuperShot) ...[
            const Divider(height: 24),
            const _SummaryRow(
              label: 'Rules',
              value: 'SUPER SHOT',
              icon: Icons.bolt,
            ),
          ],
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({
    required this.label,
    required this.value,
    required this.icon,
  });
  final String label;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18, color: Colors.blueGrey),
        const SizedBox(width: 12),
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: Colors.blueGrey),
        ),
        const Spacer(),
        Text(
          value.toUpperCase(),
          style: const TextStyle(fontWeight: FontWeight.w800),
        ),
      ],
    );
  }
}
