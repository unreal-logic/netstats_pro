import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:netstats_pro/core/design_system/design_overlay_settings.dart';
import 'package:netstats_pro/data/database/app_database.dart';
import 'package:netstats_pro/data/repositories/drift_competition_repository.dart';
import 'package:netstats_pro/data/repositories/drift_game_repository.dart';
import 'package:netstats_pro/data/repositories/drift_match_event_repository.dart';
import 'package:netstats_pro/data/repositories/drift_player_repository.dart';
import 'package:netstats_pro/data/repositories/drift_team_repository.dart';
import 'package:netstats_pro/data/repositories/drift_venue_repository.dart';
import 'package:netstats_pro/data/services/demo_data_service.dart';
import 'package:netstats_pro/domain/repositories/competition_repository.dart';
import 'package:netstats_pro/domain/repositories/game_repository.dart';
import 'package:netstats_pro/domain/repositories/match_event_repository.dart';
import 'package:netstats_pro/domain/repositories/player_repository.dart';
import 'package:netstats_pro/domain/repositories/team_repository.dart';
import 'package:netstats_pro/domain/repositories/venue_repository.dart';
import 'package:netstats_pro/domain/usecases/get_live_match_use_case.dart';
import 'package:netstats_pro/domain/usecases/get_match_summary_use_case.dart';
import 'package:netstats_pro/presentation/dashboard/bloc/dashboard_bloc.dart';
import 'package:netstats_pro/presentation/games/bloc/games_bloc.dart';
import 'package:netstats_pro/presentation/games/bloc/live_match_bloc.dart';
import 'package:netstats_pro/presentation/games/bloc/match_summary_bloc.dart';
import 'package:netstats_pro/presentation/games/bloc/setup_wizard_bloc.dart';
import 'package:netstats_pro/presentation/management/bloc/competitions_bloc.dart';
import 'package:netstats_pro/presentation/management/bloc/players_bloc.dart';
import 'package:netstats_pro/presentation/management/bloc/venues_bloc.dart';
import 'package:netstats_pro/presentation/team/bloc/teams_bloc.dart';

final GetIt sl = GetIt.instance;

Future<void> init() async {
  try {
    // Database
    final database = AppDatabase();

    sl
      ..registerSingleton<AppDatabase>(database)
      ..registerSingleton<DesignOverlaySettings>(DesignOverlaySettings())
      // ─── Repositories ─────────────────────────────────────────────────────
      ..registerLazySingleton<PlayerRepository>(
        () => DriftPlayerRepository(sl()),
      )
      ..registerLazySingleton<TeamRepository>(
        () => DriftTeamRepository(sl()),
      )
      ..registerLazySingleton<GameRepository>(
        () => DriftGameRepository(sl()),
      )
      ..registerLazySingleton<MatchEventRepository>(
        () => DriftMatchEventRepository(sl()),
      )
      ..registerLazySingleton<CompetitionRepository>(
        () => DriftCompetitionRepository(sl()),
      )
      ..registerLazySingleton<VenueRepository>(
        () => DriftVenueRepository(sl()),
      )
      // ─── Services ─────────────────────────────────────────────────────────
      ..registerLazySingleton<DemoDataService>(
        () => DemoDataService(
          teamRepository: sl(),
          playerRepository: sl(),
          competitionRepository: sl(),
          venueRepository: sl(),
        ),
      )
      // ─── Use Cases ────────────────────────────────────────────────────────
      ..registerLazySingleton<GetLiveMatchUseCase>(
        () => GetLiveMatchUseCase(
          gameRepository: sl(),
          matchEventRepository: sl(),
          playerRepository: sl(),
          teamRepository: sl(),
        ),
      )
      ..registerLazySingleton<GetMatchSummaryUseCase>(
        () => GetMatchSummaryUseCase(
          gameRepository: sl(),
          matchEventRepository: sl(),
          playerRepository: sl(),
        ),
      )
      // ─── BLoCs (factory = new instance per route) ─────────────────────────
      ..registerFactory(
        () => LiveMatchBloc(
          gameRepository: sl(),
          matchEventRepository: sl(),
          getLiveMatchUseCase: sl(),
        ),
      )
      ..registerFactory(
        () => GamesBloc(gameRepository: sl()),
      )
      ..registerFactory(
        () => DashboardBloc(
          gameRepository: sl(),
          getMatchSummaryUseCase: sl(),
        ),
      )
      ..registerFactory(
        () => MatchSummaryBloc(getMatchSummaryUseCase: sl()),
      )
      ..registerFactory(
        () => SetupWizardBloc(
          gameRepository: sl(),
          playerRepository: sl(),
          competitionRepository: sl(),
          venueRepository: sl(),
          teamRepository: sl(),
        ),
      )
      ..registerFactory(
        () => CompetitionsBloc(repository: sl()),
      )
      ..registerFactory(
        () => VenuesBloc(repository: sl()),
      )
      ..registerFactory(
        () => TeamsBloc(repository: sl()),
      )
      ..registerFactory(
        () => PlayersBloc(repository: sl()),
      );
  } on Object catch (e, stack) {
    debugPrint('DI Initialization Error: $e');
    debugPrint(stack.toString());
    // Optionally register mock repositories here if the app MUST run
  }
}
