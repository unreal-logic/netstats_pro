import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:netstats_pro/domain/entities/game.dart';
import 'package:netstats_pro/domain/repositories/game_repository.dart';
import 'package:netstats_pro/presentation/games/bloc/games_event.dart';
import 'package:netstats_pro/presentation/games/bloc/games_state.dart';

class GamesBloc extends Bloc<GamesEvent, GamesState> {
  GamesBloc({required this.gameRepository}) : super(const GamesState()) {
    on<LoadGames>(_onLoadGames);
    on<GamesUpdated>(_onGamesUpdated);
    on<GamesLoadError>(_onGamesLoadError);
  }

  final GameRepository gameRepository;
  StreamSubscription<List<Game>>? _gamesSubscription;

  Future<void> _onLoadGames(LoadGames event, Emitter<GamesState> emit) async {
    emit(state.copyWith(status: GamesStatus.loading));
    await _gamesSubscription?.cancel();
    _gamesSubscription = gameRepository.watchAllGames().listen(
      (games) => add(GamesUpdated(games)),
      onError: (Object e, StackTrace s) => add(const GamesLoadError()),
    );
  }

  void _onGamesLoadError(GamesLoadError event, Emitter<GamesState> emit) {
    emit(state.copyWith(status: GamesStatus.failure));
  }

  void _onGamesUpdated(GamesUpdated event, Emitter<GamesState> emit) {
    emit(
      state.copyWith(
        status: GamesStatus.success,
        games: event.games,
      ),
    );
  }

  @override
  Future<void> close() async {
    await _gamesSubscription?.cancel();
    return super.close();
  }
}
