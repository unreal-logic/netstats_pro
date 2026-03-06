import 'package:drift/drift.dart';
import 'package:netstats_pro/data/database/tables/teams.dart';

class Players extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get firstName => text().withLength(min: 1, max: 50)();
  TextColumn get lastName => text().withLength(min: 1, max: 50)();
  TextColumn get nickname => text().nullable()();
  IntColumn get primaryNumber => integer().nullable()();
  IntColumn get teamId => integer().nullable().references(Teams, #id)();

  // Stored as a comma-separated string or bitmask, but for simplicity
  // we'll use a text column for now or a custom converter.
  // For initial scaffold, just text.
  TextColumn get preferredPositions => text()();

  DateTimeColumn get dob => dateTime().nullable()();
  IntColumn get heightCm => integer().nullable()();

  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}
