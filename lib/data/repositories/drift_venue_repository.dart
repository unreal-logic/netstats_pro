import 'package:drift/drift.dart' as drift;
import 'package:netstats_pro/data/database/app_database.dart' as db;
import 'package:netstats_pro/domain/entities/venue.dart';
import 'package:netstats_pro/domain/repositories/venue_repository.dart';

class DriftVenueRepository implements VenueRepository {
  DriftVenueRepository(this._database);
  final db.AppDatabase _database;

  @override
  Future<List<Venue>> getVenues() async {
    final venues = await _database.select(_database.venues).get();
    return venues.map(_mapToDomain).toList();
  }

  @override
  Stream<List<Venue>> watchVenues() {
    return _database
        .select(_database.venues)
        .watch()
        .map((rows) => rows.map(_mapToDomain).toList());
  }

  @override
  Future<Venue?> getVenueById(int id) async {
    final query = _database.select(_database.venues)
      ..where((v) => v.id.equals(id));
    final venue = await query.getSingleOrNull();
    if (venue == null) return null;
    return _mapToDomain(venue);
  }

  @override
  Future<void> saveVenue(Venue venue) async {
    final companion = db.VenuesCompanion(
      name: drift.Value(venue.name),
      address: drift.Value(venue.address),
      indoor: drift.Value(venue.indoor),
      updatedAt: drift.Value(DateTime.now()),
    );

    if (venue.id > 0) {
      await (_database.update(
        _database.venues,
      )..where((v) => v.id.equals(venue.id))).write(companion);
    } else {
      await _database.into(_database.venues).insert(companion);
    }
  }

  @override
  Future<void> deleteVenue(int id) async {
    await (_database.delete(
      _database.venues,
    )..where((v) => v.id.equals(id))).go();
  }

  Venue _mapToDomain(db.Venue data) {
    return Venue(
      id: data.id,
      name: data.name,
      address: data.address,
      indoor: data.indoor,
      createdAt: data.createdAt,
      updatedAt: data.updatedAt,
    );
  }
}
