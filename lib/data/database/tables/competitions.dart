import 'package:drift/drift.dart';

class Competitions extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 255)();
  IntColumn get seasonYear => integer().nullable()();
  IntColumn get pointsWin => integer().withDefault(const Constant(4))();
  IntColumn get pointsDraw => integer().withDefault(const Constant(2))();
  IntColumn get pointsLoss => integer().withDefault(const Constant(0))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().nullable()();
}
