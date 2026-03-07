import 'package:equatable/equatable.dart';

enum NetballPosition {
  gs, // Goal Shooter
  ga, // Goal Attack
  wa, // Wing Attack
  c, // Centre
  wd, // Wing Defence
  gd, // Goal Defence
  gk, // Goal Keeper
  // WINA 6-aside positions
  a1, // Attack 1
  a2, // Attack 2
  l1, // Link 1
  l2, // Link 2
  d1, // Defence 1
  d2, // Defence 2
  ;

  String get bib => switch (this) {
    a1 || a2 => 'A',
    l1 || l2 => 'L',
    d1 || d2 => 'D',
    _ => name,
  };
}

enum Gender {
  male,
  female,
  other,
  ;

  String get displayName => switch (this) {
    male => 'Male',
    female => 'Female',
    other => 'Other',
  };
}

class Player extends Equatable {
  const Player({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.preferredPositions,
    required this.createdAt,
    this.nickname,
    this.primaryNumber,
    this.teamId,
    this.avatarUrl,
    this.gender = Gender.female,
    // Default or required? User says "should be captured at creation"
    this.heightCm,
  });
  final int id;
  final String firstName;
  final String lastName;
  final String? nickname;
  final String? avatarUrl;
  final int? primaryNumber;
  final int? teamId;
  final List<NetballPosition> preferredPositions;
  final Gender gender;
  final double? heightCm;
  final DateTime createdAt;

  String get fullName => '$firstName $lastName';
  String get displayName => nickname ?? firstName;

  @override
  List<Object?> get props => [
    id,
    firstName,
    lastName,
    nickname,
    avatarUrl,
    primaryNumber,
    teamId,
    preferredPositions,
    gender,
    heightCm,
    createdAt,
  ];
}
