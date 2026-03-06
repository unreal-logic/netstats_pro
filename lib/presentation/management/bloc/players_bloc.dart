import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:netstats_pro/domain/repositories/player_repository.dart';
import 'package:netstats_pro/presentation/management/bloc/players_event.dart';
import 'package:netstats_pro/presentation/management/bloc/players_state.dart';

class PlayersBloc extends Bloc<PlayersEvent, PlayersState> {
  PlayersBloc({required PlayerRepository repository})
    : _repository = repository,
      super(PlayersInitial()) {
    on<LoadPlayers>(_onLoadPlayers);
    on<AddPlayer>(_onAddPlayer);
    on<DeletePlayer>(_onDeletePlayer);
  }

  final PlayerRepository _repository;

  Future<void> _onLoadPlayers(
    LoadPlayers event,
    Emitter<PlayersState> emit,
  ) async {
    emit(PlayersLoading());
    try {
      final allPlayers = await _repository.getAllPlayers();
      final players = event.teamId != null
          ? allPlayers.where((p) => p.teamId == event.teamId).toList()
          : allPlayers;
      emit(PlayersLoaded(players));
    } on Exception catch (e) {
      emit(PlayersError('Failed to load players: $e'));
    }
  }

  Future<void> _onAddPlayer(
    AddPlayer event,
    Emitter<PlayersState> emit,
  ) async {
    try {
      if (event.player.id > 0) {
        await _repository.updatePlayer(event.player);
      } else {
        await _repository.createPlayer(event.player);
      }
      add(const LoadPlayers()); // Refresh
    } on Exception catch (e) {
      emit(PlayersError('Failed to save player: $e'));
    }
  }

  Future<void> _onDeletePlayer(
    DeletePlayer event,
    Emitter<PlayersState> emit,
  ) async {
    try {
      await _repository.deletePlayer(event.id);
      add(const LoadPlayers()); // Refresh
    } on Exception catch (e) {
      emit(PlayersError('Failed to delete player: $e'));
    }
  }
}
