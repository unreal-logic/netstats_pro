import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:netstats_pro/domain/entities/game.dart';
import 'package:netstats_pro/domain/entities/match_event.dart';
import 'package:netstats_pro/domain/repositories/game_repository.dart';
import 'package:netstats_pro/domain/repositories/match_event_repository.dart';
import 'package:netstats_pro/domain/usecases/get_live_match_use_case.dart';
import 'package:netstats_pro/presentation/games/bloc/live_match_event.dart';
import 'package:netstats_pro/presentation/games/bloc/live_match_state.dart';

class LiveMatchBloc extends Bloc<LiveMatchEvent, LiveMatchState> {
  LiveMatchBloc({
    required this.gameRepository,
    required this.matchEventRepository,
    required this.getLiveMatchUseCase,
  }) : super(const LiveMatchState()) {
    on<StartMatch>(_onStartMatch);
    on<LogEvent>(_onLogEvent);
    on<TogglePowerPlay>(_onTogglePowerPlay);
    on<UpdateClock>(_onUpdateClock);
    on<ChangeQuarter>(_onChangeQuarter);
    on<UndoEvent>(_onUndoEvent);
    on<EndMatch>(_onEndMatch);
    on<StartTimer>(_onStartTimer);
    on<PauseTimer>(_onPauseTimer);
    on<ResetTimer>(_onResetTimer);
    on<PlayerTap>(_onPlayerTap);
    on<ToggleLayout>(_onToggleLayout);
    on<SelectPendingStat>(_onSelectPendingStat);
    on<ToggleActiveTeam>(_onToggleActiveTeam);
    on<TogglePossession>(_onTogglePossession);
    on<ToggleTimer>(_onToggleTimer);
    on<ToggleTeamPowerPlay>(_onToggleTeamPowerPlay);
    on<AddExtraQuarter>(_onAddExtraQuarter);
  }
  final GameRepository gameRepository;
  final MatchEventRepository matchEventRepository;
  final GetLiveMatchUseCase getLiveMatchUseCase;
  Timer? _timer;

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }

  Future<void> _onStartMatch(
    StartMatch event,
    Emitter<LiveMatchState> emit,
  ) async {
    emit(state.copyWith(status: LiveMatchStatus.loading));
    try {
      final data = await getLiveMatchUseCase(event.gameId);
      final game = data.game;
      final events = data.events;
      final homeLineup = data.homeLineup;

      // Calculate initial scores based on history
      var home = 0;
      var away = 0;
      for (final e in events) {
        final pts = _calculatePoints(e, game);
        if (e.isHomeTeam) {
          home += pts;
        } else {
          away += pts;
        }
      }
      final currentQuarter = events.isEmpty ? 1 : events.last.quarter;
      final remaining = _getQuarterDuration(game, currentQuarter);

      emit(
        state.copyWith(
          status: LiveMatchStatus.active,
          game: game,
          events: events,
          scoreHome: home,
          scoreAway: away,
          currentQuarter: currentQuarter,
          remainingTime: remaining,
          homeHasPossession: game.ourFirstCentrePass,
          nextCenterPassIsHome: game.ourFirstCentrePass,
          homeLineup: homeLineup,
          homeTeamColor: _parseHexColor(data.homeTeamColor),
          opponentTeamColor: _parseHexColor(data.opponentTeamColor),
          isHomePowerPlayActive:
              game.fast5PowerPlayMode == Fast5PowerPlayMode.nominated &&
              game.homePowerPlayQuarter == currentQuarter,
          isAwayPowerPlayActive:
              game.fast5PowerPlayMode == Fast5PowerPlayMode.nominated &&
              game.awayPowerPlayQuarter == currentQuarter,
          isSpecialScoringActive: _checkSpecialScoringActive(
            game,
            remaining,
            currentQuarter,
          ),
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: LiveMatchStatus.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Color? _parseHexColor(String? hex) {
    if (hex == null || hex.isEmpty) return null;
    try {
      final buffer = StringBuffer();
      // Remove # if present
      var clean = hex.replaceAll('#', '');
      // Handle 6-char hex by adding FF at the start
      if (clean.length == 6) {
        clean = 'FF$clean';
      }
      buffer.write(clean);
      return Color(int.parse(buffer.toString(), radix: 16));
    } catch (e) {
      return Colors.transparent;
    }
  }

  Future<void> _onLogEvent(LogEvent event, Emitter<LiveMatchState> emit) async {
    if (state.game == null) return;

    // Determine special scoring status BEFORE creating the event
    bool isSpecial;
    if (state.game!.format == GameFormat.fiveAside &&
        state.game!.fast5PowerPlayMode == Fast5PowerPlayMode.nominated) {
      isSpecial = event.isHomeTeam
          ? state.isHomePowerPlayActive
          : state.isAwayPowerPlayActive;
    } else {
      isSpecial = state.isSpecialScoringActive;
    }

    final matchEvent = MatchEvent(
      gameId: state.game!.id,
      quarter: state.currentQuarter,
      matchTime: state.matchTime,
      timestamp: DateTime.now(),
      type: event.type,
      // Inject selected player if not explicitly provided
      playerId: event.playerId ?? state.activePlayerId,
      position: event.position ?? state.activePlayerPosition,
      isSpecialScoring: isSpecial,
      isHomeTeam: event.isHomeTeam,
    );

    try {
      unawaited(matchEventRepository.saveEvent(matchEvent));
      final updatedEvents = List<MatchEvent>.from(state.events)
        ..add(matchEvent);

      final points = _calculatePoints(matchEvent, state.game!);

      LiveMatchState newState;

      if (event.isHomeTeam) {
        newState = state.copyWith(
          events: updatedEvents,
          scoreHome: state.scoreHome + points,
          clearActivePlayer: true, // Clear selection after logging
          clearPendingStat: true, // Clear pending stat after logging
        );
      } else {
        newState = state.copyWith(
          events: updatedEvents,
          scoreAway: state.scoreAway + points,
          clearActivePlayer: true,
          clearPendingStat: true,
        );
      }

      // Auto-toggle possession on goals
      if (event.type == MatchEventType.goal ||
          event.type == MatchEventType.goal2pt ||
          event.type == MatchEventType.goal3pt) {
        if (state.game?.format == GameFormat.sevenAside) {
          // 7-aside: Strictly alternate based on the next taker in sequence
          newState = newState.copyWith(
            homeHasPossession: !state.nextCenterPassIsHome,
            nextCenterPassIsHome: !state.nextCenterPassIsHome,
          );
        } else {
          // 5 & 6-aside: Goal Against rule (non-scoring team gets possession)
          newState = newState.copyWith(
            homeHasPossession: !event.isHomeTeam,
            // Keep sequence in sync for quarter starts
            nextCenterPassIsHome: !event.isHomeTeam,
          );
        }
      }

      emit(newState);
    } catch (e) {
      debugPrint('Error saving event: $e');
    }
  }

  void _onPlayerTap(PlayerTap event, Emitter<LiveMatchState> emit) {
    if (state.pendingStat != null) {
      // If we have a pending stat, logging it takes precedence
      // Determine if home team based on player ID for now
      // (1-7 are home in mock data)
      final isHome = event.playerId <= 7;
      add(
        LogEvent(
          type: state.pendingStat!,
          playerId: event.playerId,
          position: event.position,
          isHomeTeam: isHome,
        ),
      );
      return;
    }

    final isHome = event.playerId <= 7;
    if (state.activePlayerId == event.playerId) {
      // Deselect if tapping the currently selected player
      emit(state.copyWith(clearActivePlayer: true));
    } else {
      emit(
        state.copyWith(
          activePlayerId: event.playerId,
          activePlayerPosition: event.position,
          activeTeamId: isHome ? 0 : 1,
        ),
      );
    }
  }

  void _onSelectPendingStat(
    SelectPendingStat event,
    Emitter<LiveMatchState> emit,
  ) {
    emit(
      state.copyWith(
        pendingStat: event.statType,
        clearPendingStat: event.statType == null,
      ),
    );
  }

  void _onToggleLayout(ToggleLayout event, Emitter<LiveMatchState> emit) {
    emit(state.copyWith(isErgonomicLayout: !state.isErgonomicLayout));
  }

  void _onToggleActiveTeam(
    ToggleActiveTeam event,
    Emitter<LiveMatchState> emit,
  ) {
    emit(state.copyWith(activeTeamId: state.activeTeamId == 0 ? 1 : 0));
  }

  void _onTogglePossession(
    TogglePossession event,
    Emitter<LiveMatchState> emit,
  ) {
    emit(state.copyWith(homeHasPossession: !state.homeHasPossession));
  }

  Duration _getQuarterDuration(Game game, int quarter) {
    if (state.customQuarterDurations.containsKey(quarter)) {
      return state.customQuarterDurations[quarter]!;
    }
    return Duration(minutes: game.quarterDurationMinutes);
  }

  void _onTogglePowerPlay(TogglePowerPlay event, Emitter<LiveMatchState> emit) {
    if (state.game?.format == GameFormat.fiveAside &&
        state.game?.fast5PowerPlayMode == Fast5PowerPlayMode.nominated) {
      // In nominated mode, standard toggle doesn't apply to both teams
      return;
    }
    emit(state.copyWith(isSpecialScoringActive: !state.isSpecialScoringActive));
  }

  void _onToggleTeamPowerPlay(
    ToggleTeamPowerPlay event,
    Emitter<LiveMatchState> emit,
  ) {
    // NOMINATED mode: Manual toggling is disabled as it's driven by pre-match selection
    // and auto-activated on quarter change.
    return;
  }

  void _onUpdateClock(UpdateClock event, Emitter<LiveMatchState> emit) {
    if (state.game == null) return;
    final total = _getQuarterDuration(state.game!, state.currentQuarter);
    final remaining = total - event.elapsed;

    if (remaining <= Duration.zero) {
      add(PauseTimer());
      emit(
        state.copyWith(
          matchTime: total,
          remainingTime: Duration.zero,
          isTimerRunning: false,
        ),
      );
    } else {
      // Auto-activate Super Shot / Power Play based on rules
      final active = _checkSpecialScoringActive(
        state.game!,
        remaining,
        state.currentQuarter,
      );

      // Trigger haptic feedback when Super Shot/Power Play turns on
      if (active && !state.isSpecialScoringActive) {
        unawaited(HapticFeedback.heavyImpact());
      }

      emit(
        state.copyWith(
          matchTime: event.elapsed,
          remainingTime: remaining,
          isSpecialScoringActive: active,
        ),
      );
    }
  }

  bool _checkSpecialScoringActive(
    Game game,
    Duration remaining,
    int quarter,
  ) {
    // SSN (7-aside): Last 5 mins of EACH quarter
    if (game.format == GameFormat.sevenAside && game.isSuperShot) {
      return remaining <= const Duration(minutes: 5);
    }

    // FAST5 (5-aside): Last 90 seconds of EACH quarter
    if (game.format == GameFormat.fiveAside) {
      if (game.fast5PowerPlayMode == Fast5PowerPlayMode.contested) {
        return remaining <= const Duration(seconds: 90);
      }
      // Nominated mode handled by team-specific flags
      return false;
    }

    return false;
  }

  void _onChangeQuarter(ChangeQuarter event, Emitter<LiveMatchState> emit) {
    if (state.game == null) return;
    _onPauseTimer(PauseTimer(), emit);
    final remaining = _getQuarterDuration(state.game!, event.quarter);
    emit(
      state.copyWith(
        currentQuarter: event.quarter,
        matchTime: Duration.zero,
        remainingTime: remaining,
        homeHasPossession: state.nextCenterPassIsHome,
        // For FAST5, if we want to follow "A B A B" start rule exactly:
        // nextCenterPassIsHome: !previousQuarterStartIsHome
        // But the 7-aside "Continuous Sequence" rule is more robust if a quarter ends mid-pass.
        isHomePowerPlayActive:
            state.game?.fast5PowerPlayMode == Fast5PowerPlayMode.nominated &&
            state.game?.homePowerPlayQuarter == event.quarter,
        isAwayPowerPlayActive:
            state.game?.fast5PowerPlayMode == Fast5PowerPlayMode.nominated &&
            state.game?.awayPowerPlayQuarter == event.quarter,
        isSpecialScoringActive: _checkSpecialScoringActive(
          state.game!,
          remaining,
          event.quarter,
        ),
      ),
    );
  }

  void _onAddExtraQuarter(AddExtraQuarter event, Emitter<LiveMatchState> emit) {
    if (state.game == null) return;
    _onPauseTimer(PauseTimer(), emit);

    final nextQuarter = state.currentQuarter + 1;
    final updatedDurations = Map<int, Duration>.from(
      state.customQuarterDurations,
    )..[nextQuarter] = event.duration;

    emit(
      state.copyWith(
        currentQuarter: nextQuarter,
        matchTime: Duration.zero,
        remainingTime: event.duration,
        customQuarterDurations: updatedDurations,
        homeHasPossession: state.nextCenterPassIsHome,
        // Rules usually revert to standard for extra time unless specified
        isHomePowerPlayActive: false,
        isAwayPowerPlayActive: false,
        isSpecialScoringActive: false,
      ),
    );
  }

  void _onStartTimer(StartTimer event, Emitter<LiveMatchState> emit) {
    if (state.isTimerRunning) return;

    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      add(UpdateClock(state.matchTime + const Duration(seconds: 1)));
    });

    emit(state.copyWith(isTimerRunning: true));
    unawaited(HapticFeedback.mediumImpact());
  }

  void _onPauseTimer(PauseTimer event, Emitter<LiveMatchState> emit) {
    _timer?.cancel();
    _timer = null;
    emit(state.copyWith(isTimerRunning: false));
  }

  void _onToggleTimer(ToggleTimer event, Emitter<LiveMatchState> emit) {
    if (state.isTimerRunning) {
      add(PauseTimer());
    } else {
      add(StartTimer());
    }
  }

  void _onResetTimer(ResetTimer event, Emitter<LiveMatchState> emit) {
    if (state.game == null) return;
    _onPauseTimer(PauseTimer(), emit);
    final remaining = _getQuarterDuration(state.game!, state.currentQuarter);
    emit(
      state.copyWith(
        matchTime: Duration.zero,
        remainingTime: remaining,
        isSpecialScoringActive: _checkSpecialScoringActive(
          state.game!,
          remaining,
          state.currentQuarter,
        ),
      ),
    );
  }

  Future<void> _onUndoEvent(
    UndoEvent event,
    Emitter<LiveMatchState> emit,
  ) async {
    if (state.events.isEmpty) return;

    final lastEvent = state.events.last;
    if (lastEvent.id == null) {
      return; // Should not happen with real persisted events
    }

    try {
      await matchEventRepository.deleteEvent(lastEvent.id!);
      final updatedEvents = List<MatchEvent>.from(state.events)..removeLast();

      final points = _calculatePoints(lastEvent, state.game!);

      LiveMatchState newState;
      if (lastEvent.isHomeTeam) {
        newState = state.copyWith(
          events: updatedEvents,
          scoreHome: state.scoreHome - points,
        );
      } else {
        newState = state.copyWith(
          events: updatedEvents,
          scoreAway: state.scoreAway - points,
        );
      }

      // Revert possession on undone goals
      if (lastEvent.type == MatchEventType.goal ||
          lastEvent.type == MatchEventType.goal2pt ||
          lastEvent.type == MatchEventType.goal3pt) {
        if (state.game?.format == GameFormat.sevenAside) {
          // Revert alternating sequence
          newState = newState.copyWith(
            nextCenterPassIsHome: !state.nextCenterPassIsHome,
            homeHasPossession: !state
                .nextCenterPassIsHome, // Set to the newly reverted next taker
          );
        } else {
          // 5/6-aside: Revert Goal Against (give back to scorer)
          newState = newState.copyWith(
            homeHasPossession: lastEvent.isHomeTeam,
            nextCenterPassIsHome: lastEvent.isHomeTeam,
          );
        }
      }

      emit(newState);
    } catch (e) {
      debugPrint('Error undoing event: $e');
    }
  }

  Future<void> _onEndMatch(EndMatch event, Emitter<LiveMatchState> emit) async {
    if (state.game == null) return;

    try {
      final updatedGame = state.game!.copyWith(
        status: GameStatus.completed,
        homeScore: state.scoreHome,
        awayScore: state.scoreAway,
      );

      await gameRepository.updateGame(updatedGame);
      emit(state.copyWith(status: LiveMatchStatus.finished, game: updatedGame));
    } catch (e) {
      emit(
        state.copyWith(
          status: LiveMatchStatus.error,
          errorMessage: 'Failed to end match: $e',
        ),
      );
    }
  }

  int _calculatePoints(MatchEvent event, Game game) {
    var basePoints = 0;
    switch (event.type) {
      case MatchEventType.goal:
        basePoints = 1;
      case MatchEventType.goal2pt:
        basePoints = 2;
      case MatchEventType.goal3pt:
        basePoints = 3;
      case MatchEventType.miss:
      case MatchEventType.miss2pt:
      case MatchEventType.miss3pt:
      case MatchEventType.turnover:
      case MatchEventType.intercept:
      case MatchEventType.deflection:
      case MatchEventType.offensiveRebound:
      case MatchEventType.defensiveRebound:
      case MatchEventType.assist:
      case MatchEventType.pickup:
      case MatchEventType.heldBall:
      case MatchEventType.centerPass:
      case MatchEventType.penaltyContact:
      case MatchEventType.penaltyObstruction:
      case MatchEventType.penalty:
      case MatchEventType.substitution:
      case MatchEventType.quarterStart:
      case MatchEventType.quarterEnd:
        return 0;
      case MatchEventType.adjustment:
        return -1;
    }

    // Apply Super Shot for SSN (7-aside)
    if (game.format == GameFormat.sevenAside && game.isSuperShot) {
      if (event.type == MatchEventType.goal2pt) {
        return event.isSpecialScoring ? 2 : 1;
      }
      // 3pt shots are not standard in SSN, but if they exist, treat as 1pt or 2pt
      if (event.type == MatchEventType.goal3pt) {
        return event.isSpecialScoring ? 2 : 1;
      }
    }

    // Apply FAST5 Power Play multiplier
    if (game.format == GameFormat.fiveAside && event.isSpecialScoring) {
      return basePoints * 2;
    }

    return basePoints;
  }
}
