import 'dart:async';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:netstats_pro/domain/entities/game.dart';
import 'package:netstats_pro/domain/repositories/game_repository.dart';
import 'package:netstats_pro/domain/usecases/get_match_summary_use_case.dart';
import 'package:netstats_pro/presentation/dashboard/bloc/dashboard_bloc.dart';
import 'package:netstats_pro/presentation/dashboard/bloc/dashboard_event.dart';
import 'package:netstats_pro/presentation/dashboard/bloc/dashboard_state.dart';

class MockGameRepository extends Mock implements GameRepository {}

class MockGetMatchSummaryUseCase extends Mock
    implements GetMatchSummaryUseCase {}

void main() {
  late MockGameRepository gameRepository;
  late MockGetMatchSummaryUseCase getMatchSummaryUseCase;
  late DashboardBloc dashboardBloc;

  setUp(() {
    gameRepository = MockGameRepository();
    getMatchSummaryUseCase = MockGetMatchSummaryUseCase();
    dashboardBloc = DashboardBloc(
      gameRepository: gameRepository,
      getMatchSummaryUseCase: getMatchSummaryUseCase,
    );
  });

  tearDown(() {
    unawaited(dashboardBloc.close());
  });

  final now = DateTime.now();
  final mockGames = [
    Game(
      id: 1,
      opponentName: 'Opponent 1',
      competitionName: 'Comp 1',
      venueName: 'Venue 1',
      scheduledAt: now,
      format: GameFormat.sevenAside,
      status: GameStatus.completed,
      homeScore: 45,
      awayScore: 40,
      ourFirstCentrePass: true,
      createdAt: now,
    ),
    Game(
      id: 2,
      opponentName: 'Opponent 2',
      competitionName: 'Comp 1',
      venueName: 'Venue 1',
      scheduledAt: now,
      format: GameFormat.sevenAside,
      status: GameStatus.completed,
      homeScore: 30,
      awayScore: 35,
      ourFirstCentrePass: true,
      createdAt: now,
    ),
  ];

  group('DashboardBloc', () {
    blocTest<DashboardBloc, DashboardState>(
      'emits [loading, success] with correct statistics when games are loaded',
      build: () {
        when(() => gameRepository.watchAllGames()).thenAnswer(
          (_) => Stream.value(mockGames),
        );
        when(() => getMatchSummaryUseCase.call(1)).thenAnswer(
          (_) async => MatchSummaryData(
            game: mockGames[0],
            events: const [],
            homeLineup: const {},
            homeStats: const TeamMatchStats(
              goals: 45,
              misses: 0,
              shootingPercentage: 100,
              intercepts: 5,
              turnovers: 10,
              rebounds: 2,
            ),
            awayStats: const TeamMatchStats(
              goals: 40,
              misses: 0,
              shootingPercentage: 100,
              intercepts: 0,
              turnovers: 0,
              rebounds: 0,
            ),
          ),
        );
        when(() => getMatchSummaryUseCase.call(2)).thenAnswer(
          (_) async => MatchSummaryData(
            game: mockGames[1],
            events: const [],
            homeLineup: const {},
            homeStats: const TeamMatchStats(
              goals: 30,
              misses: 0,
              shootingPercentage: 100,
              intercepts: 3,
              turnovers: 14,
              rebounds: 1,
            ),
            awayStats: const TeamMatchStats(
              goals: 35,
              misses: 0,
              shootingPercentage: 100,
              intercepts: 0,
              turnovers: 0,
              rebounds: 0,
            ),
          ),
        );

        return dashboardBloc;
      },
      act: (bloc) => bloc.add(LoadDashboard()),
      expect: () => [
        const DashboardState(status: DashboardStatus.loading),
        const DashboardState(
          status: DashboardStatus.success,
          winRate: 50, // 1 win out of 2 completed
          goalAvg: 37.5, // (45 + 30) / 2
          totalGames: 2,
          turnoversAvg: 12,
          staminaAvg: 92,
        ),
      ],
    );

    blocTest<DashboardBloc, DashboardState>(
      'emits zeros when no completed games exist',
      build: () {
        when(() => gameRepository.watchAllGames()).thenAnswer(
          (_) => Stream.value([
            mockGames[0].copyWith(status: GameStatus.scheduled),
          ]),
        );
        return dashboardBloc;
      },
      act: (bloc) => bloc.add(LoadDashboard()),
      expect: () => [
        const DashboardState(status: DashboardStatus.loading),
        const DashboardState(status: DashboardStatus.success),
      ],
    );
  });
}
