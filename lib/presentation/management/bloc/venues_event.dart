import 'package:equatable/equatable.dart';
import 'package:netstats_pro/domain/entities/venue.dart';

abstract class VenuesEvent extends Equatable {
  const VenuesEvent();

  @override
  List<Object?> get props => [];
}

class LoadVenues extends VenuesEvent {}

class AddVenue extends VenuesEvent {
  const AddVenue(this.venue);
  final Venue venue;

  @override
  List<Object?> get props => [venue];
}

class DeleteVenue extends VenuesEvent {
  const DeleteVenue(this.id);
  final int id;

  @override
  List<Object?> get props => [id];
}
