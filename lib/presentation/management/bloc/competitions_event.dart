import 'package:equatable/equatable.dart';
import 'package:netstats_pro/domain/entities/competition.dart';

abstract class CompetitionsEvent extends Equatable {
  const CompetitionsEvent();

  @override
  List<Object?> get props => [];
}

class LoadCompetitions extends CompetitionsEvent {}

class AddCompetition extends CompetitionsEvent {
  const AddCompetition(this.competition);
  final Competition competition;

  @override
  List<Object?> get props => [competition];
}

class DeleteCompetition extends CompetitionsEvent {
  const DeleteCompetition(this.id);
  final int id;

  @override
  List<Object?> get props => [id];
}
