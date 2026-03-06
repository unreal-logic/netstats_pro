import 'package:equatable/equatable.dart';
import 'package:netstats_pro/domain/entities/player.dart';

enum GameFormat {
  sevenAside('7 aside', 7, [
    NetballPosition.gs,
    NetballPosition.ga,
    NetballPosition.wa,
    NetballPosition.c,
    NetballPosition.wd,
    NetballPosition.gd,
    NetballPosition.gk,
  ]),
  sixAside('6 aside', 6, [
    NetballPosition.a1,
    NetballPosition.a2,
    NetballPosition.l1,
    NetballPosition.l2,
    NetballPosition.d1,
    NetballPosition.d2,
  ]),
  fiveAside('5 aside', 5, [
    NetballPosition.gs,
    NetballPosition.ga,
    NetballPosition.c,
    NetballPosition.gd,
    NetballPosition.gk,
  ])
  ;

  const GameFormat(this.displayName, this.playersPerSide, this.positions);

  final String displayName;
  final int playersPerSide;
  final List<NetballPosition> positions;
}

enum GameStatus { scheduled, inProgress, completed, cancelled }

class Game extends Equatable {
  const Game({
    required this.id,
    required this.opponentName,
    required this.competitionName,
    required this.venueName,
    required this.scheduledAt,
    required this.format,
    required this.status,
    required this.ourFirstCentrePass,
    required this.createdAt,
    this.competitionId,
    this.venueId,
    this.homeTeamName = 'OUR TEAM', // Default for now
    this.isSuperShot = false,
    this.homeScore,
    this.awayScore,
  });
  final int id;
  final String homeTeamName;
  final String opponentName;
  final String competitionName;
  final String venueName;
  final int? competitionId;
  final int? venueId;
  final DateTime scheduledAt;
  final GameFormat format;
  final GameStatus status;
  final bool ourFirstCentrePass;
  final bool isSuperShot;
  final int? homeScore;
  final int? awayScore;
  final DateTime createdAt;

  @override
  List<Object?> get props => [
    id,
    homeTeamName,
    opponentName,
    competitionName,
    venueName,
    competitionId,
    venueId,
    scheduledAt,
    format,
    status,
    ourFirstCentrePass,
    isSuperShot,
    homeScore,
    awayScore,
    createdAt,
  ];

  Game copyWith({
    int? id,
    String? homeTeamName,
    String? opponentName,
    String? competitionName,
    String? venueName,
    int? competitionId,
    int? venueId,
    DateTime? scheduledAt,
    GameFormat? format,
    GameStatus? status,
    bool? ourFirstCentrePass,
    bool? isSuperShot,
    int? homeScore,
    int? awayScore,
    DateTime? createdAt,
  }) {
    return Game(
      id: id ?? this.id,
      homeTeamName: homeTeamName ?? this.homeTeamName,
      opponentName: opponentName ?? this.opponentName,
      competitionName: competitionName ?? this.competitionName,
      venueName: venueName ?? this.venueName,
      competitionId: competitionId ?? this.competitionId,
      venueId: venueId ?? this.venueId,
      scheduledAt: scheduledAt ?? this.scheduledAt,
      format: format ?? this.format,
      status: status ?? this.status,
      ourFirstCentrePass: ourFirstCentrePass ?? this.ourFirstCentrePass,
      isSuperShot: isSuperShot ?? this.isSuperShot,
      homeScore: homeScore ?? this.homeScore,
      awayScore: awayScore ?? this.awayScore,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class MatchLineup extends Equatable {
  // Maps position to player.id

  const MatchLineup({
    required this.id,
    required this.gameId,
    required this.positionToPlayerId,
  });
  final int id;
  final int gameId;
  final Map<NetballPosition, int> positionToPlayerId;

  @override
  List<Object?> get props => [id, gameId, positionToPlayerId];
}
