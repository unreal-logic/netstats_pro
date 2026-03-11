import 'dart:async';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:netstats_pro/domain/entities/game.dart';
import 'package:netstats_pro/domain/entities/match_event.dart';
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
        opponentName: 'Opponent',
        competitionName: 'Fallback',
        venueName: 'Fallback',
        scheduledAt: DateTime.now(),
        format: GameFormat.fiveAside,
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

    when(
      () => matchEventRepository.saveEvent(any()),
    ).thenAnswer((_) async => 100);
    when(() => gameRepository.updateGame(any())).thenAnswer((_) async {});

    liveMatchBloc = LiveMatchBloc(
      gameRepository: gameRepository,
      matchEventRepository: matchEventRepository,
      getLiveMatchUseCase: getLiveMatchUseCase,
    );
  });

  tearDown(() {
    unawaited(liveMatchBloc.close());
  });

  final fast5ContestedGame = Game(
    id: 1,
    homeTeamName: 'Home',
    opponentName: 'Away',
    competitionName: 'FAST5',
    venueName: 'Netball Centre',
    scheduledAt: DateTime.now(),
    format: GameFormat.fiveAside,
    status: GameStatus.inProgress,
    ourFirstCentrePass: true,
    createdAt: DateTime.now(),
    quarterDurationMinutes: 6,
  );

  final fast5NominatedGame = Game(
    id: 2,
    homeTeamName: 'Home',
    opponentName: 'Away',
    competitionName: 'FAST5',
    venueName: 'Netball Centre',
    scheduledAt: DateTime.now(),
    format: GameFormat.fiveAside,
    fast5PowerPlayMode: Fast5PowerPlayMode.nominated,
    status: GameStatus.inProgress,
    ourFirstCentrePass: true,
    createdAt: DateTime.now(),
    quarterDurationMinutes: 6,
  );

  group('FAST5 Contested Power Play', () {
    blocTest<LiveMatchBloc, LiveMatchState>(
      'goal in the last 90 seconds scores double (x2)',
      build: () => liveMatchBloc,
      seed: () => LiveMatchState(
        status: LiveMatchStatus.active,
        game: fast5ContestedGame,
        remainingTime: const Duration(seconds: 80), // Within last 90s
        isSpecialScoringActive: true,
      ),
      act: (bloc) => bloc.add(const LogEvent(type: MatchEventType.goal)),
      expect: () => [
        predicate<LiveMatchState>((state) => state.scoreHome == 2),
      ],
    );

    blocTest<LiveMatchBloc, LiveMatchState>(
      'goal outside the last 90 seconds scores normal (x1)',
      build: () => liveMatchBloc,
      seed: () => LiveMatchState(
        status: LiveMatchStatus.active,
        game: fast5ContestedGame,
        remainingTime: const Duration(minutes: 2), // Outside last 90s
      ),
      act: (bloc) => bloc.add(const LogEvent(type: MatchEventType.goal)),
      expect: () => [
        predicate<LiveMatchState>((state) => state.scoreHome == 1),
      ],
    );
  });

  group('FAST5 Nominated Power Play', () {
    blocTest<LiveMatchBloc, LiveMatchState>(
      'toggling home power play sets isHomePowerPlayActive '
      'and scores double for home',
      build: () => liveMatchBloc,
      seed: () => LiveMatchState(
        status: LiveMatchStatus.active,
        game: fast5NominatedGame,
      ),
      act: (bloc) {
        bloc
          ..add(const ToggleTeamPowerPlay(isHomeTeam: true))
          ..add(const LogEvent(type: MatchEventType.goal));
      },
      expect: () => [
        predicate<LiveMatchState>((state) => state.isHomePowerPlayActive),
        predicate<LiveMatchState>((state) => state.scoreHome == 2),
      ],
    );

    blocTest<LiveMatchBloc, LiveMatchState>(
      'away goal scores normal when only home power play is active',
      build: () => liveMatchBloc,
      seed: () => LiveMatchState(
        status: LiveMatchStatus.active,
        game: fast5NominatedGame,
        isHomePowerPlayActive: true,
      ),
      act: (bloc) => bloc.add(
        const LogEvent(type: MatchEventType.goal, isHomeTeam: false),
      ),
      expect: () => [
        predicate<LiveMatchState>((state) => state.scoreAway == 1),
      ],
    );

    blocTest<LiveMatchBloc, LiveMatchState>(
      'power play flags reset on quarter change',
      build: () => liveMatchBloc,
      seed: () => LiveMatchState(
        status: LiveMatchStatus.active,
        game: fast5NominatedGame,
        isHomePowerPlayActive: true,
        isAwayPowerPlayActive: true,
      ),
      act: (bloc) => bloc.add(const ChangeQuarter(2)),
      expect: () => [
        predicate<LiveMatchState>(
          (state) =>
              !state.isHomePowerPlayActive &&
              !state.isAwayPowerPlayActive &&
              state.currentQuarter == 2,
        ),
      ],
    );
  });
}
