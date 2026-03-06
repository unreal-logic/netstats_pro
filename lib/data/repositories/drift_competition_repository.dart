import 'package:drift/drift.dart' as drift;
import 'package:netstats_pro/data/database/app_database.dart' as db;
import 'package:netstats_pro/domain/entities/competition.dart';
import 'package:netstats_pro/domain/repositories/competition_repository.dart';

class DriftCompetitionRepository implements CompetitionRepository {
  DriftCompetitionRepository(this._database);
  final db.AppDatabase _database;

  @override
  Future<List<Competition>> getCompetitions() async {
    final comps = await _database.select(_database.competitions).get();
    return comps.map(_mapToDomain).toList();
  }

  @override
  Stream<List<Competition>> watchCompetitions() {
    return _database
        .select(_database.competitions)
        .watch()
        .map((rows) => rows.map(_mapToDomain).toList());
  }

  @override
  Future<Competition?> getCompetitionById(int id) async {
    final query = _database.select(_database.competitions)
      ..where((c) => c.id.equals(id));
    final comp = await query.getSingleOrNull();
    if (comp == null) return null;
    return _mapToDomain(comp);
  }

  @override
  Future<void> saveCompetition(Competition competition) async {
    final companion = db.CompetitionsCompanion(
      name: drift.Value(competition.name),
      seasonYear: drift.Value(competition.seasonYear),
      pointsWin: drift.Value(competition.pointsWin),
      pointsDraw: drift.Value(competition.pointsDraw),
      pointsLoss: drift.Value(competition.pointsLoss),
      updatedAt: drift.Value(DateTime.now()),
    );

    if (competition.id > 0) {
      await (_database.update(
        _database.competitions,
      )..where((c) => c.id.equals(competition.id))).write(companion);
    } else {
      await _database.into(_database.competitions).insert(companion);
    }
  }

  @override
  Future<void> deleteCompetition(int id) async {
    await (_database.delete(
      _database.competitions,
    )..where((c) => c.id.equals(id))).go();
  }

  Competition _mapToDomain(db.Competition data) {
    return Competition(
      id: data.id,
      name: data.name,
      seasonYear: data.seasonYear,
      pointsWin: data.pointsWin,
      pointsDraw: data.pointsDraw,
      pointsLoss: data.pointsLoss,
      createdAt: data.createdAt,
      updatedAt: data.updatedAt,
    );
  }
}
