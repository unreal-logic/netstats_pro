import 'package:drift/drift.dart';

class Teams extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 100)();
  TextColumn get colorHex =>
      text().withLength(min: 6, max: 9).nullable()(); // #AARRGGBB

  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}
