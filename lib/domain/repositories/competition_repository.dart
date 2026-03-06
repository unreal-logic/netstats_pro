import 'package:netstats_pro/domain/entities/competition.dart';

abstract class CompetitionRepository {
  Future<List<Competition>> getCompetitions();
  Stream<List<Competition>> watchCompetitions();
  Future<Competition?> getCompetitionById(int id);
  Future<void> saveCompetition(Competition competition);
  Future<void> deleteCompetition(int id);
}
