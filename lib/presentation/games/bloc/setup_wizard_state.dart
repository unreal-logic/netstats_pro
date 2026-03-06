import 'package:equatable/equatable.dart';
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
    this.lineup = const {},
    this.ourFirstCentrePass = true,
    this.isSuperShot = false,
    this.errorMessage,
    this.createdGameId,
  }) : scheduledAt = scheduledAt ?? _initialDate;
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

  // Step 2: Lineup
  final Map<NetballPosition, Player?> lineup;

  // Step 3: Settings
  final bool ourFirstCentrePass;
  final bool isSuperShot;

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
    Map<NetballPosition, Player?>? lineup,
    bool? ourFirstCentrePass,
    bool? isSuperShot,
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
      lineup: lineup ?? this.lineup,
      ourFirstCentrePass: ourFirstCentrePass ?? this.ourFirstCentrePass,
      isSuperShot: isSuperShot ?? this.isSuperShot,
      errorMessage: errorMessage ?? this.errorMessage,
      createdGameId: createdGameId ?? this.createdGameId,
    );
  }

  bool get isMatchInfoValid => competitionId != null && venueId != null;

  bool get isTeamsValid => opponentName.isNotEmpty && homeTeamName.isNotEmpty;

  bool get isLineupValid {
    final requiredPositions = format.positions;
    return requiredPositions.every((pos) => lineup[pos] != null);
  }

  bool get isAllValid => isMatchInfoValid && isTeamsValid && isLineupValid;

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
    lineup,
    ourFirstCentrePass,
    isSuperShot,
    errorMessage,
    createdGameId,
  ];
}
