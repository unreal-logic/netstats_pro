import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:netstats_pro/domain/entities/game.dart';
import 'package:netstats_pro/domain/repositories/game_repository.dart';
import 'package:netstats_pro/presentation/games/bloc/games_bloc.dart';
import 'package:netstats_pro/presentation/games/bloc/games_event.dart';
import 'package:netstats_pro/presentation/games/bloc/games_state.dart';

class MockGameRepository extends Mock implements GameRepository {}

void main() {
  late MockGameRepository mockRepo;

  setUp(() {
    mockRepo = MockGameRepository();
  });

  group('GamesBloc', () {
    test('initial state is GamesState.initial', () {
      expect(
        GamesBloc(gameRepository: mockRepo).state,
        const GamesState(),
      );
    });

    blocTest<GamesBloc, GamesState>(
      'emits [loading, success] when LoadGames fires and stream emits',
      build: () {
        when(
          () => mockRepo.watchAllGames(),
        ).thenAnswer((_) => Stream.value(<Game>[]));
        return GamesBloc(gameRepository: mockRepo);
      },
      act: (bloc) => bloc.add(const LoadGames()),
      expect: () => [
        const GamesState(status: GamesStatus.loading),
        const GamesState(status: GamesStatus.success),
      ],
    );

    blocTest<GamesBloc, GamesState>(
      'emits [loading, failure] when stream errors',
      build: () {
        when(
          () => mockRepo.watchAllGames(),
        ).thenAnswer((_) => Stream.error(Exception('DB error')));
        return GamesBloc(gameRepository: mockRepo);
      },
      act: (bloc) => bloc.add(const LoadGames()),
      expect: () => [
        const GamesState(status: GamesStatus.loading),
        const GamesState(status: GamesStatus.failure),
      ],
    );
  });
}
