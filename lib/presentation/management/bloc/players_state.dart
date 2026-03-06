import 'package:equatable/equatable.dart';
import 'package:netstats_pro/domain/entities/player.dart';

abstract class PlayersState extends Equatable {
  const PlayersState();

  @override
  List<Object?> get props => [];
}

class PlayersInitial extends PlayersState {}

class PlayersLoading extends PlayersState {}

class PlayersLoaded extends PlayersState {
  const PlayersLoaded(this.players);
  final List<Player> players;

  @override
  List<Object?> get props => [players];
}

class PlayersError extends PlayersState {
  const PlayersError(this.message);
  final String message;

  @override
  List<Object?> get props => [message];
}
