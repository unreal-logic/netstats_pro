import 'package:netstats_pro/domain/entities/venue.dart';

abstract class VenueRepository {
  Future<List<Venue>> getVenues();
  Stream<List<Venue>> watchVenues();
  Future<Venue?> getVenueById(int id);
  Future<void> saveVenue(Venue venue);
  Future<void> deleteVenue(int id);
}
