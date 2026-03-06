import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:netstats_pro/domain/entities/game.dart';
import 'package:netstats_pro/domain/repositories/game_repository.dart';
import 'package:netstats_pro/domain/usecases/get_match_summary_use_case.dart';
import 'package:netstats_pro/presentation/dashboard/bloc/dashboard_event.dart';
import 'package:netstats_pro/presentation/dashboard/bloc/dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  DashboardBloc({
    required this.gameRepository,
    required this.getMatchSummaryUseCase,
  }) : super(const DashboardState()) {
    on<LoadDashboard>(_onLoadDashboard);
    on<DashboardUpdated>(_onDashboardUpdated);
  }

  final GameRepository gameRepository;
  final GetMatchSummaryUseCase getMatchSummaryUseCase;
  StreamSubscription<List<Game>>? _gamesSubscription;

  Future<void> _onLoadDashboard(
    LoadDashboard event,
    Emitter<DashboardState> emit,
  ) async {
    emit(state.copyWith(status: DashboardStatus.loading));
    await _gamesSubscription?.cancel();
    _gamesSubscription = gameRepository.watchAllGames().listen(
      (games) => add(DashboardUpdated(games)),
    );
  }

  Future<void> _onDashboardUpdated(
    DashboardUpdated event,
    Emitter<DashboardState> emit,
  ) async {
    final completedGames = event.games
        .where((g) => g.status == GameStatus.completed)
        .toList();

    if (completedGames.isEmpty) {
      emit(
        state.copyWith(
          status: DashboardStatus.success,
          winRate: 0,
          goalAvg: 0,
          totalGames: 0,
          turnoversAvg: 0,
        ),
      );
      return;
    }

    final wins = completedGames
        .where((g) => (g.homeScore ?? 0) > (g.awayScore ?? 0))
        .length;
    final totalHomeGoals = completedGames.fold(
      0,
      (sum, g) => sum + (g.homeScore ?? 0),
    );

    var totalTurnovers = 0;
    for (final game in completedGames) {
      final summary = await getMatchSummaryUseCase(game.id);
      totalTurnovers += summary.homeStats.turnovers;
    }

    emit(
      state.copyWith(
        status: DashboardStatus.success,
        winRate: (wins / completedGames.length * 100).round(),
        goalAvg: (totalHomeGoals / completedGames.length * 10).round() / 10,
        totalGames: completedGames.length,
        turnoversAvg:
            (totalTurnovers / completedGames.length * 10).round() / 10,
        staminaAvg: 92, // Placeholder for now
      ),
    );
  }

  @override
  Future<void> close() async {
    await _gamesSubscription?.cancel();
    return super.close();
  }
}
