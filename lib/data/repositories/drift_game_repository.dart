import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:netstats_pro/data/database/app_database.dart';
import 'package:netstats_pro/domain/entities/game.dart';
import 'package:netstats_pro/domain/entities/player.dart';
import 'package:netstats_pro/domain/repositories/game_repository.dart';

class DriftGameRepository implements GameRepository {
  DriftGameRepository(this._db);
  final AppDatabase _db;

  @override
  Future<int> createGame(Game game) {
    return _db
        .into(_db.games)
        .insert(
          GamesCompanion.insert(
            opponentName: game.opponentName,
            competitionName: game.competitionName,
            venueName: game.venueName,
            competitionId: Value(game.competitionId),
            venueId: Value(game.venueId),
            scheduledAt: game.scheduledAt,
            format: game.format.name,
            status: game.status.name,
            trackingMode: Value(game.trackingMode.name),
            homeTeamName: Value(game.homeTeamName),
            ourFirstCentrePass: Value(game.ourFirstCentrePass),
            quarterDurationMinutes: Value(game.quarterDurationMinutes),
            isSuperShot: Value(game.isSuperShot),
            fast5PowerPlayMode: Value(game.fast5PowerPlayMode.name),
            homePowerPlayQuarter: Value(game.homePowerPlayQuarter),
            awayPowerPlayQuarter: Value(game.awayPowerPlayQuarter),
            homeTeamId: Value(game.homeTeamId),
            opponentTeamId: Value(game.opponentTeamId),
            totalQuarters: Value(game.totalQuarters),
          ),
        );
  }

  @override
  Future<void> updateGame(Game game) {
    return (_db.update(_db.games)..where((t) => t.id.equals(game.id))).write(
      GamesCompanion(
        opponentName: Value(game.opponentName),
        competitionName: Value(game.competitionName),
        venueName: Value(game.venueName),
        competitionId: Value(game.competitionId),
        venueId: Value(game.venueId),
        scheduledAt: Value(game.scheduledAt),
        status: Value(game.status.name),
        homeScore: Value(game.homeScore),
        awayScore: Value(game.awayScore),
        homeTeamId: Value(game.homeTeamId),
        opponentTeamId: Value(game.opponentTeamId),
        isSuperShot: Value(game.isSuperShot),
        fast5PowerPlayMode: Value(game.fast5PowerPlayMode.name),
        homePowerPlayQuarter: Value(game.homePowerPlayQuarter),
        awayPowerPlayQuarter: Value(game.awayPowerPlayQuarter),
        totalQuarters: Value(game.totalQuarters),
      ),
    );
  }

  @override
  Future<Game?> getGameById(int id) async {
    final result = await (_db.select(
      _db.games,
    )..where((t) => t.id.equals(id))).getSingleOrNull();
    if (result == null) return null;
    return _mapToEntity(result);
  }

  @override
  Stream<List<Game>> watchAllGames() {
    return _db
        .select(_db.games)
        .watch()
        .map(
          (rows) => rows.map(_mapToEntity).toList(),
        );
  }

  @override
  Future<int> saveLineup(MatchLineup lineup) {
    final mappingJson = jsonEncode(
      lineup.positionToPlayerId.map((k, v) => MapEntry(k.name, v)),
    );

    return _db
        .into(_db.lineups)
        .insert(
          LineupsCompanion.insert(
            gameId: lineup.gameId,
            positionMapping: mappingJson,
          ),
        );
  }

  @override
  Future<MatchLineup?> getLineupForGame(int gameId) async {
    final result = await (_db.select(
      _db.lineups,
    )..where((t) => t.gameId.equals(gameId))).getSingleOrNull();

    if (result == null) return null;

    final json = jsonDecode(result.positionMapping) as Map<String, dynamic>;
    final mapping = json.map(
      (key, value) => MapEntry(
        NetballPosition.values.firstWhere((e) => e.name == key),
        value as int,
      ),
    );

    return MatchLineup(
      id: result.id,
      gameId: result.gameId,
      positionToPlayerId: mapping,
    );
  }

  Game _mapToEntity(GameEntry row) {
    return Game(
      id: row.id,
      opponentName: row.opponentName,
      competitionName: row.competitionName,
      venueName: row.venueName,
      competitionId: row.competitionId,
      venueId: row.venueId,
      scheduledAt: row.scheduledAt,
      format: GameFormat.values.firstWhere((e) => e.name == row.format),
      status: GameStatus.values.firstWhere((e) => e.name == row.status),
      trackingMode: TrackingMode.values.firstWhere(
        (e) => e.name == row.trackingMode,
      ),
      homeTeamName: row.homeTeamName,
      ourFirstCentrePass: row.ourFirstCentrePass,
      isSuperShot: row.isSuperShot,
      fast5PowerPlayMode: Fast5PowerPlayMode.values.firstWhere(
        (e) => e.name == row.fast5PowerPlayMode,
        orElse: () => Fast5PowerPlayMode.contested,
      ),
      homePowerPlayQuarter: row.homePowerPlayQuarter,
      awayPowerPlayQuarter: row.awayPowerPlayQuarter,
      quarterDurationMinutes: row.quarterDurationMinutes,
      homeScore: row.homeScore,
      awayScore: row.awayScore,
      homeTeamId: row.homeTeamId,
      opponentTeamId: row.opponentTeamId,
      totalQuarters: row.totalQuarters,
      createdAt: row.createdAt,
    );
  }
}
