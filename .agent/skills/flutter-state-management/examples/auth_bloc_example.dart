import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

// --- Events ---
sealed class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class AuthLoginRequested extends AuthEvent {
  final String username;
  final String password;

  const AuthLoginRequested({required this.username, required this.password});

  @override
  List<Object> get props => [username, password];
}

// --- States ---
sealed class AuthState extends Equatable {
  const AuthState();
  
  @override
  List<Object> get props => [];
}

class AuthInitial extends AuthState {}
class AuthLoading extends AuthState {}
class AuthSuccess extends AuthState {
  final String token;
  const AuthSuccess(this.token);
  
  @override
  List<Object> get props => [token];
}
class AuthFailure extends AuthState {
  final String error;
  const AuthFailure(this.error);
  
  @override
  List<Object> get props => [error];
}

// --- BLoC ---
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  // Inject your repository here
  // final AuthRepository repository;

  AuthBloc() : super(AuthInitial()) {
    on<AuthLoginRequested>(_onLoginRequested);
  }

  Future<void> _onLoginRequested(
      AuthLoginRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      // final token = await repository.login(event.username, event.password);
      await Future.delayed(const Duration(seconds: 1)); // Simulate API call
      emit(const AuthSuccess("fake_jwt_token_123"));
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }
}
