import 'package:netstats_pro/domain/entities/game.dart';
import 'package:netstats_pro/domain/entities/match_event.dart';
import 'package:netstats_pro/domain/entities/player.dart';
import 'package:netstats_pro/domain/repositories/game_repository.dart';
import 'package:netstats_pro/domain/repositories/match_event_repository.dart';
import 'package:netstats_pro/domain/repositories/player_repository.dart';
import 'package:netstats_pro/domain/repositories/team_repository.dart';

class GetLiveMatchUseCase {
  GetLiveMatchUseCase({
    required this.gameRepository,
    required this.matchEventRepository,
    required this.playerRepository,
    required this.teamRepository,
  });

  final GameRepository gameRepository;
  final MatchEventRepository matchEventRepository;
  final PlayerRepository playerRepository;
  final TeamRepository teamRepository;

  Future<LiveMatchData> call(int gameId) async {
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

    final homeTeam = game.homeTeamId != null
        ? await teamRepository.getTeamById(game.homeTeamId!)
        : null;
    final opponentTeam = game.opponentTeamId != null
        ? await teamRepository.getTeamById(game.opponentTeamId!)
        : null;

    return LiveMatchData(
      game: game,
      events: events,
      homeLineup: homeLineup,
      homeTeamColor: homeTeam?.color != null
          ? '#${homeTeam!.color!.toARGB32().toRadixString(16).padLeft(8, '0')}'
          : null,
      opponentTeamColor: opponentTeam?.color != null
          ? '#${opponentTeam!.color!.toARGB32().toRadixString(16).padLeft(8, '0')}'
          : null,
    );
  }
}

class LiveMatchData {
  const LiveMatchData({
    required this.game,
    required this.events,
    required this.homeLineup,
    this.homeTeamColor,
    this.opponentTeamColor,
  });

  final Game game;
  final List<MatchEvent> events;
  final Map<NetballPosition, Player> homeLineup;
  final String? homeTeamColor;
  final String? opponentTeamColor;
}
