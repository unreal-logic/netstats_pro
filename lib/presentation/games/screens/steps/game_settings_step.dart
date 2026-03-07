import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:netstats_pro/domain/entities/game.dart';
import 'package:netstats_pro/presentation/games/bloc/setup_wizard_bloc.dart';
import 'package:netstats_pro/presentation/games/bloc/setup_wizard_event.dart';
import 'package:netstats_pro/presentation/games/bloc/setup_wizard_state.dart';

class _CentrePassSelector extends StatelessWidget {
  const _CentrePassSelector({
    required this.isHomeTeam,
    required this.homeTeamName,
    required this.opponentName,
    required this.onChanged,
    this.homeTeamColor,
    this.opponentTeamColor,
  });

  final bool isHomeTeam;
  final String homeTeamName;
  final String opponentName;
  final ValueChanged<bool> onChanged;
  final Color? homeTeamColor;
  final Color? opponentTeamColor;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'FIRST CENTRE PASS',
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            letterSpacing: 1,
            color: Colors.blueGrey,
          ),
        ),
        const SizedBox(height: 12),
        GestureDetector(
          onTap: () => onChanged(!isHomeTeam),
          child: Container(
            height: 56,
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: cs.surfaceContainerHighest.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: cs.outline.withValues(alpha: 0.2)),
            ),
            child: Stack(
              children: [
                // Background stationary labels (dimmed)
                Row(
                  children: [
                    Expanded(
                      child: Center(
                        child: Text(
                          homeTeamName.toUpperCase(),
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: cs.onSurfaceVariant.withValues(alpha: 0.4),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Center(
                        child: Text(
                          opponentName.toUpperCase(),
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: cs.onSurfaceVariant.withValues(alpha: 0.4),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                // Animated Pill (Foreground)
                AnimatedAlign(
                  duration: const Duration(milliseconds: 350),
                  curve: Curves.easeOutBack,
                  alignment: isHomeTeam
                      ? Alignment.centerLeft
                      : Alignment.centerRight,
                  child: FractionallySizedBox(
                    widthFactor: 0.5,
                    child: Container(
                      decoration: BoxDecoration(
                        color: isHomeTeam
                            ? (homeTeamColor ?? cs.primary)
                            : (opponentTeamColor ?? cs.secondary),
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color:
                                (isHomeTeam
                                        ? (homeTeamColor ?? cs.primary)
                                        : (opponentTeamColor ?? cs.secondary))
                                    .withValues(alpha: 0.3),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (isHomeTeam) ...[
                              Icon(
                                Icons.sports_volleyball,
                                color: cs.onPrimary,
                                size: 18,
                              ),
                              const SizedBox(width: 8),
                            ],
                            Flexible(
                              child: Text(
                                (isHomeTeam ? homeTeamName : opponentName)
                                    .toUpperCase(),
                                style: TextStyle(
                                  color: cs.onPrimary,
                                  fontWeight: FontWeight.w900,
                                  fontSize: 12,
                                  letterSpacing: -0.2,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            if (!isHomeTeam) ...[
                              const SizedBox(width: 8),
                              Icon(
                                Icons.sports_volleyball,
                                color: cs.onPrimary,
                                size: 18,
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

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
                'GAME SETUP',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.2,
                  color: Colors.blueGrey,
                ),
              ),
              const SizedBox(height: 20),
              _CentrePassSelector(
                isHomeTeam: state.ourFirstCentrePass,
                homeTeamName: state.homeTeamName.isEmpty
                    ? 'Home'
                    : state.homeTeamName,
                opponentName: state.opponentName.isEmpty
                    ? 'Opponent'
                    : state.opponentName,
                homeTeamColor: state.homeTeamColor,
                opponentTeamColor: state.opponentTeamColor,
                onChanged: (val) => context.read<SetupWizardBloc>().add(
                  FirstCentrePassToggled(ourPass: val),
                ),
              ),
              const SizedBox(height: 24),
              _QuarterDurationStepper(
                minutes: state.quarterDurationMinutes,
                onChanged: (val) => context.read<SetupWizardBloc>().add(
                  QuarterDurationChanged(val),
                ),
              ),
              if (state.format == GameFormat.sevenAside) ...[
                const SizedBox(height: 32),
                const Text(
                  'SPECIAL RULES',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.2,
                    color: Colors.blueGrey,
                  ),
                ),
                const SizedBox(height: 16),
                Card(
                  child: SwitchListTile(
                    title: const Text(
                      'ENABLE SUPER SHOT',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: const Text(
                      'Activates in the final 5 minutes of each quarter',
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

class _QuarterDurationStepper extends StatelessWidget {
  const _QuarterDurationStepper({
    required this.minutes,
    required this.onChanged,
  });

  final int minutes;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'QUARTER DURATION (MINUTES)',
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            letterSpacing: 1,
            color: Colors.blueGrey,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            // Minus button
            _StepperButton(
              icon: Icons.remove,
              onPressed: minutes > 1 ? () => onChanged(minutes - 1) : null,
            ),
            const SizedBox(width: 8),
            // Central display
            Expanded(
              child: Container(
                height: 56,
                decoration: BoxDecoration(
                  color: cs.surfaceContainerHighest.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: cs.outline.withValues(alpha: 0.2)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '$minutes',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Icon(
                      Icons.timer_outlined,
                      size: 20,
                      color: cs.onSurfaceVariant.withValues(alpha: 0.6),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 8),
            // Plus button
            _StepperButton(
              icon: Icons.add,
              onPressed: minutes < 60 ? () => onChanged(minutes + 1) : null,
            ),
          ],
        ),
      ],
    );
  }
}

class _StepperButton extends StatelessWidget {
  const _StepperButton({required this.icon, this.onPressed});

  final IconData icon;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDisabled = onPressed == null;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: cs.surfaceContainerHighest.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isDisabled
                  ? cs.outline.withValues(alpha: 0.1)
                  : cs.outline.withValues(alpha: 0.3),
            ),
          ),
          child: Icon(
            icon,
            color: isDisabled
                ? cs.onSurface.withValues(alpha: 0.2)
                : cs.onSurface,
          ),
        ),
      ),
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
