---
title: Widgets
description: Mastery of BLoC UI widgets
---

# BLoC Widgets

The `flutter_bloc` package provides widgets to rebuild the UI or handle side effects.

## BlocBuilder
Rebuilds the UI when state changes.

```dart
BlocBuilder<CounterBloc, CounterState>(
  builder: (context, state) {
    return Text('Count: ${state.count}');
  },
)
```

## BlocListener
Used for **side effects** like navigation or showing snackbars. Guaranteed to run only once per state change.

```dart
BlocListener<AuthBloc, AuthState>(
  listener: (context, state) {
    if (state is Authenticated) Navigator.pushNamed(context, '/home');
  },
  child: const LoginForm(),
)
```

## BlocConsumer
Combines `BlocBuilder` and `BlocListener`.

```dart
BlocConsumer<CounterBloc, CounterState>(
  listener: (context, state) {
    if (state.count == 10) showSnackbar(context, 'Goal reached!');
  },
  builder: (context, state) {
    return Text('${state.count}');
  },
)
```

## BlocSelector
Optimizes performance by rebuilding only for a specific part of the state.

```dart
BlocSelector<UserBloc, UserState, String>(
  selector: (state) => state.username,
  builder: (context, name) => Text(name),
)
```
