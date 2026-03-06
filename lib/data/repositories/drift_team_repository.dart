import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:netstats_pro/data/database/app_database.dart' as db;
import 'package:netstats_pro/domain/entities/team.dart';
import 'package:netstats_pro/domain/repositories/team_repository.dart';

class DriftTeamRepository implements TeamRepository {
  DriftTeamRepository(this._database);
  final db.AppDatabase _database;

  @override
  Future<List<Team>> getAllTeams() async {
    final teams = await _database.select(_database.teams).get();
    return teams.map(_mapToEntity).toList();
  }

  @override
  Stream<List<Team>> watchAllTeams() {
    return _database
        .select(_database.teams)
        .watch()
        .map((rows) => rows.map(_mapToEntity).toList());
  }

  @override
  Future<Team?> getTeamById(int id) async {
    final query = _database.select(_database.teams)
      ..where((t) => t.id.equals(id));
    final team = await query.getSingleOrNull();
    return team != null ? _mapToEntity(team) : null;
  }

  @override
  Future<int> createTeam(Team team) {
    return _database.into(_database.teams).insert(_mapToCompanion(team));
  }

  @override
  Future<bool> updateTeam(Team team) {
    return _database.update(_database.teams).replace(_mapToDataClass(team));
  }

  @override
  Future<int> deleteTeam(int id) {
    return (_database.delete(
      _database.teams,
    )..where((t) => t.id.equals(id))).go();
  }

  Team _mapToEntity(db.Team data) {
    return Team(
      id: data.id,
      name: data.name,
      color: data.colorHex != null
          ? Color(
              int.parse(data.colorHex!.replaceFirst('#', ''), radix: 16) |
                  0xFF000000,
            )
          : null,
      createdAt: data.createdAt,
    );
  }

  db.TeamsCompanion _mapToCompanion(Team entity) {
    return db.TeamsCompanion.insert(
      name: entity.name,
      colorHex: Value(
        entity.color != null
            // Color.value is deprecated in favor of Argb32, but we keep it
            // for compatibility with the current environment's SDK.
            // ignore: deprecated_member_use
            ? '#${entity.color!.value.toRadixString(16).padLeft(
                8,
                '0',
              ).toUpperCase()}'
            : null,
      ),
    );
  }

  db.Team _mapToDataClass(Team entity) {
    return db.Team(
      id: entity.id,
      name: entity.name,
      colorHex: entity.color != null
          // Color.value is deprecated in favor of Argb32, but we keep it
          // for compatibility with the current environment's SDK.
          // ignore: deprecated_member_use
          ? '#${entity.color!.value.toRadixString(16).padLeft(
              8,
              '0',
            ).toUpperCase()}'
          : null,
      createdAt: entity.createdAt,
    );
  }
}
