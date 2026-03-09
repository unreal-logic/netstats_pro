import 'package:drift/drift.dart';
import 'package:netstats_pro/data/database/tables/games.dart';
import 'package:netstats_pro/data/database/tables/players.dart';

class MatchEvents extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get gameId => integer().references(Games, #id)();
  IntColumn get quarter => integer()();
  IntColumn get matchTimeSeconds => integer()(); // Duration in seconds
  DateTimeColumn get timestamp => dateTime()();

  // Stored as enum name
  TextColumn get type => text()();

  IntColumn get playerId => integer().nullable().references(Players, #id)();
  TextColumn get position => text().nullable()();

  BoolColumn get isSpecialScoring =>
      boolean().withDefault(const Constant(false))();
  BoolColumn get isHomeTeam => boolean().withDefault(const Constant(true))();
}
