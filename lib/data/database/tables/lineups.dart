import 'package:drift/drift.dart';
import 'package:netstats_pro/data/database/tables/games.dart';

@DataClassName('LineupEntry')
class Lineups extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get gameId => integer().references(Games, #id)();

  // Stored as a JSON string: {"GS": 1, "GA": 2, ...}
  // Maps position enum name to player id
  TextColumn get positionMapping => text()();

  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}
