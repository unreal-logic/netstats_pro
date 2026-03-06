import 'package:equatable/equatable.dart';
import 'package:netstats_pro/domain/entities/player.dart';

abstract class PlayersEvent extends Equatable {
  const PlayersEvent();

  @override
  List<Object?> get props => [];
}

class LoadPlayers extends PlayersEvent {
  const LoadPlayers({this.teamId});
  final int? teamId;

  @override
  List<Object?> get props => [teamId];
}

class AddPlayer extends PlayersEvent {
  const AddPlayer(this.player);
  final Player player;

  @override
  List<Object?> get props => [player];
}

class DeletePlayer extends PlayersEvent {
  const DeletePlayer(this.id);
  final int id;

  @override
  List<Object?> get props => [id];
}
