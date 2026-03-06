import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:netstats_pro/domain/entities/game.dart';
import 'package:netstats_pro/presentation/games/bloc/setup_wizard_bloc.dart';
import 'package:netstats_pro/presentation/games/bloc/setup_wizard_event.dart';
import 'package:netstats_pro/presentation/games/bloc/setup_wizard_state.dart';

class MatchDetailsStep extends StatelessWidget {
  const MatchDetailsStep({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SetupWizardBloc, SetupWizardState>(
      builder: (context, state) {
        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'GAME FORMAT',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.2,
                  color: Colors.blueGrey,
                ),
              ),
              const SizedBox(height: 12),
              _FormatSelector(
                selectedFormat: state.format,
                onChanged: (format) =>
                    context.read<SetupWizardBloc>().add(FormatChanged(format)),
              ),
              const SizedBox(height: 32),
              const Text(
                'COMPETITION',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.2,
                  color: Colors.blueGrey,
                ),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<int>(
                initialValue: state.competitionId,
                decoration: InputDecoration(
                  hintText: 'Select a Competition',
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
                items: state.competitions.map((comp) {
                  return DropdownMenuItem<int>(
                    value: comp.id,
                    child: Text(comp.name),
                  );
                }).toList(),
                onChanged: (val) {
                  if (val != null) {
                    context.read<SetupWizardBloc>().add(
                      CompetitionSelected(val),
                    );
                  }
                },
              ),
              const SizedBox(height: 20),
              const Text(
                'VENUE',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.2,
                  color: Colors.blueGrey,
                ),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<int>(
                initialValue: state.venueId,
                decoration: InputDecoration(
                  hintText: 'Select a Venue',
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
                items: state.venues.map((venue) {
                  return DropdownMenuItem<int>(
                    value: venue.id,
                    child: Text(venue.name),
                  );
                }).toList(),
                onChanged: (val) {
                  if (val != null) {
                    context.read<SetupWizardBloc>().add(VenueSelected(val));
                  }
                },
              ),
              const SizedBox(height: 20),
              _DateTimePicker(
                label: 'SCHEDULED TIME',
                value: state.scheduledAt,
                onChanged: (val) => context.read<SetupWizardBloc>().add(
                  ScheduledAtChanged(val),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _DateTimePicker extends StatelessWidget {
  const _DateTimePicker({
    required this.label,
    required this.value,
    required this.onChanged,
  });
  final String label;
  final DateTime value;
  final ValueChanged<DateTime> onChanged;

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('EEE, d MMM yyyy - HH:mm');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.2,
            color: Colors.blueGrey,
          ),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: () async {
            final date = await showDatePicker(
              context: context,
              initialDate: value,
              firstDate: DateTime.now().subtract(const Duration(days: 365)),
              lastDate: DateTime.now().add(const Duration(days: 365)),
            );
            if (date != null) {
              if (!context.mounted) return;
              final time = await showTimePicker(
                context: context,
                initialTime: TimeOfDay.fromDateTime(value),
              );
              if (time != null) {
                onChanged(
                  DateTime(
                    date.year,
                    date.month,
                    date.day,
                    time.hour,
                    time.minute,
                  ),
                );
              }
            }
          },
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(
                context,
              ).colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Theme.of(context).colorScheme.outline,
              ),
            ),
            child: Row(
              children: [
                const Icon(Icons.calendar_today, size: 18),
                const SizedBox(width: 12),
                Text(dateFormat.format(value)),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _FormatSelector extends StatelessWidget {
  const _FormatSelector({
    required this.selectedFormat,
    required this.onChanged,
  });
  final GameFormat selectedFormat;
  final ValueChanged<GameFormat> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: GameFormat.values.map((format) {
        final isSelected = selectedFormat == format;
        var subtitle = '';
        switch (format) {
          case GameFormat.sevenAside:
            subtitle = 'Standard Match / Super Netball';
          case GameFormat.sixAside:
            subtitle = 'Indoor / WINA Rules';
          case GameFormat.fiveAside:
            subtitle = 'FAST5 / Modern Format';
        }

        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: InkWell(
            onTap: () => onChanged(format),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isSelected
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.outline,
                  width: isSelected ? 2 : 1,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    isSelected
                        ? Icons.radio_button_checked
                        : Icons.radio_button_off,
                    size: isSelected ? 24 : 20,
                    color: isSelected
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(
                            context,
                          ).colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          format.displayName.toUpperCase(),
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                            color: isSelected
                                ? Theme.of(context).colorScheme.onSurface
                                : Theme.of(context).colorScheme.onSurfaceVariant
                                      .withValues(alpha: 0.7),
                          ),
                        ),
                        Text(
                          subtitle,
                          style: TextStyle(
                            fontSize: 12,
                            color: isSelected
                                ? Theme.of(context).colorScheme.onSurfaceVariant
                                : Theme.of(context).colorScheme.onSurfaceVariant
                                      .withValues(alpha: 0.5),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? Theme.of(
                              context,
                            ).colorScheme.primary.withValues(alpha: 0.15)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isSelected
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(context).colorScheme.outline,
                      ),
                    ),
                    child: Text(
                      '${format.playersPerSide} PLAYERS',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: isSelected
                            ? Theme.of(context).colorScheme.primary
                            : Colors.blueGrey,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
