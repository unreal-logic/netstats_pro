import 'package:drift/drift.dart';
import 'package:netstats_pro/data/database/app_database.dart' as db;
import 'package:netstats_pro/domain/entities/player.dart';
import 'package:netstats_pro/domain/repositories/player_repository.dart';

class DriftPlayerRepository implements PlayerRepository {
  DriftPlayerRepository(this._database);
  final db.AppDatabase _database;

  @override
  Future<List<Player>> getAllPlayers() async {
    final players = await _database.select(_database.players).get();
    return players.map(_mapToEntity).toList();
  }

  @override
  Stream<List<Player>> watchAllPlayers() {
    return _database
        .select(_database.players)
        .watch()
        .map((rows) => rows.map(_mapToEntity).toList());
  }

  @override
  Future<Player?> getPlayerById(int id) async {
    final query = _database.select(_database.players)
      ..where((t) => t.id.equals(id));
    final player = await query.getSingleOrNull();
    return player != null ? _mapToEntity(player) : null;
  }

  @override
  Future<int> createPlayer(Player player) {
    return _database
        .into(_database.players)
        .insert(
          _mapToCompanion(player),
        );
  }

  @override
  Future<bool> updatePlayer(Player player) {
    return _database
        .update(_database.players)
        .replace(
          _mapToDataClass(player),
        );
  }

  @override
  Future<int> deletePlayer(int id) {
    return (_database.delete(
      _database.players,
    )..where((t) => t.id.equals(id))).go();
  }

  Player _mapToEntity(db.Player data) {
    return Player(
      id: data.id,
      firstName: data.firstName,
      lastName: data.lastName,
      nickname: data.nickname,
      primaryNumber: data.primaryNumber,
      teamId: data.teamId,
      preferredPositions: data.preferredPositions
          .split(',')
          .where((s) => s.isNotEmpty)
          .map((s) => NetballPosition.values.byName(s))
          .toList(),
      createdAt: data.createdAt,
    );
  }

  db.PlayersCompanion _mapToCompanion(Player entity) {
    return db.PlayersCompanion.insert(
      firstName: entity.firstName,
      lastName: entity.lastName,
      nickname: Value(entity.nickname),
      primaryNumber: Value(entity.primaryNumber),
      teamId: Value(entity.teamId),
      preferredPositions: entity.preferredPositions
          .map((e) => e.name)
          .join(','),
    );
  }

  db.Player _mapToDataClass(Player entity) {
    return db.Player(
      id: entity.id,
      firstName: entity.firstName,
      lastName: entity.lastName,
      nickname: entity.nickname,
      primaryNumber: entity.primaryNumber,
      teamId: entity.teamId,
      preferredPositions: entity.preferredPositions
          .map((e) => e.name)
          .join(','),
      createdAt: entity.createdAt,
    );
  }
}
