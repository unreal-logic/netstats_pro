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
  ], 15),
  sixAside('6 aside', 6, [
    NetballPosition.a1,
    NetballPosition.a2,
    NetballPosition.l1,
    NetballPosition.l2,
    NetballPosition.d1,
    NetballPosition.d2,
  ], 10),
  fiveAside('5 aside', 5, [
    NetballPosition.gs,
    NetballPosition.ga,
    NetballPosition.c,
    NetballPosition.gd,
    NetballPosition.gk,
  ], 6)
  ;

  const GameFormat(
    this.displayName,
    this.playersPerSide,
    this.positions,
    this.defaultQuarterMinutes,
  );

  final String displayName;
  final int playersPerSide;
  final List<NetballPosition> positions;
  final int defaultQuarterMinutes;
}

enum TrackingMode {
  fullStatistics(
    'Full Statistics',
    'Capture every pass, turnover, and shot in detail.',
  ),
  scoreOnly('Score Only', 'Keep it simple and only track the match score.')
  ;

  const TrackingMode(this.displayName, this.description);
  final String displayName;
  final String description;
}

enum Fast5PowerPlayMode {
  contested(
    'Contested (Last 90s)',
    'Both teams receive double points in the final 90s of every quarter.',
  ),
  nominated(
    'Nominated (Team Choice)',
    'Each team selects one quarter for their Power Play (points doubled for entire quarter).',
  )
  ;

  const Fast5PowerPlayMode(this.displayName, this.description);
  final String displayName;
  final String description;
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
    this.trackingMode = TrackingMode.fullStatistics,
    this.quarterDurationMinutes = 15,
    this.totalQuarters = 4,
    this.competitionId,
    this.venueId,
    this.homeTeamId,
    this.opponentTeamId,
    this.homeTeamName = 'OUR TEAM', // Default for now
    this.isSuperShot = false,
    this.fast5PowerPlayMode = Fast5PowerPlayMode.contested,
    this.homePowerPlayQuarter,
    this.awayPowerPlayQuarter,
    this.homeScore,
    this.awayScore,
  });
  final int id;
  final int? homeTeamId;
  final int? opponentTeamId;
  final String homeTeamName;
  final String opponentName;
  final String competitionName;
  final String venueName;
  final int? competitionId;
  final int? venueId;
  final DateTime scheduledAt;
  final GameFormat format;
  final GameStatus status;
  final TrackingMode trackingMode;
  final bool ourFirstCentrePass;
  final bool isSuperShot;
  final Fast5PowerPlayMode fast5PowerPlayMode;
  final int? homePowerPlayQuarter;
  final int? awayPowerPlayQuarter;
  final int quarterDurationMinutes;
  final int totalQuarters;
  final int? homeScore;
  final int? awayScore;
  final DateTime createdAt;

  @override
  List<Object?> get props => [
    id,
    homeTeamId,
    opponentTeamId,
    homeTeamName,
    opponentName,
    competitionName,
    venueName,
    competitionId,
    venueId,
    scheduledAt,
    format,
    status,
    trackingMode,
    ourFirstCentrePass,
    isSuperShot,
    fast5PowerPlayMode,
    homePowerPlayQuarter,
    awayPowerPlayQuarter,
    quarterDurationMinutes,
    totalQuarters,
    homeScore,
    awayScore,
    createdAt,
  ];

  Game copyWith({
    int? id,
    int? homeTeamId,
    int? opponentTeamId,
    String? homeTeamName,
    String? opponentName,
    String? competitionName,
    String? venueName,
    int? competitionId,
    int? venueId,
    DateTime? scheduledAt,
    GameFormat? format,
    GameStatus? status,
    TrackingMode? trackingMode,
    bool? ourFirstCentrePass,
    bool? isSuperShot,
    Fast5PowerPlayMode? fast5PowerPlayMode,
    int? homePowerPlayQuarter,
    int? awayPowerPlayQuarter,
    int? quarterDurationMinutes,
    int? totalQuarters,
    int? homeScore,
    int? awayScore,
    DateTime? createdAt,
  }) {
    return Game(
      id: id ?? this.id,
      homeTeamId: homeTeamId ?? this.homeTeamId,
      opponentTeamId: opponentTeamId ?? this.opponentTeamId,
      homeTeamName: homeTeamName ?? this.homeTeamName,
      opponentName: opponentName ?? this.opponentName,
      competitionName: competitionName ?? this.competitionName,
      venueName: venueName ?? this.venueName,
      competitionId: competitionId ?? this.competitionId,
      venueId: venueId ?? this.venueId,
      scheduledAt: scheduledAt ?? this.scheduledAt,
      format: format ?? this.format,
      status: status ?? this.status,
      trackingMode: trackingMode ?? this.trackingMode,
      ourFirstCentrePass: ourFirstCentrePass ?? this.ourFirstCentrePass,
      isSuperShot: isSuperShot ?? this.isSuperShot,
      fast5PowerPlayMode: fast5PowerPlayMode ?? this.fast5PowerPlayMode,
      homePowerPlayQuarter: homePowerPlayQuarter ?? this.homePowerPlayQuarter,
      awayPowerPlayQuarter: awayPowerPlayQuarter ?? this.awayPowerPlayQuarter,
      quarterDurationMinutes:
          quarterDurationMinutes ?? this.quarterDurationMinutes,
      totalQuarters: totalQuarters ?? this.totalQuarters,
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
