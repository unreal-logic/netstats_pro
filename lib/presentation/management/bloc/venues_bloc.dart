import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:netstats_pro/domain/repositories/venue_repository.dart';
import 'package:netstats_pro/presentation/management/bloc/venues_event.dart';
import 'package:netstats_pro/presentation/management/bloc/venues_state.dart';

class VenuesBloc extends Bloc<VenuesEvent, VenuesState> {
  VenuesBloc({required VenueRepository repository})
    : _repository = repository,
      super(VenuesInitial()) {
    on<LoadVenues>(_onLoadVenues);
    on<AddVenue>(_onAddVenue);
    on<DeleteVenue>(_onDeleteVenue);
  }

  final VenueRepository _repository;

  Future<void> _onLoadVenues(
    LoadVenues event,
    Emitter<VenuesState> emit,
  ) async {
    emit(VenuesLoading());
    try {
      final venues = await _repository.getVenues();
      emit(VenuesLoaded(venues));
    } on Exception catch (e) {
      emit(VenuesError('Failed to load venues: $e'));
    }
  }

  Future<void> _onAddVenue(
    AddVenue event,
    Emitter<VenuesState> emit,
  ) async {
    try {
      await _repository.saveVenue(event.venue);
      add(LoadVenues()); // Refresh
    } on Exception catch (e) {
      emit(VenuesError('Failed to save venue: $e'));
    }
  }

  Future<void> _onDeleteVenue(
    DeleteVenue event,
    Emitter<VenuesState> emit,
  ) async {
    try {
      await _repository.deleteVenue(event.id);
      add(LoadVenues()); // Refresh
    } on Exception catch (e) {
      emit(VenuesError('Failed to delete venue: $e'));
    }
  }
}
