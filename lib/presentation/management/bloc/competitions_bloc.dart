import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:netstats_pro/domain/repositories/competition_repository.dart';
import 'package:netstats_pro/presentation/management/bloc/competitions_event.dart';
import 'package:netstats_pro/presentation/management/bloc/competitions_state.dart';

class CompetitionsBloc extends Bloc<CompetitionsEvent, CompetitionsState> {
  CompetitionsBloc({required CompetitionRepository repository})
    : _repository = repository,
      super(CompetitionsInitial()) {
    on<LoadCompetitions>(_onLoadCompetitions);
    on<AddCompetition>(_onAddCompetition);
    on<DeleteCompetition>(_onDeleteCompetition);
  }

  final CompetitionRepository _repository;

  Future<void> _onLoadCompetitions(
    LoadCompetitions event,
    Emitter<CompetitionsState> emit,
  ) async {
    emit(CompetitionsLoading());
    try {
      final comps = await _repository.getCompetitions();
      emit(CompetitionsLoaded(comps));
    } on Exception catch (e) {
      emit(CompetitionsError('Failed to load competitions: $e'));
    }
  }

  Future<void> _onAddCompetition(
    AddCompetition event,
    Emitter<CompetitionsState> emit,
  ) async {
    try {
      await _repository.saveCompetition(event.competition);
      add(LoadCompetitions()); // Refresh
    } on Exception catch (e) {
      emit(CompetitionsError('Failed to save competition: $e'));
    }
  }

  Future<void> _onDeleteCompetition(
    DeleteCompetition event,
    Emitter<CompetitionsState> emit,
  ) async {
    try {
      await _repository.deleteCompetition(event.id);
      add(LoadCompetitions()); // Refresh
    } on Exception catch (e) {
      emit(CompetitionsError('Failed to delete competition: $e'));
    }
  }
}
