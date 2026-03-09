import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:netstats_pro/data/database/tables/competitions.dart';
import 'package:netstats_pro/data/database/tables/games.dart';
import 'package:netstats_pro/data/database/tables/lineups.dart';
import 'package:netstats_pro/data/database/tables/match_events.dart';
import 'package:netstats_pro/data/database/tables/players.dart';
import 'package:netstats_pro/data/database/tables/teams.dart';
import 'package:netstats_pro/data/database/tables/venues.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [
    Players,
    Teams,
    Games,
    Lineups,
    MatchEvents,
    Competitions,
    Venues,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  static QueryExecutor _openConnection() {
    return driftDatabase(
      name: 'netstats_pro_db',
      native: const DriftNativeOptions(),
      web: DriftWebOptions(
        sqlite3Wasm: Uri.parse('sqlite3.wasm'),
        driftWorker: Uri.parse('drift_worker.js'),
      ),
    );
  }

  @override
  int get schemaVersion => 15;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (m) async {
        await m.createAll();
      },
      onUpgrade: (m, from, to) async {
        if (from < 2) {
          // Add missing tables from initial setup if they don't exist
          await m.createTable(games);
          await m.createTable(lineups);
          await m.createTable(teams);
        }
        if (from < 3) {
          // Add isSuperShot column to games table
          await m.addColumn(
            games,
            (games as dynamic).isSuperShot as GeneratedColumn<bool>,
          );
        }
        if (from < 4) {
          await m.createTable(matchEvents);
        }
        if (from < 5) {
          await m.addColumn(
            games,
            (games as dynamic).homeTeamName as GeneratedColumn<String>,
          );
        }
        if (from < 6) {
          await m.createTable(competitions);
          await m.createTable(venues);
          await m.addColumn(
            players,
            (players as dynamic).dob as GeneratedColumn<DateTime>,
          );
          await m.addColumn(
            players,
            (players as dynamic).heightCm as GeneratedColumn<int>,
          );
          await m.addColumn(
            games,
            (games as dynamic).competitionId as GeneratedColumn<int>,
          );
          await m.addColumn(
            games,
            (games as dynamic).venueId as GeneratedColumn<int>,
          );
        }
        if (from < 7) {
          try {
            await m.addColumn(
              players,
              (players as dynamic).teamId as GeneratedColumn<int>,
            );
          } on Exception catch (_) {
            // Already added or will be added by version 8 fallback
          }
        }
        if (from < 8) {
          try {
            // Raw SQL fallback to ensure the column exists
            await customStatement(
              'ALTER TABLE players ADD COLUMN team_id INTEGER;',
            );
          } on Exception catch (_) {
            // Column might already exist
          }
        }
        if (from < 9) {
          await m.addColumn(
            games,
            (games as dynamic).trackingMode as GeneratedColumn<String>,
          );
        }
        if (from < 11) {
          try {
            // Robust check/add for tracking_mode
            await customStatement(
              'ALTER TABLE games ADD COLUMN tracking_mode TEXT '
              'DEFAULT "fullStatistics";',
            );
          } on Exception catch (_) {
            // Column might already exist from a partial sync
          }
        }
        if (from < 12) {
          await m.addColumn(
            games,
            (games as dynamic).homeTeamId as GeneratedColumn<int>,
          );
          await m.addColumn(
            games,
            (games as dynamic).opponentTeamId as GeneratedColumn<int>,
          );
        }
        if (from < 13) {
          await m.addColumn(
            games,
            (games as dynamic).fast5PowerPlayMode as GeneratedColumn<String>,
          );
          await m.addColumn(
            games,
            (games as dynamic).homePowerPlayQuarter as GeneratedColumn<int>,
          );
          await m.addColumn(
            games,
            (games as dynamic).awayPowerPlayQuarter as GeneratedColumn<int>,
          );
        }
        if (from < 14) {
          await m.addColumn(
            games,
            (games as dynamic).totalQuarters as GeneratedColumn<int>,
          );
        }
      },
      beforeOpen: (details) async {
        // Seed default "Exhibition Match" competition if it doesn't exist
        final exhibitionMatch = await (select(
          competitions,
        )..where((c) => c.name.equals('Exhibition Match'))).getSingleOrNull();

        if (exhibitionMatch == null) {
          await into(competitions).insert(
            CompetitionsCompanion.insert(
              name: 'Exhibition Match',
              createdAt: Value(DateTime.now()),
            ),
          );
        }
      },
    );
  }
}
