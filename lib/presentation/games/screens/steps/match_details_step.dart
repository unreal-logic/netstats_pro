import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:netstats_pro/domain/entities/competition.dart';
import 'package:netstats_pro/domain/entities/game.dart';
import 'package:netstats_pro/domain/entities/venue.dart';
import 'package:netstats_pro/presentation/games/bloc/setup_wizard_bloc.dart';
import 'package:netstats_pro/presentation/games/bloc/setup_wizard_event.dart';
import 'package:netstats_pro/presentation/games/bloc/setup_wizard_state.dart';
import 'package:netstats_pro/presentation/games/widgets/picker_bottom_sheet.dart';

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
                'TRACKING MODE',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.2,
                  color: Colors.blueGrey,
                ),
              ),
              const SizedBox(height: 12),
              _TrackingModeSelector(
                selectedMode: state.trackingMode,
                onChanged: (mode) => context.read<SetupWizardBloc>().add(
                  TrackingModeChanged(mode),
                ),
              ),
              const SizedBox(height: 32),
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
              PickerField(
                label: state.competitions
                    .where((c) => c.id == state.competitionId)
                    .map((c) => c.name)
                    .firstOrNull,
                placeholder: 'Select a competition',
                icon: Icons.emoji_events_outlined,
                onTap: () {
                  final bloc = context.read<SetupWizardBloc>();
                  showPickerSheet<Competition>(
                    context: context,
                    title: 'Competition',
                    icon: Icons.emoji_events_outlined,
                    items: state.competitions,
                    selectedId: state.competitionId,
                    getLabel: (c) => c.name,
                    getId: (c) => c.id,
                    onSelected: (id) => bloc.add(CompetitionSelected(id)),
                    onQuickCreate: (name, _) =>
                        bloc.add(QuickCreateCompetition(name)),
                    emptyIcon: Icons.emoji_events_outlined,
                    emptyTitle: 'No Competitions Yet',
                    emptySubtitle: 'Create your first competition to continue.',
                    createLabel: 'New Competition',
                  );
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
              PickerField(
                label: state.venues
                    .where((v) => v.id == state.venueId)
                    .map((v) => v.name)
                    .firstOrNull,
                placeholder: 'Select a venue',
                icon: Icons.location_on_outlined,
                onTap: () {
                  final bloc = context.read<SetupWizardBloc>();
                  showPickerSheet<Venue>(
                    context: context,
                    title: 'Venue',
                    icon: Icons.location_on_outlined,
                    items: state.venues,
                    selectedId: state.venueId,
                    getLabel: (v) => v.name,
                    getId: (v) => v.id,
                    onSelected: (id) => bloc.add(VenueSelected(id)),
                    onQuickCreate: (name, _) =>
                        bloc.add(QuickCreateVenue(name)),
                    emptyIcon: Icons.location_on_outlined,
                    emptyTitle: 'No Venues Yet',
                    emptySubtitle: 'Create your first venue to continue.',
                    createLabel: 'New Venue',
                  );
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

class _TrackingModeSelector extends StatelessWidget {
  const _TrackingModeSelector({
    required this.selectedMode,
    required this.onChanged,
  });
  final TrackingMode selectedMode;
  final ValueChanged<TrackingMode> onChanged;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isFullStats = selectedMode == TrackingMode.fullStatistics;

    return Container(
      height: 56,
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: cs.outline.withValues(alpha: 0.2)),
      ),
      padding: const EdgeInsets.all(4),
      child: Stack(
        children: [
          // Background labels
          Row(
            children: TrackingMode.values.map((mode) {
              return Expanded(
                child: Center(
                  child: Text(
                    mode.displayName.toUpperCase(),
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: cs.onSurfaceVariant.withValues(alpha: 0.4),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          // Animated Pill
          AnimatedAlign(
            duration: const Duration(milliseconds: 350),
            curve: Curves.easeOutBack,
            alignment: isFullStats
                ? Alignment.centerLeft
                : Alignment.centerRight,
            child: FractionallySizedBox(
              widthFactor: 0.5,
              child: Container(
                decoration: BoxDecoration(
                  color: cs.primary,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: cs.primary.withValues(alpha: 0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        isFullStats ? Icons.analytics : Icons.scoreboard,
                        color: cs.onPrimary,
                        size: 18,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        selectedMode.displayName.toUpperCase(),
                        style: TextStyle(
                          color: cs.onPrimary,
                          fontWeight: FontWeight.w900,
                          fontSize: 12,
                          letterSpacing: -0.2,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          // Clickable overlay
          Row(
            children: TrackingMode.values.map((mode) {
              return Expanded(
                child: GestureDetector(
                  onTap: () => onChanged(mode),
                  behavior: HitTestBehavior.opaque,
                  child: const SizedBox.expand(),
                ),
              );
            }).toList(),
          ),
        ],
      ),
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
