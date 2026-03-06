import 'package:equatable/equatable.dart';

abstract class MatchSummaryEvent extends Equatable {
  const MatchSummaryEvent();

  @override
  List<Object?> get props => [];
}

class LoadMatchSummary extends MatchSummaryEvent {
  const LoadMatchSummary(this.gameId);
  final int gameId;

  @override
  List<Object?> get props => [gameId];
}
