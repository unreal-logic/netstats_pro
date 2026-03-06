---
title: Setup
description: Setting up a Flutter project with BLoC
---

# Initial Setup

## 1. Add Dependencies
```bash
flutter pub add flutter_bloc bloc
flutter pub add --dev bloc_test equatable
```

## 2. Global Observers
It's helpful to see every state change in the app. Create a `SimpleBlocObserver`.

```dart
class SimpleBlocObserver extends BlocObserver {
  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    print('${bloc.runtimeType} $change');
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    print('${bloc.runtimeType} $transition');
  }
}
```

## 3. Initialize Observer
```dart
void main() {
  Bloc.observer = SimpleBlocObserver();
  runApp(const MyApp());
}
```
