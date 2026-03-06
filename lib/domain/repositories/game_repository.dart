import 'package:netstats_pro/domain/entities/game.dart';

abstract class GameRepository {
  Future<int> createGame(Game game);
  Future<void> updateGame(Game game);
  Future<Game?> getGameById(int id);
  Stream<List<Game>> watchAllGames();

  Future<int> saveLineup(MatchLineup lineup);
  Future<MatchLineup?> getLineupForGame(int gameId);
}
