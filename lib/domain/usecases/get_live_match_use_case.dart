import 'package:netstats_pro/domain/entities/game.dart';
import 'package:netstats_pro/domain/entities/match_event.dart';
import 'package:netstats_pro/domain/entities/player.dart';
import 'package:netstats_pro/domain/repositories/game_repository.dart';
import 'package:netstats_pro/domain/repositories/match_event_repository.dart';
import 'package:netstats_pro/domain/repositories/player_repository.dart';

class GetLiveMatchUseCase {
  GetLiveMatchUseCase({
    required this.gameRepository,
    required this.matchEventRepository,
    required this.playerRepository,
  });

  final GameRepository gameRepository;
  final MatchEventRepository matchEventRepository;
  final PlayerRepository playerRepository;

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

    return LiveMatchData(
      game: game,
      events: events,
      homeLineup: homeLineup,
    );
  }
}

class LiveMatchData {
  const LiveMatchData({
    required this.game,
    required this.events,
    required this.homeLineup,
  });

  final Game game;
  final List<MatchEvent> events;
  final Map<NetballPosition, Player> homeLineup;
}
