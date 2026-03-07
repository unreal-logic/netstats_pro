import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class Team extends Equatable {
  const Team({
    required this.id,
    required this.name,
    required this.createdAt,
    this.color,
    this.avatarUrl,
  });
  final int id;
  final String name;
  final Color? color;
  final String? avatarUrl;
  final DateTime createdAt;

  @override
  List<Object?> get props => [id, name, color, avatarUrl, createdAt];
}
