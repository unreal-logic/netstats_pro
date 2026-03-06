import 'package:equatable/equatable.dart';
import 'package:netstats_pro/domain/entities/team.dart';

abstract class TeamsState extends Equatable {
  const TeamsState();

  @override
  List<Object?> get props => [];
}

class TeamsInitial extends TeamsState {}

class TeamsLoading extends TeamsState {}

class TeamsLoaded extends TeamsState {
  const TeamsLoaded(this.teams);
  final List<Team> teams;

  @override
  List<Object?> get props => [teams];
}

class TeamsError extends TeamsState {
  const TeamsError(this.message);
  final String message;

  @override
  List<Object?> get props => [message];
}
