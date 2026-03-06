import 'package:equatable/equatable.dart';
import 'package:netstats_pro/domain/entities/game.dart';

abstract class DashboardEvent extends Equatable {
  const DashboardEvent();

  @override
  List<Object?> get props => [];
}

class LoadDashboard extends DashboardEvent {}

class DashboardUpdated extends DashboardEvent {
  const DashboardUpdated(this.games);
  final List<Game> games;

  @override
  List<Object?> get props => [games];
}
