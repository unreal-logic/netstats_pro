import 'package:netstats_pro/domain/entities/team.dart';

abstract class TeamRepository {
  Future<List<Team>> getAllTeams();
  Stream<List<Team>> watchAllTeams();
  Future<Team?> getTeamById(int id);
  Future<int> createTeam(Team team);
  Future<bool> updateTeam(Team team);
  Future<int> deleteTeam(int id);
}
