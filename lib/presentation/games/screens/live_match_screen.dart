import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:netstats_pro/core/design_system/design_system.dart';
import 'package:netstats_pro/domain/entities/game.dart';
import 'package:netstats_pro/domain/entities/match_event.dart';
import 'package:netstats_pro/presentation/games/bloc/live_match_bloc.dart';
import 'package:netstats_pro/presentation/games/bloc/live_match_event.dart';
import 'package:netstats_pro/presentation/games/bloc/live_match_state.dart';
import 'package:netstats_pro/presentation/games/widgets/duration_stepper.dart';
import 'package:netstats_pro/presentation/games/widgets/premium_scoreboard.dart';
import 'package:netstats_pro/presentation/games/widgets/score_only_grid.dart';
import 'package:netstats_pro/presentation/widgets/premium_app_bar.dart';

class LiveMatchScreen extends StatelessWidget {
  const LiveMatchScreen({required this.gameId, super.key});
  final int gameId;

  @override
  Widget build(BuildContext context) {
    return _LiveMatchView(gameId: gameId);
  }
}

class _LiveMatchView extends StatefulWidget {
  const _LiveMatchView({required this.gameId});
  final int gameId;

  @override
  State<_LiveMatchView> createState() => _LiveMatchScreenState();
}

class _LiveMatchScreenState extends State<_LiveMatchView>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    context.read<LiveMatchBloc>().add(StartMatch(widget.gameId));
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LiveMatchBloc, LiveMatchState>(
      builder: (context, state) {
        if (state.game == null) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final isScoreOnly = state.game?.trackingMode == TrackingMode.scoreOnly;

        if (isScoreOnly) {
          return _buildScoreOnlyLayout(context, state);
        }

        // Standard/Ergonomic Layouts
        return Scaffold(
          appBar: PremiumAppBar(
            title: '${state.game!.opponentName} Match',
            leading: IconButton(
              icon: const Icon(Icons.close_rounded),
              onPressed: () => context.go('/games'),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.undo),
                onPressed: () => context.read<LiveMatchBloc>().add(UndoEvent()),
              ),
              IconButton(
                icon: const Icon(Icons.settings),
                onPressed: () {},
              ),
            ],
            bottom: _buildMatchClockBar(state),
          ),
          body: state.isErgonomicLayout
              ? _buildErgonomicLayout(context, state)
              : _buildStandardLayout(context, state),
          bottomNavigationBar: _buildMatchControls(context, state),
        );
      },
    );
  }

  Widget _buildErgonomicLayout(BuildContext context, LiveMatchState state) {
    return const Center(child: Text('Ergonomic Layout'));
  }

  Widget _buildStandardLayout(BuildContext context, LiveMatchState state) {
    return Column(
      children: [
        PremiumScoreboard(
          homeTeamName: state.game?.homeTeamName ?? 'HOME',
          awayTeamName: state.game?.opponentName ?? 'AWAY',
          homeScore: state.scoreHome,
          awayScore: state.scoreAway,
          currentQuarter: state.currentQuarter,
          matchTime: state.remainingTime.formatted,
          homeHasPossession: state.homeHasPossession,
          isTimerRunning: state.isTimerRunning,
          isAtStart: state.matchTime == Duration.zero,
          isSpecialScoringActive: state.isSpecialScoringActive,
          isHomePowerPlayActive: state.isHomePowerPlayActive,
          isAwayPowerPlayActive: state.isAwayPowerPlayActive,
          isFinished: state.remainingTime == Duration.zero,
          isLastQuarter:
              state.currentQuarter >= (state.game?.totalQuarters ?? 4),
          format: state.game?.format ?? GameFormat.sevenAside,
          fast5PowerPlayMode: state.game?.fast5PowerPlayMode,
          isSuperShotEnabled: state.game?.isSuperShot ?? false,
          homeColor: state.homeTeamColor,
          awayColor: state.opponentTeamColor,
          onTimerTap: () {
            if (state.remainingTime == Duration.zero) {
              _showNextQuarterDialog(context, state);
            } else {
              context.read<LiveMatchBloc>().add(const ToggleTimer());
            }
          },
          onPossessionTap: () =>
              context.read<LiveMatchBloc>().add(TogglePossession()),
          onHomePowerPlayToggle: () => context.read<LiveMatchBloc>().add(
            const ToggleTeamPowerPlay(isHomeTeam: true),
          ),
          onAwayPowerPlayToggle: () => context.read<LiveMatchBloc>().add(
            const ToggleTeamPowerPlay(isHomeTeam: false),
          ),
        ),
        _buildHorizontalEventTicker(state),
        const Spacer(),
        // Standard layout content would go here
      ],
    );
  }

  Widget _buildScoreOnlyLayout(BuildContext context, LiveMatchState state) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: PremiumAppBar(
        title: '${state.game!.opponentName} Match',
        leading: IconButton(
          icon: const Icon(Icons.close_rounded),
          onPressed: () => context.go('/games'),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.undo),
            onPressed: () => context.read<LiveMatchBloc>().add(UndoEvent()),
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {},
          ),
        ],
        bottom: _buildMatchClockBar(state),
      ),
      body: Column(
        children: [
          PremiumScoreboard(
            homeTeamName: state.game?.homeTeamName ?? 'HOME',
            awayTeamName: state.game?.opponentName ?? 'AWAY',
            homeScore: state.scoreHome,
            awayScore: state.scoreAway,
            currentQuarter: state.currentQuarter,
            matchTime: state.remainingTime.formatted,
            homeHasPossession: state.homeHasPossession,
            isTimerRunning: state.isTimerRunning,
            isAtStart: state.matchTime == Duration.zero,
            isSpecialScoringActive: state.isSpecialScoringActive,
            isHomePowerPlayActive: state.isHomePowerPlayActive,
            isAwayPowerPlayActive: state.isAwayPowerPlayActive,
            isFinished: state.remainingTime == Duration.zero,
            isLastQuarter:
                state.currentQuarter >= (state.game?.totalQuarters ?? 4),
            format: state.game?.format ?? GameFormat.sevenAside,
            fast5PowerPlayMode: state.game?.fast5PowerPlayMode,
            isSuperShotEnabled: state.game?.isSuperShot ?? false,
            homeColor: state.homeTeamColor,
            awayColor: state.opponentTeamColor,
            onTimerTap: () {
              if (state.remainingTime == Duration.zero) {
                _showNextQuarterDialog(context, state);
              } else {
                context.read<LiveMatchBloc>().add(const ToggleTimer());
              }
            },
            onPossessionTap: () =>
                context.read<LiveMatchBloc>().add(TogglePossession()),
            onHomePowerPlayToggle: () => context.read<LiveMatchBloc>().add(
              const ToggleTeamPowerPlay(isHomeTeam: true),
            ),
            onAwayPowerPlayToggle: () => context.read<LiveMatchBloc>().add(
              const ToggleTeamPowerPlay(isHomeTeam: false),
            ),
          ),
          Expanded(
            child: ScoreOnlyGrid(
              game: state.game!,
              isSpecialScoringActive: state.isSpecialScoringActive,
              isHomePowerPlayActive: state.isHomePowerPlayActive,
              isAwayPowerPlayActive: state.isAwayPowerPlayActive,
              homeColor: state.homeTeamColor ?? cs.primary,
              awayColor: state.opponentTeamColor ?? cs.onSurface,
              onStatSelected: (type, {required isHome}) {
                context.read<LiveMatchBloc>().add(
                  LogEvent(
                    type: type,
                    isHomeTeam: isHome,
                  ),
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildMatchControls(context, state),
    );
  }

  Widget _buildMatchControls(BuildContext context, LiveMatchState state) {
    final cs = Theme.of(context).colorScheme;
    final bloc = context.read<LiveMatchBloc>();
    final isLastQuarter =
        state.currentQuarter >= (state.game?.totalQuarters ?? 4);

    return BottomAppBar(
      height: 80,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.px12,
      ),
      color: cs.surfaceContainerLow,
      child: Row(
        children: [
          // Reset Button
          _buildControlButton(
            icon: Icons.refresh_rounded,
            label: 'RESET',
            onTap: () => _showActionConfirmation(
              context,
              title: 'RESET TIMER?',
              message: 'This will reset the clock to the start of the quarter.',
              confirmLabel: 'RESET',
              isDanger: true,
              onConfirm: () => bloc.add(ResetTimer()),
            ),
            color: cs.onSurfaceVariant,
          ),
          const Spacer(),
          // Play/Pause Button
          SizedBox(
            height: 56,
            width: 160,
            child: Builder(
              builder: (context) {
                final isAtStart = state.matchTime == Duration.zero;
                final isFinished = state.remainingTime == Duration.zero;

                final String label;
                final IconData icon;
                final Color backgroundColor;
                final Color foregroundColor;
                final VoidCallback onTap;

                if (isFinished) {
                  label = isLastQuarter ? 'FINISH' : 'NEXT';
                  icon = isLastQuarter
                      ? Icons.check_circle_outline_rounded
                      : Icons.fast_forward_rounded;
                  backgroundColor = cs.primary;
                  foregroundColor = cs.onPrimary;
                  onTap = () => _showNextQuarterDialog(context, state);
                } else {
                  label = state.isTimerRunning
                      ? 'PAUSE'
                      : (isAtStart ? 'START' : 'RESUME');
                  icon = state.isTimerRunning
                      ? Icons.pause_rounded
                      : (isAtStart
                            ? Icons.play_arrow_rounded
                            : Icons.play_circle_outline_rounded);
                  backgroundColor = state.isTimerRunning
                      ? cs.error
                      : AppColors.success;
                  foregroundColor = state.isTimerRunning
                      ? cs.onError
                      : AppColors.onSuccess;
                  onTap = () => bloc.add(const ToggleTimer());
                }

                return FilledButton.icon(
                  onPressed: onTap,
                  style: FilledButton.styleFrom(
                    backgroundColor: backgroundColor,
                    foregroundColor: foregroundColor,
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.md,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: AppRadius.brLg,
                    ),
                    elevation: isFinished ? 4 : 0,
                    shadowColor: isFinished
                        ? backgroundColor.withValues(alpha: 0.3)
                        : Colors.transparent,
                  ),
                  icon: Icon(icon, size: 28),
                  label: Text(
                    label,
                    style: AppTypography.labelLarge.copyWith(
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.2,
                    ),
                  ),
                );
              },
            ),
          ),
          const Spacer(),
          // More Options Button
          _buildControlButton(
            icon: Icons.more_horiz_rounded,
            label: 'MORE',
            onTap: () => _showMoreMenu(context, state),
            color: cs.onSurfaceVariant,
          ),
        ],
      ),
    );
  }

  void _showMoreMenu(BuildContext context, LiveMatchState state) {
    final cs = Theme.of(context).colorScheme;
    final bloc = context.read<LiveMatchBloc>();

    unawaited(
      showModalBottomSheet<void>(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (context) => Container(
          padding: const EdgeInsets.all(AppSpacing.lg),
          decoration: BoxDecoration(
            color: cs.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.info_outline_rounded),
                title: const Text('Match Details'),
                onTap: () {
                  Navigator.pop(context);
                  _showMatchDetails(context, state);
                },
              ),
              ListTile(
                leading: const Icon(Icons.check_circle_outline_rounded),
                title: const Text('Finish Match'),
                onTap: () {
                  Navigator.pop(context);
                  _showActionConfirmation(
                    context,
                    title: 'FINISH MATCH?',
                    message: 'Are you sure you want to end the match now?',
                    confirmLabel: 'FINISH',
                    onConfirm: () => bloc.add(EndMatch()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showMatchDetails(BuildContext context, LiveMatchState state) {
    final cs = Theme.of(context).colorScheme;
    final game = state.game;
    if (game == null) return;

    unawaited(
      showModalBottomSheet<void>(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (context) => Container(
          padding: const EdgeInsets.all(AppSpacing.lg),
          decoration: BoxDecoration(
            color: cs.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'MATCH DETAILS',
                style: AppTypography.titleSmall.copyWith(
                  color: cs.onSurfaceVariant,
                  letterSpacing: 1.2,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              Container(
                decoration: BoxDecoration(
                  color: cs.surfaceContainerHigh.withValues(alpha: 0.5),
                  borderRadius: AppRadius.brLg,
                ),
                child: Column(
                  children: [
                    _buildSummaryRow(
                      context,
                      icon: Icons.group_rounded,
                      label: 'Opponent',
                      value: game.opponentName.toUpperCase(),
                    ),
                    const Divider(height: 1),
                    _buildSummaryRow(
                      context,
                      icon: Icons.emoji_events_rounded,
                      label: 'Competition',
                      value: game.competitionName.toUpperCase(),
                    ),
                    const Divider(height: 1),
                    _buildSummaryRow(
                      context,
                      icon: Icons.location_on_rounded,
                      label: 'Venue',
                      value: game.venueName?.toUpperCase() ?? 'NONE',
                    ),
                    const Divider(height: 1),
                    _buildSummaryRow(
                      context,
                      icon: Icons.access_time_filled_rounded,
                      label: 'Scheduled',
                      value:
                          '${game.scheduledAt.day} '
                                  '${_getMonth(game.scheduledAt)} - '
                                  '${game.scheduledAt.hour}:'
                                  '${game.scheduledAt.minute.toString().padLeft(2, '0')}'
                              .toUpperCase(),
                    ),
                    const Divider(height: 1),
                    _buildSummaryRow(
                      context,
                      icon: Icons.settings_rounded,
                      label: 'Format',
                      value: game.format.displayName.toUpperCase(),
                    ),
                    const Divider(height: 1),
                    _buildSummaryRow(
                      context,
                      icon: Icons.bolt_rounded,
                      label: 'Rules',
                      value:
                          (game.isSuperShot
                                  ? 'SUPER SHOT'
                                  : (game.format == GameFormat.fiveAside
                                        ? 'POWER PLAY'
                                        : 'STANDARD'))
                              .toUpperCase(),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
            ],
          ),
        ),
      ),
    );
  }

  String _getMonth(DateTime date) {
    const months = [
      'JAN',
      'FEB',
      'MAR',
      'APR',
      'MAY',
      'JUN',
      'JUL',
      'AUG',
      'SEP',
      'OCT',
      'NOV',
      'DEC',
    ];
    return months[date.month - 1];
  }

  Widget _buildSummaryRow(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
  }) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.px12,
      ),
      child: Row(
        children: [
          Icon(icon, size: 20, color: cs.onSurfaceVariant),
          const SizedBox(width: AppSpacing.md),
          Text(
            label,
            style: AppTypography.labelMedium.copyWith(
              color: cs.onSurfaceVariant,
            ),
          ),
          const Spacer(),
          Text(
            value,
            style: AppTypography.titleSmall.copyWith(
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }

  void _showNextQuarterDialog(BuildContext context, LiveMatchState state) {
    final bloc = context.read<LiveMatchBloc>();
    final isLastQuarter =
        state.currentQuarter >= (state.game?.totalQuarters ?? 4);

    _showActionConfirmation(
      context,
      title: isLastQuarter ? 'FINISH MATCH?' : 'NEXT QUARTER?',
      message: isLastQuarter
          ? 'Are you sure you want to end the match?'
          : 'Proceed to the next quarter?',
      confirmLabel: isLastQuarter ? 'FINISH' : 'NEXT',
      onConfirm: () {
        if (isLastQuarter) {
          bloc.add(EndMatch());
        } else {
          bloc.add(ChangeQuarter(state.currentQuarter + 1));
        }
      },
      additionalActions: [
        if (state.remainingTime == Duration.zero && isLastQuarter)
          TextButton.icon(
            onPressed: () {
              Navigator.of(context).pop(); // Close confirmation
              _showExtraQuarterDurationPicker(context, state);
            },
            icon: const Icon(Icons.add_circle_outline_rounded),
            label: const Text('ADD EXTRA QUARTER'),
          ),
      ],
    );
  }

  void _showExtraQuarterDurationPicker(
    BuildContext context,
    LiveMatchState state,
  ) {
    int selectedMinutes = 5; // Default overtime
    final bloc = context.read<LiveMatchBloc>();

    unawaited(
      showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (ctx) => StatefulBuilder(
          builder: (context, setModalState) {
            final cs = Theme.of(context).colorScheme;
            return Container(
              padding: const EdgeInsets.all(AppSpacing.lg),
              decoration: BoxDecoration(
                color: cs.surface,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(24),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: cs.onSurfaceVariant.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    'EXTRA QUARTER DURATION',
                    style: AppTypography.titleMedium.copyWith(
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  DurationStepper(
                    minutes: selectedMinutes,
                    onChanged: (val) =>
                        setModalState(() => selectedMinutes = val),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: FilledButton(
                      onPressed: () {
                        bloc.add(
                          AddExtraQuarter(Duration(minutes: selectedMinutes)),
                        );
                        Navigator.of(context).pop();
                      },
                      style: FilledButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: AppRadius.brLg,
                        ),
                      ),
                      child: const Text('START EXTRA QUARTER'),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text(
                        'CANCEL',
                        style: AppTypography.labelLarge.copyWith(
                          color: cs.onSurfaceVariant,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    required Color color,
    bool isPrimary = false,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: AppRadius.brMd,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: AppSpacing.xs,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 4),
            Text(
              label,
              style: AppTypography.labelSmall.copyWith(
                color: color,
                fontWeight: isPrimary ? FontWeight.w900 : FontWeight.w700,
                fontSize: 9,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildMatchClockBar(LiveMatchState state) {
    if (state.game == null) {
      return const PreferredSize(
        preferredSize: Size.fromHeight(0),
        child: SizedBox.shrink(),
      );
    }

    final isFiveAside = state.game?.format == GameFormat.fiveAside;
    Duration quarterDuration;
    if (state.customQuarterDurations.containsKey(state.currentQuarter)) {
      quarterDuration = state.customQuarterDurations[state.currentQuarter]!;
    } else {
      quarterDuration = Duration(minutes: state.game!.quarterDurationMinutes);
    }
    final totalSeconds = quarterDuration.inSeconds;

    final specialScoringDuration = isFiveAside
        ? const Duration(seconds: 90)
        : const Duration(minutes: 5);
    final thresholdSeconds = specialScoringDuration.inSeconds;
    final remainingSeconds = state.remainingTime.inSeconds;

    final isActive =
        state.isSpecialScoringActive ||
        state.isHomePowerPlayActive ||
        state.isAwayPowerPlayActive;
    final isNominatedMode =
        isFiveAside &&
        state.game?.fast5PowerPlayMode == Fast5PowerPlayMode.nominated;
    final isSpecialScoringApplicable =
        (isFiveAside && !isNominatedMode) || (state.game?.isSuperShot == true);

    final progress = (remainingSeconds / totalSeconds).clamp(0.0, 1.0);
    final markerPosition = (thresholdSeconds / totalSeconds).clamp(0.0, 1.0);

    late String label;
    bool shouldPulse = false;

    if (isActive) {
      if (isNominatedMode) {
        final isHome = state.isHomePowerPlayActive;
        final isAway = state.isAwayPowerPlayActive;

        if (isHome && isAway) {
          // Fallback for safety, though setup prevents this
          label = 'DUAL POWER PLAY ACTIVE';
        } else if (isHome) {
          final name = state.game?.homeTeamName.toUpperCase() ?? 'TEAM';
          label = '$name POWER PLAY';
        } else if (isAway) {
          final name = state.game?.opponentName.toUpperCase() ?? 'TEAM';
          label = '$name POWER PLAY';
        } else {
          label = 'POWER PLAY ACTIVE';
        }

        shouldPulse = true;
      } else {
        label = isFiveAside ? 'POWER PLAY ACTIVE' : 'SUPER SHOT ACTIVE';
        shouldPulse = true;
      }
    } else {
      // Standard Countdown (or Gap Countdown)
      if (isSpecialScoringApplicable && remainingSeconds > thresholdSeconds) {
        final gapSeconds = remainingSeconds - thresholdSeconds;
        final gapMins = gapSeconds ~/ 60;
        final gapSecs = gapSeconds % 60;
        final modeName = isFiveAside ? 'POWER PLAY' : 'SUPER SHOT';
        label = '$gapMins:${gapSecs.toString().padLeft(2, '0')} TO $modeName';

        // Pulse 5 seconds BEFORE activation
        if (gapSeconds <= 5 && state.isTimerRunning) {
          shouldPulse = true;
        }
      } else {
        // Standard Mode or past threshold
        label = 'QUARTER ${state.currentQuarter}';
      }
    }

    // ALWAYS pulse in the final 5 seconds of the quarter
    if (remainingSeconds <= 5 && remainingSeconds > 0 && state.isTimerRunning) {
      shouldPulse = true;
    }

    // Animation control
    if (shouldPulse && state.isTimerRunning && remainingSeconds > 0) {
      if (!_pulseController.isAnimating) {
        _pulseController.repeat(reverse: true);
      }
    } else {
      if (_pulseController.isAnimating) {
        _pulseController
          ..stop()
          ..reset();
      }
    }

    final baseColor = isActive ? AppColors.warning : AppColors.primary;

    return PreferredSize(
      preferredSize: const Size.fromHeight(24),
      child: AnimatedBuilder(
        animation: _pulseController,
        builder: (context, child) {
          final pulseValue = _pulseController.value;

          return Container(
            height: 24,
            width: double.infinity,
            decoration: BoxDecoration(
              color: baseColor.withValues(alpha: 0.1),
            ),
            child: Stack(
              children: [
                // Progress Bar
                Align(
                  alignment: Alignment.centerLeft,
                  child: FractionallySizedBox(
                    widthFactor: progress,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            baseColor,
                            baseColor.withValues(alpha: 0.6),
                          ],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: baseColor.withValues(
                              alpha: shouldPulse
                                  ? 0.3 + (pulseValue * 0.4)
                                  : 0.3,
                            ),
                            blurRadius: shouldPulse ? 8 + (pulseValue * 8) : 8,
                            spreadRadius: shouldPulse ? pulseValue * 3 : 1,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // Pulse overlay (White wash for final countdown)
                if (shouldPulse)
                  Positioned.fill(
                    child: Opacity(
                      opacity: pulseValue * 0.15,
                      child: Container(color: Colors.white),
                    ),
                  ),

                // Special Scoring Marker (Notch)
                if (!isActive &&
                    !isNominatedMode &&
                    isSpecialScoringApplicable &&
                    totalSeconds > 0)
                  Positioned(
                    left: MediaQuery.of(context).size.width * markerPosition,
                    top: 0,
                    bottom: 0,
                    child: Container(
                      width: 2,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.5),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.warning.withValues(alpha: 0.5),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                    ),
                  ),

                // Label overlay
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (isActive) ...[
                        Icon(
                          isFiveAside ? Icons.whatshot : Icons.bolt,
                          size: 14,
                          color: Colors.white,
                        ),
                        const SizedBox(width: 6),
                      ],
                      Text(
                        label,
                        style: AppTypography.labelSmall.copyWith(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1.2,
                          shadows: [
                            const Shadow(
                              color: Colors.black26,
                              blurRadius: 4,
                              offset: Offset(0, 1),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildHorizontalEventTicker(LiveMatchState state) {
    final recentEvents = state.events.reversed.take(15).toList();
    if (recentEvents.isEmpty) {
      return const SizedBox(height: 56);
    }

    return Container(
      height: 64,
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
        itemCount: recentEvents.length,
        separatorBuilder: (_, __) => AppSpacing.hGap8,
        itemBuilder: (context, index) {
          final event = recentEvents[index];
          final teamColor = event.isHomeTeam
              ? (state.homeTeamColor ?? Theme.of(context).colorScheme.primary)
              : (state.opponentTeamColor ??
                    Theme.of(context).colorScheme.secondary);

          // Resolve player info
          String displayName = 'TEAM';
          String? posLabel;

          if (event.playerId != null) {
            displayName = 'PLAYER';
          } else if (event.position != null) {
            posLabel = event.position!.toUpperCase();
          }

          return _buildTickerItem(
            context,
            event: event,
            teamColor: teamColor,
            displayName: displayName,
            posLabel: posLabel,
          );
        },
      ),
    );
  }

  Widget _buildTickerItem(
    BuildContext context, {
    required MatchEvent event,
    required Color teamColor,
    required String displayName,
    String? posLabel,
  }) {
    final cs = Theme.of(context).colorScheme;
    final isError =
        event.type == MatchEventType.miss ||
        event.type == MatchEventType.turnover ||
        event.type.name.contains('penalty');

    final color = isError ? cs.error : teamColor;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.px10,
        vertical: AppSpacing.px6,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: AppRadius.brLg,
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (posLabel != null) ...[
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.px4,
                vertical: 1,
              ),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.8),
                borderRadius: AppRadius.brSm,
              ),
              child: Text(
                posLabel,
                style: AppTypography.labelSmall.copyWith(
                  color: cs.onPrimary,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
            AppSpacing.hGap8,
          ],
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                displayName.toUpperCase(),
                style: AppTypography.labelSmall.copyWith(
                  color: color,
                  fontWeight: FontWeight.w800,
                  height: 1,
                ),
              ),
              Text(
                event.type.name.toUpperCase(),
                style: AppTypography.labelSmall.copyWith(
                  fontWeight: FontWeight.w500,
                  height: 1.2,
                ),
              ),
            ],
          ),
          AppSpacing.hGap8,
          Text(
            event.matchTime.formatted,
            style: AppTypography.labelSmall.copyWith(
              color: cs.outline,
            ),
          ),
        ],
      ),
    );
  }

  void _showActionConfirmation(
    BuildContext context, {
    required String title,
    required String message,
    required String confirmLabel,
    required VoidCallback onConfirm,
    bool isDanger = false,
    List<Widget>? additionalActions,
  }) {
    unawaited(
      showDialog<void>(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: Theme.of(context).colorScheme.surface,
          surfaceTintColor: Colors.transparent,
          shape: const RoundedRectangleBorder(borderRadius: AppRadius.brLg),
          title: Text(
            title,
            style: AppTypography.headlineSmall.copyWith(
              fontWeight: FontWeight.w900,
              letterSpacing: -0.5,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                message,
                style: AppTypography.bodyLarge.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              if (additionalActions != null &&
                  additionalActions.isNotEmpty) ...[
                const SizedBox(height: AppSpacing.lg),
                ...additionalActions,
              ],
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'CANCEL',
                style: AppTypography.labelLarge.copyWith(
                  fontWeight: FontWeight.w700,
                  color: Theme.of(context).colorScheme.outline,
                ),
              ),
            ),
            FilledButton(
              onPressed: () {
                Navigator.of(context).pop();
                onConfirm();
              },
              style: FilledButton.styleFrom(
                backgroundColor: isDanger
                    ? Theme.of(context).colorScheme.error
                    : Theme.of(context).colorScheme.primary,
                foregroundColor: isDanger
                    ? Theme.of(context).colorScheme.onError
                    : Theme.of(context).colorScheme.onPrimary,
                shape: RoundedRectangleBorder(borderRadius: AppRadius.brMd),
              ),
              child: Text(
                confirmLabel.toUpperCase(),
                style: AppTypography.labelLarge.copyWith(
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ],
        ),
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
