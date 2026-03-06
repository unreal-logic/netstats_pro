import 'package:equatable/equatable.dart';
import 'package:netstats_pro/domain/entities/game.dart';

enum GamesStatus { initial, loading, success, failure }

class GamesState extends Equatable {
  const GamesState({
    this.status = GamesStatus.initial,
    this.games = const [],
  });

  final GamesStatus status;
  final List<Game> games;

  @override
  List<Object?> get props => [status, games];

  GamesState copyWith({
    GamesStatus? status,
    List<Game>? games,
  }) {
    return GamesState(
      status: status ?? this.status,
      games: games ?? this.games,
    );
  }
}
