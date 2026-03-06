import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:netstats_pro/domain/entities/player.dart';
import 'package:netstats_pro/domain/repositories/player_repository.dart';

// --- Events ---
abstract class PlayerFormEvent extends Equatable {
  const PlayerFormEvent();

  @override
  List<Object?> get props => [];
}

class PlayerFirstNameChanged extends PlayerFormEvent {
  const PlayerFirstNameChanged(this.firstName);
  final String firstName;

  @override
  List<Object?> get props => [firstName];
}

class PlayerLastNameChanged extends PlayerFormEvent {
  const PlayerLastNameChanged(this.lastName);
  final String lastName;

  @override
  List<Object?> get props => [lastName];
}

class PlayerNicknameChanged extends PlayerFormEvent {
  const PlayerNicknameChanged(this.nickname);
  final String nickname;

  @override
  List<Object?> get props => [nickname];
}

class PlayerNumberChanged extends PlayerFormEvent {
  const PlayerNumberChanged(this.number);
  final String number;

  @override
  List<Object?> get props => [number];
}

class PlayerPositionToggled extends PlayerFormEvent {
  const PlayerPositionToggled(this.position);
  final NetballPosition position;

  @override
  List<Object?> get props => [position];
}

class PlayerFormSubmitted extends PlayerFormEvent {}

// --- State ---
enum PlayerFormStatus { initial, submitting, success, failure }

class PlayerFormState extends Equatable {
  const PlayerFormState({
    this.firstName = '',
    this.lastName = '',
    this.nickname = '',
    this.primaryNumber = '',
    this.preferredPositions = const [],
    this.status = PlayerFormStatus.initial,
    this.errorMessage,
  });

  final String firstName;
  final String lastName;
  final String nickname;
  final String primaryNumber;
  final List<NetballPosition> preferredPositions;
  final PlayerFormStatus status;
  final String? errorMessage;

  bool get isValid =>
      firstName.isNotEmpty &&
      lastName.isNotEmpty &&
      preferredPositions.isNotEmpty;

  PlayerFormState copyWith({
    String? firstName,
    String? lastName,
    String? nickname,
    String? primaryNumber,
    List<NetballPosition>? preferredPositions,
    PlayerFormStatus? status,
    String? errorMessage,
  }) {
    return PlayerFormState(
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      nickname: nickname ?? this.nickname,
      primaryNumber: primaryNumber ?? this.primaryNumber,
      preferredPositions: preferredPositions ?? this.preferredPositions,
      status: status ?? this.status,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    firstName,
    lastName,
    nickname,
    primaryNumber,
    preferredPositions,
    status,
    errorMessage,
  ];
}

// --- Bloc ---
class PlayerFormBloc extends Bloc<PlayerFormEvent, PlayerFormState> {
  PlayerFormBloc({required PlayerRepository playerRepository})
    : _playerRepository = playerRepository,
      super(const PlayerFormState()) {
    on<PlayerFirstNameChanged>((event, emit) {
      emit(state.copyWith(firstName: event.firstName));
    });

    on<PlayerLastNameChanged>((event, emit) {
      emit(state.copyWith(lastName: event.lastName));
    });

    on<PlayerNicknameChanged>((event, emit) {
      emit(state.copyWith(nickname: event.nickname));
    });

    on<PlayerNumberChanged>((event, emit) {
      emit(state.copyWith(primaryNumber: event.number));
    });

    on<PlayerPositionToggled>((event, emit) {
      final positions = List<NetballPosition>.from(state.preferredPositions);
      if (positions.contains(event.position)) {
        positions.remove(event.position);
      } else {
        positions.add(event.position);
      }
      emit(state.copyWith(preferredPositions: positions));
    });

    on<PlayerFormSubmitted>(_onSubmitted);
  }
  final PlayerRepository _playerRepository;

  Future<void> _onSubmitted(
    PlayerFormSubmitted event,
    Emitter<PlayerFormState> emit,
  ) async {
    if (!state.isValid) return;

    emit(state.copyWith(status: PlayerFormStatus.submitting));

    try {
      final player = Player(
        id: 0, // Database handles auto-increment
        firstName: state.firstName,
        lastName: state.lastName,
        nickname: state.nickname.isEmpty ? null : state.nickname,
        primaryNumber: int.tryParse(state.primaryNumber),
        preferredPositions: state.preferredPositions,
        createdAt: DateTime.now(),
      );

      await _playerRepository.createPlayer(player);
      emit(state.copyWith(status: PlayerFormStatus.success));
    } on Object catch (e) {
      emit(
        state.copyWith(
          status: PlayerFormStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }
}
