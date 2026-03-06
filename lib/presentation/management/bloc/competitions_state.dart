import 'package:equatable/equatable.dart';
import 'package:netstats_pro/domain/entities/competition.dart';

abstract class CompetitionsState extends Equatable {
  const CompetitionsState();

  @override
  List<Object?> get props => [];
}

class CompetitionsInitial extends CompetitionsState {}

class CompetitionsLoading extends CompetitionsState {}

class CompetitionsLoaded extends CompetitionsState {
  const CompetitionsLoaded(this.competitions);
  final List<Competition> competitions;

  @override
  List<Object?> get props => [competitions];
}

class CompetitionsError extends CompetitionsState {
  const CompetitionsError(this.message);
  final String message;

  @override
  List<Object?> get props => [message];
}
