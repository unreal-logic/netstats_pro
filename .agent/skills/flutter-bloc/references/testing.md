---
title: Testing
description: Unit testing BLoCs and Cubits
---

# Testing

Use the `bloc_test` package to test your logic in a standardized way.

## Testing a Cubit
```dart
blocTest<CounterCubit, int>(
  'emits [1] when increment is called',
  build: () => CounterCubit(),
  act: (cubit) => cubit.increment(),
  expect: () => [1],
);
```

## Testing a BLoC
```dart
blocTest<CounterBloc, CounterState>(
  'emits [IncrementSuccess] when IncrementRequested is added',
  build: () => CounterBloc(),
  act: (bloc) => bloc.add(IncrementRequested()),
  expect: () => [isA<IncrementSuccess>()],
);
```

## Mocking Repositories
Always inject and mock repositories using `mocktail` or `mockito`.

```dart
class MockWeatherRepository extends Mock implements WeatherRepository {}

blocTest<WeatherBloc, WeatherState>(
  'emits [Loading, Success] when fetched',
  build: () {
    when(() => repository.getWeather()).thenAnswer((_) async => Weather());
    return WeatherBloc(repository);
  },
  ...
);
```
