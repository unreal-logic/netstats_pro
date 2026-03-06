import 'package:equatable/equatable.dart';
import 'package:netstats_pro/domain/entities/game.dart';

abstract class GamesEvent extends Equatable {
  const GamesEvent();

  @override
  List<Object?> get props => [];
}

class LoadGames extends GamesEvent {}

class GamesUpdated extends GamesEvent {
  const GamesUpdated(this.games);
  final List<Game> games;

  @override
  List<Object?> get props => [games];
}
