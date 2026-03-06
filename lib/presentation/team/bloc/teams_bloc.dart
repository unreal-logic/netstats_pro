import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:netstats_pro/domain/repositories/team_repository.dart';
import 'package:netstats_pro/presentation/team/bloc/teams_event.dart';
import 'package:netstats_pro/presentation/team/bloc/teams_state.dart';

class TeamsBloc extends Bloc<TeamsEvent, TeamsState> {
  TeamsBloc({required TeamRepository repository})
    : _repository = repository,
      super(TeamsInitial()) {
    on<LoadTeams>(_onLoadTeams);
    on<AddTeam>(_onAddTeam);
    on<DeleteTeam>(_onDeleteTeam);
  }

  final TeamRepository _repository;

  Future<void> _onLoadTeams(
    LoadTeams event,
    Emitter<TeamsState> emit,
  ) async {
    emit(TeamsLoading());
    try {
      final teams = await _repository.getAllTeams();
      emit(TeamsLoaded(teams));
    } on Exception catch (e) {
      emit(TeamsError('Failed to load teams: $e'));
    }
  }

  Future<void> _onAddTeam(
    AddTeam event,
    Emitter<TeamsState> emit,
  ) async {
    try {
      await _repository.createTeam(event.team);
      add(LoadTeams()); // Refresh
    } on Exception catch (e) {
      emit(TeamsError('Failed to save team: $e'));
    }
  }

  Future<void> _onDeleteTeam(
    DeleteTeam event,
    Emitter<TeamsState> emit,
  ) async {
    try {
      await _repository.deleteTeam(event.id);
      add(LoadTeams()); // Refresh
    } on Exception catch (e) {
      emit(TeamsError('Failed to delete team: $e'));
    }
  }
}
