import 'package:equatable/equatable.dart';

enum DashboardStatus { initial, loading, success, failure }

class DashboardState extends Equatable {
  const DashboardState({
    this.status = DashboardStatus.initial,
    this.winRate = 0,
    this.goalAvg = 0.0,
    this.turnoversAvg = 0.0,
    this.staminaAvg = 0,
    this.totalGames = 0,
  });

  final DashboardStatus status;
  final int winRate;
  final double goalAvg;
  final double turnoversAvg;
  final int staminaAvg;
  final int totalGames;

  @override
  List<Object?> get props => [
    status,
    winRate,
    goalAvg,
    turnoversAvg,
    staminaAvg,
    totalGames,
  ];

  DashboardState copyWith({
    DashboardStatus? status,
    int? winRate,
    double? goalAvg,
    double? turnoversAvg,
    int? staminaAvg,
    int? totalGames,
  }) {
    return DashboardState(
      status: status ?? this.status,
      winRate: winRate ?? this.winRate,
      goalAvg: goalAvg ?? this.goalAvg,
      turnoversAvg: turnoversAvg ?? this.turnoversAvg,
      staminaAvg: staminaAvg ?? this.staminaAvg,
      totalGames: totalGames ?? this.totalGames,
    );
  }
}
