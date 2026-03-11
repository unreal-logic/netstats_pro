import 'package:netstats_pro/domain/entities/match_event.dart';

abstract class MatchEventRepository {
  Future<List<MatchEvent>> getEventsForGame(int gameId);
  Future<int> saveEvent(MatchEvent event);
  Future<void> deleteEvent(int eventId);
  Future<void> clearEventsForGame(int gameId);
}
