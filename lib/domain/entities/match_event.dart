import 'package:equatable/equatable.dart';

enum MatchEventType {
  goal,
  miss,
  goal2pt,
  miss2pt,
  goal3pt,
  miss3pt,
  turnover,
  intercept,
  deflection,
  offensiveRebound,
  defensiveRebound,
  assist,
  pickup,
  heldBall,
  centerPass,
  penaltyContact,
  penaltyObstruction,
  penalty,
  substitution,
  quarterStart,
  quarterEnd,
  adjustment,
}

class MatchEvent extends Equatable {
  const MatchEvent({
    required this.gameId,
    required this.quarter,
    required this.matchTime,
    required this.timestamp,
    required this.type,
    this.id,
    this.playerId,
    this.position,
    this.isSpecialScoring = false,
    this.isHomeTeam = true,
  });
  final int? id;
  final int gameId;
  final int quarter;
  final Duration matchTime;
  final DateTime timestamp;
  final MatchEventType type;
  final int? playerId;
  final String? position; // e.g. "GS", "A1"
  final bool isSpecialScoring;
  final bool isHomeTeam;

  @override
  List<Object?> get props => [
    id,
    gameId,
    quarter,
    matchTime,
    timestamp,
    type,
    playerId,
    position,
    isSpecialScoring,
    isHomeTeam,
  ];

  MatchEvent copyWith({
    int? id,
    int? gameId,
    int? quarter,
    Duration? matchTime,
    DateTime? timestamp,
    MatchEventType? type,
    int? playerId,
    String? position,
    bool? isSpecialScoring,
    bool? isHomeTeam,
  }) {
    return MatchEvent(
      id: id ?? this.id,
      gameId: gameId ?? this.gameId,
      quarter: quarter ?? this.quarter,
      matchTime: matchTime ?? this.matchTime,
      timestamp: timestamp ?? this.timestamp,
      type: type ?? this.type,
      playerId: playerId ?? this.playerId,
      position: position ?? this.position,
      isSpecialScoring: isSpecialScoring ?? this.isSpecialScoring,
      isHomeTeam: isHomeTeam ?? this.isHomeTeam,
    );
  }
}
