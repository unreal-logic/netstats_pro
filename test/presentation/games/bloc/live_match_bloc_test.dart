import 'dart:async';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:netstats_pro/domain/entities/game.dart';
import 'package:netstats_pro/domain/entities/match_event.dart';
import 'package:netstats_pro/domain/entities/player.dart';
import 'package:netstats_pro/domain/repositories/game_repository.dart';
import 'package:netstats_pro/domain/repositories/match_event_repository.dart';
import 'package:netstats_pro/domain/usecases/get_live_match_use_case.dart';
import 'package:netstats_pro/presentation/games/bloc/live_match_bloc.dart';
import 'package:netstats_pro/presentation/games/bloc/live_match_event.dart';
import 'package:netstats_pro/presentation/games/bloc/live_match_state.dart';

class MockGameRepository extends Mock implements GameRepository {}

class MockMatchEventRepository extends Mock implements MatchEventRepository {}

class MockGetLiveMatchUseCase extends Mock implements GetLiveMatchUseCase {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late MockGameRepository gameRepository;
  late MockMatchEventRepository matchEventRepository;
  late MockGetLiveMatchUseCase getLiveMatchUseCase;
  late LiveMatchBloc liveMatchBloc;

  setUpAll(() {
    registerFallbackValue(
      MatchEvent(
        gameId: 1,
        quarter: 1,
        matchTime: Duration.zero,
        timestamp: DateTime.now(),
        type: MatchEventType.goal,
      ),
    );
    registerFallbackValue(
      Game(
        id: 1,
        opponentName: 'Test Opponent',
        competitionName: 'Fallback',
        venueName: 'Fallback',
        scheduledAt: DateTime.now(),
        format: GameFormat.sevenAside,
        status: GameStatus.scheduled,
        ourFirstCentrePass: true,
        createdAt: DateTime.now(),
      ),
    );
  });

  setUp(() {
    gameRepository = MockGameRepository();
    matchEventRepository = MockMatchEventRepository();
    getLiveMatchUseCase = MockGetLiveMatchUseCase();
    liveMatchBloc = LiveMatchBloc(
      gameRepository: gameRepository,
      matchEventRepository: matchEventRepository,
      getLiveMatchUseCase: getLiveMatchUseCase,
    );
  });

  tearDown(() {
    unawaited(liveMatchBloc.close());
  });

  final mockGame = Game(
    id: 1,
    opponentName: 'Test Opponent',
    competitionName: 'Test Comp',
    venueName: 'Test Venue',
    scheduledAt: DateTime.now(),
    format: GameFormat.sixAside,
    status: GameStatus.scheduled,
    ourFirstCentrePass: true,
    quarterDurationMinutes: 10,
    createdAt: DateTime.now(),
  );

  final mockLiveMatchData = LiveMatchData(
    game: mockGame,
    events: const [],
    homeLineup: const <NetballPosition, Player>{},
  );

  group('LiveMatchBloc', () {
    blocTest<LiveMatchBloc, LiveMatchState>(
      'emits [loading, active] when StartMatch triggers successfully',
      build: () {
        when(
          () => getLiveMatchUseCase(1),
        ).thenAnswer((_) async => mockLiveMatchData);
        return liveMatchBloc;
      },
      act: (bloc) => bloc.add(const StartMatch(1)),
      expect: () => [
        const LiveMatchState(status: LiveMatchStatus.loading),
        LiveMatchState(
          status: LiveMatchStatus.active,
          game: mockGame,
          remainingTime: const Duration(minutes: 10), // WINA 6-a-side default
        ),
      ],
    );

    blocTest<LiveMatchBloc, LiveMatchState>(
      'increments home score and auto-toggles possession on Home Goal',
      build: () {
        when(
          () => matchEventRepository.saveEvent(any()),
        ).thenAnswer((_) async => 100);
        when(() => gameRepository.updateGame(any())).thenAnswer((_) async {});
        return liveMatchBloc;
      },
      seed: () => LiveMatchState(
        status: LiveMatchStatus.active,
        game: mockGame,
      ),
      act: (bloc) => bloc.add(
        const LogEvent(type: MatchEventType.goal),
      ),
      expect: () => [
        predicate<LiveMatchState>((state) {
          return state.scoreHome == 1 &&
              !state.homeHasPossession &&
              state.events.length == 1;
        }),
      ],
    );

    blocTest<LiveMatchBloc, LiveMatchState>(
      'toggles timer running state on StartTimer and PauseTimer',
      build: () => liveMatchBloc,
      seed: () => LiveMatchState(
        status: LiveMatchStatus.active,
        game: mockGame,
      ),
      act: (bloc) {
        bloc
          ..add(StartTimer())
          ..add(PauseTimer());
      },
      expect: () => [
        predicate<LiveMatchState>((state) => state.isTimerRunning),
        predicate<LiveMatchState>((state) => !state.isTimerRunning),
      ],
    );

    blocTest<LiveMatchBloc, LiveMatchState>(
      'removes last event and reverts score on UndoEvent',
      build: () {
        when(
          () => matchEventRepository.deleteEvent(any()),
        ).thenAnswer((_) async {});
        return liveMatchBloc;
      },
      seed: () => LiveMatchState(
        status: LiveMatchStatus.active,
        game: mockGame,
        events: [
          MatchEvent(
            id: 1,
            gameId: 1,
            quarter: 1,
            matchTime: Duration.zero,
            timestamp: DateTime.now(),
            type: MatchEventType.goal,
          ),
        ],
        scoreHome: 1,
      ),
      act: (bloc) => bloc.add(UndoEvent()),
      expect: () => [
        predicate<LiveMatchState>((state) {
          return state.scoreHome == 0 && state.events.isEmpty;
        }),
      ],
      verify: (_) {
        verify(() => matchEventRepository.deleteEvent(1)).called(1);
      },
    );
  });
}
