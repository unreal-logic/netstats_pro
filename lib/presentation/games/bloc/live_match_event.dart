import 'package:equatable/equatable.dart';
import 'package:netstats_pro/domain/entities/match_event.dart';

abstract class LiveMatchEvent extends Equatable {
  const LiveMatchEvent();

  @override
  List<Object?> get props => [];
}

class StartMatch extends LiveMatchEvent {
  const StartMatch(this.gameId);
  final int gameId;

  @override
  List<Object?> get props => [gameId];
}

class LogEvent extends LiveMatchEvent {
  const LogEvent({
    required this.type,
    this.playerId,
    this.position,
    this.isHomeTeam = true,
  });
  final MatchEventType type;
  final int? playerId;
  final String? position;
  final bool isHomeTeam;

  @override
  List<Object?> get props => [type, playerId, position, isHomeTeam];
}

class TogglePowerPlay extends LiveMatchEvent {}

class ToggleTeamPowerPlay extends LiveMatchEvent {
  const ToggleTeamPowerPlay({required this.isHomeTeam});
  final bool isHomeTeam;

  @override
  List<Object?> get props => [isHomeTeam];
}

class UpdateClock extends LiveMatchEvent {
  const UpdateClock(this.elapsed);
  final Duration elapsed;

  @override
  List<Object?> get props => [elapsed];
}

class StartTimer extends LiveMatchEvent {}

class PauseTimer extends LiveMatchEvent {}

class ResetTimer extends LiveMatchEvent {}

class ChangeQuarter extends LiveMatchEvent {
  const ChangeQuarter(this.quarter);
  final int quarter;

  @override
  List<Object?> get props => [quarter];
}

class AddExtraQuarter extends LiveMatchEvent {
  const AddExtraQuarter(this.duration);
  final Duration duration;

  @override
  List<Object?> get props => [duration];
}

class UndoEvent extends LiveMatchEvent {}

class EndMatch extends LiveMatchEvent {}

class PlayerTap extends LiveMatchEvent {
  const PlayerTap({required this.playerId, required this.position});
  final int playerId;
  final String position;

  @override
  List<Object?> get props => [playerId, position];
}

class ToggleLayout extends LiveMatchEvent {}

class SelectPendingStat extends LiveMatchEvent {
  const SelectPendingStat(this.statType);
  final MatchEventType? statType;

  @override
  List<Object?> get props => [statType];
}

class ToggleActiveTeam extends LiveMatchEvent {}

class TogglePossession extends LiveMatchEvent {}

class ToggleTimer extends LiveMatchEvent {
  const ToggleTimer();
}
