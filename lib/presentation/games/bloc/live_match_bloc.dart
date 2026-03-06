import 'dart:async';
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

      emit(
        state.copyWith(
          status: LiveMatchStatus.active,
          game: game,
          events: events,
          scoreHome: home,
          scoreAway: away,
          currentQuarter: events.isEmpty ? 1 : events.last.quarter,
          remainingTime: _getQuarterDuration(game.format),
          homeHasPossession: game.ourFirstCentrePass,
          homeLineup: homeLineup,
        ),
      );
    } on Object catch (e) {
      emit(
        state.copyWith(
          status: LiveMatchStatus.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _onLogEvent(LogEvent event, Emitter<LiveMatchState> emit) async {
    if (state.game == null) return;

    final matchEvent = MatchEvent(
      gameId: state.game!.id,
      quarter: state.currentQuarter,
      matchTime: state.matchTime,
      timestamp: DateTime.now(),
      type: event.type,
      // Inject selected player if not explicitly provided
      playerId: event.playerId ?? state.activePlayerId,
      position: event.position ?? state.activePlayerPosition,
      isPowerPlay: state.isPowerPlayActive,
      isHomeTeam: event.isHomeTeam,
    );

    try {
      await matchEventRepository.saveEvent(matchEvent);
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
        newState = newState.copyWith(
          homeHasPossession: !newState.homeHasPossession,
        );
      }

      emit(newState);
    } on Object catch (_) {
      // Handle error
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

  Duration _getQuarterDuration(GameFormat format) {
    switch (format) {
      case GameFormat.sevenAside:
        return const Duration(minutes: 15);
      case GameFormat.sixAside:
        return const Duration(minutes: 10);
      case GameFormat.fiveAside:
        return const Duration(minutes: 6);
    }
  }

  void _onTogglePowerPlay(TogglePowerPlay event, Emitter<LiveMatchState> emit) {
    emit(state.copyWith(isPowerPlayActive: !state.isPowerPlayActive));
  }

  void _onUpdateClock(UpdateClock event, Emitter<LiveMatchState> emit) {
    if (state.game == null) return;
    final total = _getQuarterDuration(state.game!.format);
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
      emit(state.copyWith(matchTime: event.elapsed, remainingTime: remaining));
    }
  }

  void _onChangeQuarter(ChangeQuarter event, Emitter<LiveMatchState> emit) {
    if (state.game == null) return;
    _onPauseTimer(PauseTimer(), emit);
    emit(
      state.copyWith(
        currentQuarter: event.quarter,
        matchTime: Duration.zero,
        remainingTime: _getQuarterDuration(state.game!.format),
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
  }

  void _onPauseTimer(PauseTimer event, Emitter<LiveMatchState> emit) {
    _timer?.cancel();
    _timer = null;
    emit(state.copyWith(isTimerRunning: false));
  }

  void _onResetTimer(ResetTimer event, Emitter<LiveMatchState> emit) {
    if (state.game == null) return;
    _onPauseTimer(PauseTimer(), emit);
    emit(
      state.copyWith(
        matchTime: Duration.zero,
        remainingTime: _getQuarterDuration(state.game!.format),
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

      if (lastEvent.isHomeTeam) {
        emit(
          state.copyWith(
            events: updatedEvents,
            scoreHome: state.scoreHome - points,
          ),
        );
      } else {
        emit(
          state.copyWith(
            events: updatedEvents,
            scoreAway: state.scoreAway - points,
          ),
        );
      }
    } on Object catch (_) {
      // Handle error
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
    } on Object catch (e) {
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
    }

    // Apply FAST5 Power Play multiplier
    if (game.format == GameFormat.fiveAside && event.isPowerPlay) {
      return basePoints * 2;
    }

    return basePoints;
  }
}
