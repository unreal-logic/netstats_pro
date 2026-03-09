import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
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

class TrackingModeChanged extends SetupWizardEvent {
  const TrackingModeChanged(this.mode);
  final TrackingMode mode;
  @override
  List<Object?> get props => [mode];
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

class AutoAssignLineup extends SetupWizardEvent {
  const AutoAssignLineup({this.isHomeTeam = true});
  final bool isHomeTeam;
  @override
  List<Object?> get props => [isHomeTeam];
}

class IsSuperShotToggled extends SetupWizardEvent {
  const IsSuperShotToggled({required this.isSuperShot});
  final bool isSuperShot;
  @override
  List<Object?> get props => [isSuperShot];
}

class Fast5PowerPlayModeChanged extends SetupWizardEvent {
  const Fast5PowerPlayModeChanged(this.mode);
  final Fast5PowerPlayMode mode;
  @override
  List<Object?> get props => [mode];
}

class QuickCreateCompetition extends SetupWizardEvent {
  const QuickCreateCompetition(this.name);
  final String name;
  @override
  List<Object?> get props => [name];
}

class QuickCreateVenue extends SetupWizardEvent {
  const QuickCreateVenue(this.name);
  final String name;
  @override
  List<Object?> get props => [name];
}

class QuickCreateTeam extends SetupWizardEvent {
  const QuickCreateTeam({
    required this.name,
    required this.isHomeTeam,
    this.color,
  });
  final String name;
  // If true → this becomes the home team; false → opponent
  final bool isHomeTeam;
  final Color? color;
  @override
  List<Object?> get props => [name, isHomeTeam, color];
}

class TrackBothTeamsToggled extends SetupWizardEvent {
  const TrackBothTeamsToggled({required this.value});
  final bool value;
  @override
  List<Object?> get props => [value];
}

class QuickCreatePlayer extends SetupWizardEvent {
  const QuickCreatePlayer({
    required this.firstName,
    required this.lastName,
    required this.position,
    required this.isHomeTeam,
    required this.gender,
    this.heightCm,
  });
  final String firstName;
  final String lastName;
  final NetballPosition position;
  final bool isHomeTeam;
  final Gender gender;
  final double? heightCm;
  @override
  List<Object?> get props => [
    firstName,
    lastName,
    position,
    isHomeTeam,
    gender,
    heightCm,
  ];
}

class OpponentPositionAssigned extends SetupWizardEvent {
  const OpponentPositionAssigned(this.position, this.player);
  final NetballPosition position;
  final Player? player;
  @override
  List<Object?> get props => [position, player];
}

class QuarterDurationChanged extends SetupWizardEvent {
  const QuarterDurationChanged(this.minutes);
  final int minutes;
  @override
  List<Object?> get props => [minutes];
}

class HomePowerPlayQuarterChanged extends SetupWizardEvent {
  const HomePowerPlayQuarterChanged(this.quarter);
  final int? quarter;
  @override
  List<Object?> get props => [quarter];
}

class AwayPowerPlayQuarterChanged extends SetupWizardEvent {
  const AwayPowerPlayQuarterChanged(this.quarter);
  final int? quarter;
  @override
  List<Object?> get props => [quarter];
}

class SetupSubmitted extends SetupWizardEvent {}
