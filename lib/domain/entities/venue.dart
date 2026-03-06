import 'package:equatable/equatable.dart';

class Venue extends Equatable {
  const Venue({
    required this.id,
    required this.name,
    required this.createdAt,
    this.address,
    this.indoor = true,
    this.updatedAt,
  });

  final int id;
  final String name;
  final String? address;
  final bool indoor;
  final DateTime createdAt;
  final DateTime? updatedAt;

  @override
  List<Object?> get props => [id, name, address, indoor, createdAt, updatedAt];
}
