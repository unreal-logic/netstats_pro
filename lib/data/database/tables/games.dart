import 'package:drift/drift.dart';

@DataClassName('GameEntry')
class Games extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get homeTeamName => text()
      .withLength(min: 1, max: 100)
      .withDefault(const Constant('OUR TEAM'))();
  TextColumn get opponentName => text().withLength(min: 1, max: 100)();
  TextColumn get competitionName => text().withLength(min: 1, max: 100)();
  TextColumn get venueName => text().withLength(min: 1, max: 100)();
  DateTimeColumn get scheduledAt => dateTime()();

  IntColumn get competitionId => integer().nullable()();
  IntColumn get venueId => integer().nullable()();

  // Stored as enum name
  TextColumn get format => text()();
  TextColumn get status => text()();
  TextColumn get trackingMode =>
      text().withDefault(const Constant('fullStatistics'))();

  BoolColumn get ourFirstCentrePass =>
      boolean().withDefault(const Constant(true))();

  BoolColumn get isSuperShot => boolean().withDefault(const Constant(false))();

  IntColumn get homeScore => integer().nullable()();
  IntColumn get awayScore => integer().nullable()();
  IntColumn get quarterDurationMinutes =>
      integer().withDefault(const Constant(15))();

  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}
