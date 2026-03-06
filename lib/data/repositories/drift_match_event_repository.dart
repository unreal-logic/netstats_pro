import 'package:drift/drift.dart';
import 'package:netstats_pro/data/database/app_database.dart' as db;
import 'package:netstats_pro/domain/entities/match_event.dart' as entity;
import 'package:netstats_pro/domain/repositories/match_event_repository.dart';

class DriftMatchEventRepository implements MatchEventRepository {
  DriftMatchEventRepository(this.database);
  final db.AppDatabase database;

  @override
  Future<List<entity.MatchEvent>> getEventsForGame(int gameId) async {
    final query = database.select(database.matchEvents)
      ..where((t) => t.gameId.equals(gameId))
      ..orderBy([(t) => OrderingTerm(expression: t.timestamp)]);

    final rows = await query.get();
    return rows.map(_mapToEntity).toList();
  }

  @override
  Future<void> saveEvent(entity.MatchEvent event) async {
    await database
        .into(database.matchEvents)
        .insert(
          db.MatchEventsCompanion.insert(
            gameId: event.gameId,
            quarter: event.quarter,
            matchTimeSeconds: event.matchTime.inSeconds,
            timestamp: event.timestamp,
            type: event.type.name,
            playerId: Value(event.playerId),
            position: Value(event.position),
            isPowerPlay: Value(event.isPowerPlay),
            isHomeTeam: Value(event.isHomeTeam),
          ),
        );
  }

  @override
  Future<void> deleteEvent(int eventId) async {
    await (database.delete(
      database.matchEvents,
    )..where((t) => t.id.equals(eventId))).go();
  }

  @override
  Future<void> clearEventsForGame(int gameId) async {
    await (database.delete(
      database.matchEvents,
    )..where((t) => t.gameId.equals(gameId))).go();
  }

  entity.MatchEvent _mapToEntity(db.MatchEvent data) {
    return entity.MatchEvent(
      id: data.id,
      gameId: data.gameId,
      quarter: data.quarter,
      matchTime: Duration(seconds: data.matchTimeSeconds),
      timestamp: data.timestamp,
      type: entity.MatchEventType.values.firstWhere((e) => e.name == data.type),
      playerId: data.playerId,
      position: data.position,
      isPowerPlay: data.isPowerPlay,
      isHomeTeam: data.isHomeTeam,
    );
  }
}
