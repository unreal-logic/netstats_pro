---
title: Blocs
description: Advanced event-driven state management
---

# BLoC Concepts

A **BLoC** is an event-driven state management solution that relies on events to trigger state changes.

## Defining Events and States
Use sealed classes (Dart 3+) for type safety.

```dart
sealed class CounterEvent {}
final class IncrementRequested extends CounterEvent {}
final class DecrementRequested extends CounterEvent {}

class CounterState {
  final int count;
  CounterState(this.count);
}
```

## Creating a BLoC
Use `on<Event>` handlers to process events.

```dart
class CounterBloc extends Bloc<CounterEvent, CounterState> {
  CounterBloc() : super(CounterState(0)) {
    on<IncrementRequested>((event, emit) {
      emit(CounterState(state.count + 1));
    });
    
    on<DecrementRequested>((event, emit) {
      emit(CounterState(state.count - 1));
    });
  }
}
```

## Event Transformations
BLOCs allow powerful transformations like **debouncing**.

```dart
on<SearchQueryChanged>(
  (event, emit) { ... },
  transformer: debounce(const Duration(milliseconds: 300)),
);
```

## Transitions
Override `onTransition` for detailed logging of Events -> States.
