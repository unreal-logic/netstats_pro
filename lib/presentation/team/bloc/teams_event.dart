import 'package:equatable/equatable.dart';
import 'package:netstats_pro/domain/entities/team.dart';

abstract class TeamsEvent extends Equatable {
  const TeamsEvent();

  @override
  List<Object?> get props => [];
}

class LoadTeams extends TeamsEvent {}

class AddTeam extends TeamsEvent {
  const AddTeam(this.team);
  final Team team;

  @override
  List<Object?> get props => [team];
}

class DeleteTeam extends TeamsEvent {
  const DeleteTeam(this.id);
  final int id;

  @override
  List<Object?> get props => [id];
}
