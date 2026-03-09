import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:netstats_pro/domain/entities/game.dart';
import 'package:netstats_pro/domain/entities/match_event.dart';
import 'package:netstats_pro/domain/entities/player.dart';

enum LiveMatchStatus { initial, loading, active, finished, error }

class LiveMatchState extends Equatable {
  const LiveMatchState({
    this.status = LiveMatchStatus.initial,
    this.game,
    this.scoreHome = 0,
    this.scoreAway = 0,
    this.homeHasPossession = true,
    this.currentQuarter = 1,
    this.matchTime = Duration.zero,
    this.remainingTime = Duration.zero,
    this.isSpecialScoringActive = false,
    this.isTimerRunning = false,
    this.events = const [],
    this.errorMessage,
    this.homeLineup = const {},
    this.activePlayerId,
    this.activePlayerPosition,
    this.pendingStat,
    this.activeTeamId = 0,
    this.isErgonomicLayout = true,
    this.homeTeamColor,
    this.opponentTeamColor,
    this.isHomePowerPlayActive = false,
    this.isAwayPowerPlayActive = false,
    this.nextCenterPassIsHome = true,
    this.customQuarterDurations = const {},
  });
  final LiveMatchStatus status;
  final Game? game;
  final int scoreHome;
  final int scoreAway;
  final bool homeHasPossession;
  final int currentQuarter;
  final Duration matchTime;
  final bool isSpecialScoringActive;
  final bool isTimerRunning;
  final Duration remainingTime;
  final List<MatchEvent> events;
  final String? errorMessage;
  final Map<NetballPosition, Player> homeLineup;

  // New UI State for POC
  final int? activePlayerId;
  final String? activePlayerPosition;
  final MatchEventType? pendingStat;
  final int activeTeamId;
  final bool isErgonomicLayout;
  final Color? homeTeamColor;
  final Color? opponentTeamColor;
  final bool isHomePowerPlayActive;
  final bool isAwayPowerPlayActive;
  final bool nextCenterPassIsHome;
  final Map<int, Duration> customQuarterDurations;

  bool get isPlayerSelected =>
      activePlayerId != null && activePlayerPosition != null;

  bool get isHomeActive =>
      activePlayerId != null ? activePlayerId! <= 7 : activeTeamId == 0;

  @override
  List<Object?> get props => [
    status,
    game,
    scoreHome,
    scoreAway,
    homeHasPossession,
    currentQuarter,
    matchTime,
    isSpecialScoringActive,
    isTimerRunning,
    remainingTime,
    events,
    errorMessage,
    homeLineup,
    activePlayerId,
    activePlayerPosition,
    pendingStat,
    activeTeamId,
    isErgonomicLayout,
    homeTeamColor,
    opponentTeamColor,
    isHomePowerPlayActive,
    isAwayPowerPlayActive,
    nextCenterPassIsHome,
    customQuarterDurations,
  ];

  LiveMatchState copyWith({
    LiveMatchStatus? status,
    Game? game,
    int? scoreHome,
    int? scoreAway,
    bool? homeHasPossession,
    int? currentQuarter,
    Duration? matchTime,
    bool? isSpecialScoringActive,
    bool? isTimerRunning,
    Duration? remainingTime,
    List<MatchEvent>? events,
    String? errorMessage,
    Map<NetballPosition, Player>? homeLineup,
    int? activePlayerId,
    String? activePlayerPosition,
    MatchEventType? pendingStat,
    int? activeTeamId,
    bool? isErgonomicLayout,
    Color? homeTeamColor,
    Color? opponentTeamColor,
    bool? isHomePowerPlayActive,
    bool? isAwayPowerPlayActive,
    bool? nextCenterPassIsHome,
    Map<int, Duration>? customQuarterDurations,
    bool clearActivePlayer = false,
    bool clearPendingStat = false,
  }) {
    return LiveMatchState(
      status: status ?? this.status,
      game: game ?? this.game,
      scoreHome: scoreHome ?? this.scoreHome,
      scoreAway: scoreAway ?? this.scoreAway,
      homeHasPossession: homeHasPossession ?? this.homeHasPossession,
      currentQuarter: currentQuarter ?? this.currentQuarter,
      matchTime: matchTime ?? this.matchTime,
      isSpecialScoringActive:
          isSpecialScoringActive ?? this.isSpecialScoringActive,
      isTimerRunning: isTimerRunning ?? this.isTimerRunning,
      remainingTime: remainingTime ?? this.remainingTime,
      events: events ?? this.events,
      errorMessage: errorMessage ?? this.errorMessage,
      homeLineup: homeLineup ?? this.homeLineup,
      activePlayerId: clearActivePlayer
          ? null
          : (activePlayerId ?? this.activePlayerId),
      activePlayerPosition: clearActivePlayer
          ? null
          : (activePlayerPosition ?? this.activePlayerPosition),
      pendingStat: clearPendingStat ? null : (pendingStat ?? this.pendingStat),
      activeTeamId: activeTeamId ?? this.activeTeamId,
      isErgonomicLayout: isErgonomicLayout ?? this.isErgonomicLayout,
      homeTeamColor: homeTeamColor ?? this.homeTeamColor,
      opponentTeamColor: opponentTeamColor ?? this.opponentTeamColor,
      isHomePowerPlayActive:
          isHomePowerPlayActive ?? this.isHomePowerPlayActive,
      isAwayPowerPlayActive:
          isAwayPowerPlayActive ?? this.isAwayPowerPlayActive,
      nextCenterPassIsHome: nextCenterPassIsHome ?? this.nextCenterPassIsHome,
      customQuarterDurations:
          customQuarterDurations ?? this.customQuarterDurations,
    );
  }
}
