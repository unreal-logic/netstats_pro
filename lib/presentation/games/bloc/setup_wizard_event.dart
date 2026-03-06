import 'package:equatable/equatable.dart';
import 'package:netstats_pro/domain/entities/game.dart';
import 'package:netstats_pro/domain/entities/player.dart';

abstract class SetupWizardEvent extends Equatable {
  const SetupWizardEvent();

  @override
  List<Object?> get props => [];
}

class LoadSetupData extends SetupWizardEvent {}

class StepChanged extends SetupWizardEvent {
  const StepChanged(this.step);
  final int step;
  @override
  List<Object?> get props => [step];
}

class OpponentNameChanged extends SetupWizardEvent {
  const OpponentNameChanged(this.name, {this.teamId});
  final String name;
  final int? teamId;
  @override
  List<Object?> get props => [name, teamId];
}

class HomeTeamNameChanged extends SetupWizardEvent {
  const HomeTeamNameChanged(this.name, {this.teamId});
  final String name;
  final int? teamId;
  @override
  List<Object?> get props => [name, teamId];
}

class CompetitionSelected extends SetupWizardEvent {
  const CompetitionSelected(this.id);
  final int id;
  @override
  List<Object?> get props => [id];
}

class VenueSelected extends SetupWizardEvent {
  const VenueSelected(this.id);
  final int id;
  @override
  List<Object?> get props => [id];
}

class ScheduledAtChanged extends SetupWizardEvent {
  const ScheduledAtChanged(this.date);
  final DateTime date;
  @override
  List<Object?> get props => [date];
}

class FormatChanged extends SetupWizardEvent {
  const FormatChanged(this.format);
  final GameFormat format;
  @override
  List<Object?> get props => [format];
}

class PositionAssigned extends SetupWizardEvent {
  const PositionAssigned(this.position, this.player);
  final NetballPosition position;
  final Player? player;
  @override
  List<Object?> get props => [position, player];
}

class FirstCentrePassToggled extends SetupWizardEvent {
  const FirstCentrePassToggled({required this.ourPass});
  final bool ourPass;
  @override
  List<Object?> get props => [ourPass];
}

class AutoAssignLineup extends SetupWizardEvent {}

class IsSuperShotToggled extends SetupWizardEvent {
  const IsSuperShotToggled({required this.isSuperShot});
  final bool isSuperShot;
  @override
  List<Object?> get props => [isSuperShot];
}

class SetupSubmitted extends SetupWizardEvent {}
