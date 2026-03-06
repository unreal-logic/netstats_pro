---
title: Cubits
description: Simple state management with Cubit
---

# Cubit Concepts

A **Cubit** is a simpler version of a BLoC that uses methods to trigger state changes instead of events.

## Creating a Cubit
Extend `Cubit<State>` and use `emit()` to push new states.

```dart
class CounterCubit extends Cubit<int> {
  CounterCubit() : super(0);

  void increment() => emit(state + 1);
  void decrement() => emit(state - 1);
}
```

## Using a Cubit in UI
Access the cubit via `context.read<T>()` and trigger methods.

```dart
ElevatedButton(
  onPressed: () => context.read<CounterCubit>().increment(),
  child: const Text('Increment'),
)
```

## Observation
Override `onChange` to monitor state transitions globally or locally.

```dart
@override
void onChange(Change<int> change) {
  super.onChange(change);
  print(change);
}
```
