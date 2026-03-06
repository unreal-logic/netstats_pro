import 'package:equatable/equatable.dart';
import 'package:netstats_pro/domain/entities/game.dart';
import 'package:netstats_pro/domain/entities/match_event.dart';
import 'package:netstats_pro/domain/entities/player.dart';
import 'package:netstats_pro/domain/repositories/game_repository.dart';
import 'package:netstats_pro/domain/repositories/match_event_repository.dart';
import 'package:netstats_pro/domain/repositories/player_repository.dart';

class GetMatchSummaryUseCase {
  GetMatchSummaryUseCase({
    required this.gameRepository,
    required this.matchEventRepository,
    required this.playerRepository,
  });

  final GameRepository gameRepository;
  final MatchEventRepository matchEventRepository;
  final PlayerRepository playerRepository;

  Future<MatchSummaryData> call(int gameId) async {
    final game = await gameRepository.getGameById(gameId);
    if (game == null) throw Exception('Game not found');

    final events = await matchEventRepository.getEventsForGame(gameId);
    final matchLineup = await gameRepository.getLineupForGame(gameId);

    final homeLineup = <NetballPosition, Player>{};
    if (matchLineup != null) {
      for (final entry in matchLineup.positionToPlayerId.entries) {
        final player = await playerRepository.getPlayerById(entry.value);
        if (player != null) {
          homeLineup[entry.key] = player;
        }
      }
    }

    // Aggregations
    var homeGoals = 0;
    var homeMisses = 0;
    var homeIntercepts = 0;
    var homeTurnovers = 0;
    var homeRebounds = 0;

    var awayGoals = 0;
    var awayMisses = 0;
    var awayIntercepts = 0;
    var awayTurnovers = 0;
    var awayRebounds = 0;

    for (final event in events) {
      if (event.isHomeTeam) {
        if (event.type.name.contains('goal')) homeGoals++;
        if (event.type == MatchEventType.miss) homeMisses++;
        if (event.type == MatchEventType.intercept) homeIntercepts++;
        if (event.type == MatchEventType.turnover) homeTurnovers++;
        if (event.type == MatchEventType.offensiveRebound ||
            event.type == MatchEventType.defensiveRebound) {
          homeRebounds++;
        }
      } else {
        if (event.type.name.contains('goal')) awayGoals++;
        if (event.type == MatchEventType.miss) awayMisses++;
        if (event.type == MatchEventType.intercept) awayIntercepts++;
        if (event.type == MatchEventType.turnover) awayTurnovers++;
        if (event.type == MatchEventType.offensiveRebound ||
            event.type == MatchEventType.defensiveRebound) {
          awayRebounds++;
        }
      }
    }

    final homeShootingPercentage = (homeGoals + homeMisses) > 0
        ? (homeGoals / (homeGoals + homeMisses)) * 100
        : 0.0;

    final awayShootingPercentage = (awayGoals + awayMisses) > 0
        ? (awayGoals / (awayGoals + awayMisses)) * 100
        : 0.0;

    return MatchSummaryData(
      game: game,
      events: events,
      homeLineup: homeLineup,
      homeStats: TeamMatchStats(
        goals: homeGoals,
        misses: homeMisses,
        shootingPercentage: homeShootingPercentage,
        intercepts: homeIntercepts,
        turnovers: homeTurnovers,
        rebounds: homeRebounds,
      ),
      awayStats: TeamMatchStats(
        goals: awayGoals,
        misses: awayMisses,
        shootingPercentage: awayShootingPercentage,
        intercepts: awayIntercepts,
        turnovers: awayTurnovers,
        rebounds: awayRebounds,
      ),
    );
  }
}

class TeamMatchStats extends Equatable {
  const TeamMatchStats({
    required this.goals,
    required this.misses,
    required this.shootingPercentage,
    required this.intercepts,
    required this.turnovers,
    required this.rebounds,
  });

  final int goals;
  final int misses;
  final double shootingPercentage;
  final int intercepts;
  final int turnovers;
  final int rebounds;

  @override
  List<Object?> get props => [
    goals,
    misses,
    shootingPercentage,
    intercepts,
    turnovers,
    rebounds,
  ];
}

class MatchSummaryData extends Equatable {
  const MatchSummaryData({
    required this.game,
    required this.events,
    required this.homeLineup,
    required this.homeStats,
    required this.awayStats,
  });

  final Game game;
  final List<MatchEvent> events;
  final Map<NetballPosition, Player> homeLineup;
  final TeamMatchStats homeStats;
  final TeamMatchStats awayStats;

  @override
  List<Object?> get props => [
    game,
    events,
    homeLineup,
    homeStats,
    awayStats,
  ];
}
