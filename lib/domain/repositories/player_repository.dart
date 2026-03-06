import 'package:netstats_pro/domain/entities/player.dart';

abstract class PlayerRepository {
  Future<List<Player>> getAllPlayers();
  Stream<List<Player>> watchAllPlayers();
  Future<Player?> getPlayerById(int id);
  Future<int> createPlayer(Player player);
  Future<bool> updatePlayer(Player player);
  Future<int> deletePlayer(int id);
}
