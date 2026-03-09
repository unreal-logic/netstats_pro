import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:netstats_pro/domain/entities/competition.dart';
import 'package:netstats_pro/domain/entities/game.dart';
import 'package:netstats_pro/domain/entities/player.dart';
import 'package:netstats_pro/domain/entities/team.dart';
import 'package:netstats_pro/domain/entities/venue.dart';

enum SetupWizardStatus { initial, loading, success, failure }

class SetupWizardState extends Equatable {
  SetupWizardState({
    this.status = SetupWizardStatus.initial,
    this.currentStep = 0,
    this.opponentName = '',
    this.opponentTeamId,
    this.homeTeamName = '',
    this.homeTeamId,
    this.competitionId,
    this.venueId,
    this.competitions = const [],
    this.venues = const [],
    this.teams = const [],
    DateTime? scheduledAt,
    this.format = GameFormat.sevenAside,
    this.trackingMode = TrackingMode.fullStatistics,
    this.trackBothTeams = false,
    this.lineup = const {},
    this.opponentLineup = const {},
    int? quarterDurationMinutes,
    this.ourFirstCentrePass = true,
    this.isSuperShot = false,
    this.fast5PowerPlayMode = Fast5PowerPlayMode.contested,
    this.homePowerPlayQuarter,
    this.awayPowerPlayQuarter,
    this.errorMessage,
    this.createdGameId,
  }) : scheduledAt = scheduledAt ?? _initialDate,
       quarterDurationMinutes =
           quarterDurationMinutes ?? format.defaultQuarterMinutes;
  final SetupWizardStatus status;
  final int currentStep;

  // Step 1: Match Details
  final String opponentName;
  final int? opponentTeamId;
  final String homeTeamName;
  final int? homeTeamId;
  final int? competitionId;
  final int? venueId;
  final List<Competition> competitions;
  final List<Venue> venues;
  final List<Team> teams;
  final DateTime scheduledAt;
  final GameFormat format;
  final TrackingMode trackingMode;

  // Step 2: Teams
  final bool trackBothTeams;

  // Step 2: Lineup
  final Map<NetballPosition, Player?> lineup;
  final Map<NetballPosition, Player?> opponentLineup;

  // Step 3: Settings
  final bool ourFirstCentrePass;
  final bool isSuperShot;
  final Fast5PowerPlayMode fast5PowerPlayMode;
  final int? homePowerPlayQuarter;
  final int? awayPowerPlayQuarter;
  final int quarterDurationMinutes;

  final String? errorMessage;
  final int? createdGameId;

  static DateTime get _initialDate {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day, now.hour);
  }

  SetupWizardState copyWith({
    SetupWizardStatus? status,
    int? currentStep,
    String? opponentName,
    int? opponentTeamId,
    String? homeTeamName,
    int? homeTeamId,
    int? competitionId,
    int? venueId,
    List<Competition>? competitions,
    List<Venue>? venues,
    List<Team>? teams,
    DateTime? scheduledAt,
    GameFormat? format,
    TrackingMode? trackingMode,
    bool? trackBothTeams,
    Map<NetballPosition, Player?>? lineup,
    Map<NetballPosition, Player?>? opponentLineup,
    bool? ourFirstCentrePass,
    bool? isSuperShot,
    Fast5PowerPlayMode? fast5PowerPlayMode,
    int? homePowerPlayQuarter,
    int? awayPowerPlayQuarter,
    bool clearHomePowerPlayQuarter = false,
    bool clearAwayPowerPlayQuarter = false,
    int? quarterDurationMinutes,
    String? errorMessage,
    int? createdGameId,
  }) {
    return SetupWizardState(
      status: status ?? this.status,
      currentStep: currentStep ?? this.currentStep,
      opponentName: opponentName ?? this.opponentName,
      opponentTeamId: opponentTeamId ?? this.opponentTeamId,
      homeTeamName: homeTeamName ?? this.homeTeamName,
      homeTeamId: homeTeamId ?? this.homeTeamId,
      competitionId: competitionId ?? this.competitionId,
      venueId: venueId ?? this.venueId,
      competitions: competitions ?? this.competitions,
      venues: venues ?? this.venues,
      teams: teams ?? this.teams,
      scheduledAt: scheduledAt ?? this.scheduledAt,
      format: format ?? this.format,
      trackingMode: trackingMode ?? this.trackingMode,
      trackBothTeams: trackBothTeams ?? this.trackBothTeams,
      lineup: lineup ?? this.lineup,
      opponentLineup: opponentLineup ?? this.opponentLineup,
      ourFirstCentrePass: ourFirstCentrePass ?? this.ourFirstCentrePass,
      isSuperShot: isSuperShot ?? this.isSuperShot,
      fast5PowerPlayMode: fast5PowerPlayMode ?? this.fast5PowerPlayMode,
      homePowerPlayQuarter: clearHomePowerPlayQuarter
          ? null
          : (homePowerPlayQuarter ?? this.homePowerPlayQuarter),
      awayPowerPlayQuarter: clearAwayPowerPlayQuarter
          ? null
          : (awayPowerPlayQuarter ?? this.awayPowerPlayQuarter),
      quarterDurationMinutes:
          quarterDurationMinutes ?? this.quarterDurationMinutes,
      errorMessage: errorMessage ?? this.errorMessage,
      createdGameId: createdGameId ?? this.createdGameId,
    );
  }

  bool get isMatchInfoValid => competitionId != null;

  bool get isTeamsValid => opponentName.isNotEmpty && homeTeamName.isNotEmpty;

  bool get isLineupValid {
    if (trackingMode == TrackingMode.scoreOnly) return true;
    final requiredPositions = format.positions;
    final homeOk = requiredPositions.every((pos) => lineup[pos] != null);
    if (!trackBothTeams) return homeOk;
    final opponentOk = requiredPositions.every(
      (pos) => opponentLineup[pos] != null,
    );
    return homeOk && opponentOk;
  }

  bool get isAllValid {
    if (trackingMode == TrackingMode.scoreOnly) {
      return isMatchInfoValid && isTeamsValid;
    }
    return isMatchInfoValid && isTeamsValid && isLineupValid;
  }

  Color? get homeTeamColor =>
      teams.where((t) => t.id == homeTeamId).firstOrNull?.color;
  Color? get opponentTeamColor =>
      teams.where((t) => t.id == opponentTeamId).firstOrNull?.color;

  String? get homeTeamAvatar =>
      teams.where((t) => t.id == homeTeamId).firstOrNull?.avatarUrl;
  String? get opponentTeamAvatar =>
      teams.where((t) => t.id == opponentTeamId).firstOrNull?.avatarUrl;

  @override
  List<Object?> get props => [
    status,
    currentStep,
    opponentName,
    opponentTeamId,
    homeTeamName,
    homeTeamId,
    competitionId,
    venueId,
    competitions,
    venues,
    teams,
    scheduledAt,
    format,
    trackingMode,
    trackBothTeams,
    lineup,
    opponentLineup,
    ourFirstCentrePass,
    isSuperShot,
    fast5PowerPlayMode,
    homePowerPlayQuarter,
    awayPowerPlayQuarter,
    quarterDurationMinutes,
    errorMessage,
    createdGameId,
  ];
}
