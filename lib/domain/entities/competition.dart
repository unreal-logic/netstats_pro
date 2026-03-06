import 'package:equatable/equatable.dart';

class Competition extends Equatable {
  const Competition({
    required this.id,
    required this.name,
    required this.createdAt,
    this.seasonYear,
    this.pointsWin = 4,
    this.pointsDraw = 2,
    this.pointsLoss = 0,
    this.updatedAt,
  });

  final int id;
  final String name;
  final int? seasonYear;
  final int pointsWin;
  final int pointsDraw;
  final int pointsLoss;
  final DateTime createdAt;
  final DateTime? updatedAt;

  @override
  List<Object?> get props => [
    id,
    name,
    seasonYear,
    pointsWin,
    pointsDraw,
    pointsLoss,
    createdAt,
    updatedAt,
  ];
}
