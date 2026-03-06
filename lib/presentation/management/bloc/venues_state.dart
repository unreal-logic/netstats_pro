import 'package:equatable/equatable.dart';
import 'package:netstats_pro/domain/entities/venue.dart';

abstract class VenuesState extends Equatable {
  const VenuesState();

  @override
  List<Object?> get props => [];
}

class VenuesInitial extends VenuesState {}

class VenuesLoading extends VenuesState {}

class VenuesLoaded extends VenuesState {
  const VenuesLoaded(this.venues);
  final List<Venue> venues;

  @override
  List<Object?> get props => [venues];
}

class VenuesError extends VenuesState {
  const VenuesError(this.message);
  final String message;

  @override
  List<Object?> get props => [message];
}
