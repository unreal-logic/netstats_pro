import 'package:test/test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';

// Assume AuthBloc, AuthEvent, and AuthState exist
// Assume AuthRepository interface exists

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  group('AuthBloc', () {
    late AuthBloc authBloc;
    late MockAuthRepository mockAuthRepository;

    setUp(() {
      mockAuthRepository = MockAuthRepository();
      authBloc = AuthBloc(repository: mockAuthRepository);
    });

    tearDown(() {
      authBloc.close();
    });

    test('initial state is AuthInitial', () {
      expect(authBloc.state, equals(AuthInitial()));
    });

    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, AuthSuccess] when login succeeds',
      build: () {
        when(
          () => mockAuthRepository.login(any(), any()),
        ).thenAnswer((_) async => 'fake_token');
        return authBloc;
      },
      act: (bloc) => bloc.add(
        const AuthLoginRequested(username: 'test', password: 'password'),
      ),
      expect: () => [AuthLoading(), const AuthSuccess('fake_token')],
      verify: (_) {
        verify(() => mockAuthRepository.login('test', 'password')).called(1);
      },
    );
  });
}
