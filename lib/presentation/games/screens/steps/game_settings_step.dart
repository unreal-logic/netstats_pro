import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:netstats_pro/domain/entities/game.dart';
import 'package:netstats_pro/presentation/games/bloc/setup_wizard_bloc.dart';
import 'package:netstats_pro/presentation/games/bloc/setup_wizard_event.dart';
import 'package:netstats_pro/presentation/games/bloc/setup_wizard_state.dart';
import 'package:netstats_pro/presentation/games/widgets/duration_stepper.dart';

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
            height: 58,
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: cs.surfaceContainerHighest.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: cs.outline.withValues(alpha: 0.15)),
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
                'MATCH SETUP',
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
              DurationStepper(
                title: 'QUARTER DURATION (MINUTES)',
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
              if (state.format == GameFormat.fiveAside) ...[
                const SizedBox(height: 32),
                const Text(
                  'POWER PLAY MODE',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.2,
                    color: Colors.blueGrey,
                  ),
                ),
                const SizedBox(height: 16),
                _Fast5PowerPlaySelector(
                  selectedMode: state.fast5PowerPlayMode,
                  onChanged: (mode) => context.read<SetupWizardBloc>().add(
                    Fast5PowerPlayModeChanged(mode),
                  ),
                ),
                if (state.fast5PowerPlayMode ==
                    Fast5PowerPlayMode.nominated) ...[
                  const SizedBox(height: 24),
                  _NominatedQuarterPicker(
                    title: 'HOME POWER PLAY',
                    teamName: state.homeTeamName,
                    teamColor: state.homeTeamColor,
                    selectedQuarter: state.homePowerPlayQuarter,
                    onChanged: (q) => context.read<SetupWizardBloc>().add(
                      HomePowerPlayQuarterChanged(q),
                    ),
                    disabledQuarter: state.awayPowerPlayQuarter,
                  ),
                  const SizedBox(height: 16),
                  _NominatedQuarterPicker(
                    title: 'OPPONENT POWER PLAY',
                    teamName: state.opponentName,
                    teamColor: state.opponentTeamColor,
                    selectedQuarter: state.awayPowerPlayQuarter,
                    onChanged: (q) => context.read<SetupWizardBloc>().add(
                      AwayPowerPlayQuarterChanged(q),
                    ),
                    disabledQuarter: state.homePowerPlayQuarter,
                  ),
                ],
              ],
              const SizedBox(height: 32),
              const Text(
                'MATCH DETAILS',
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
        ).colorScheme.surfaceContainerHighest.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
        ),
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
          if (state.format == GameFormat.fiveAside) ...[
            const Divider(height: 24),
            _SummaryRow(
              label: 'Power Play',
              value: state.fast5PowerPlayMode == Fast5PowerPlayMode.contested
                  ? 'LAST 90S'
                  : 'NOMINATED',
              icon: Icons.bolt,
            ),
            if (state.fast5PowerPlayMode == Fast5PowerPlayMode.nominated) ...[
              const Divider(height: 24),
              _SummaryRow(
                label: '${state.homeTeamName} PP',
                value: state.homePowerPlayQuarter != null
                    ? 'Q${state.homePowerPlayQuarter}'
                    : 'NOT SET',
                icon: Icons.whatshot,
              ),
              const Divider(height: 24),
              _SummaryRow(
                label: '${state.opponentName} PP',
                value: state.awayPowerPlayQuarter != null
                    ? 'Q${state.awayPowerPlayQuarter}'
                    : 'NOT SET',
                icon: Icons.whatshot,
              ),
            ],
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

class _Fast5PowerPlaySelector extends StatelessWidget {
  const _Fast5PowerPlaySelector({
    required this.selectedMode,
    required this.onChanged,
  });

  final Fast5PowerPlayMode selectedMode;
  final ValueChanged<Fast5PowerPlayMode> onChanged;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Column(
      children: Fast5PowerPlayMode.values.map((mode) {
        final isSelected = selectedMode == mode;
        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: InkWell(
            onTap: () => onChanged(mode),
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isSelected
                    ? cs.primaryContainer.withValues(alpha: 0.3)
                    : cs.surfaceContainerHighest.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isSelected
                      ? cs.primary.withValues(alpha: 0.5)
                      : cs.outline.withValues(alpha: 0.1),
                  width: isSelected ? 2 : 1,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    mode == Fast5PowerPlayMode.contested
                        ? Icons.timer_outlined
                        : Icons.star_outline_rounded,
                    color: isSelected ? cs.primary : cs.onSurfaceVariant,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          mode.displayName.toUpperCase(),
                          style: TextStyle(
                            fontWeight: FontWeight.w900,
                            letterSpacing: 0.5,
                            color: isSelected
                                ? cs.onPrimaryContainer
                                : cs.onSurface,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          mode.description,
                          style: TextStyle(
                            fontSize: 12,
                            color: cs.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (isSelected)
                    Icon(Icons.check_circle, color: cs.primary, size: 20),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _NominatedQuarterPicker extends StatelessWidget {
  const _NominatedQuarterPicker({
    required this.title,
    required this.teamName,
    required this.selectedQuarter,
    required this.onChanged,
    this.teamColor,
    this.disabledQuarter,
  });

  final String title;
  final String teamName;
  final int? selectedQuarter;
  final ValueChanged<int?> onChanged;
  final Color? teamColor;
  final int? disabledQuarter;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title.toUpperCase(),
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            letterSpacing: 1,
            color: Colors.blueGrey,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: List.generate(4, (index) {
            final quarter = index + 1;
            final isSelected = selectedQuarter == quarter;
            final isDisabled = disabledQuarter == quarter;

            return Expanded(
              child: Padding(
                padding: EdgeInsets.only(right: index == 3 ? 0 : 8),
                child: InkWell(
                  onTap: isDisabled
                      ? null
                      : () => onChanged(isSelected ? null : quarter),
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    height: 48,
                    decoration: BoxDecoration(
                      color: isSelected
                          ? (teamColor ?? cs.primary).withValues(alpha: 0.2)
                          : isDisabled
                          ? cs.onSurface.withValues(alpha: 0.05)
                          : cs.surfaceContainerHighest.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: isSelected
                            ? (teamColor ?? cs.primary)
                            : isDisabled
                            ? cs.outline.withValues(alpha: 0.05)
                            : cs.outline.withValues(alpha: 0.1),
                        width: isSelected ? 2 : 1,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        'Q$quarter',
                        style: TextStyle(
                          fontWeight: isSelected
                              ? FontWeight.w900
                              : FontWeight.w600,
                          color: isSelected
                              ? (teamColor ?? cs.primary)
                              : isDisabled
                              ? cs.onSurface.withValues(alpha: 0.2)
                              : cs.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }
}
