---
title: Best Practices
description: Clean BLoC architecture
---

# Best Practices

## 1. Feature-First Structure
Keep Blocs close to the feature they manage.

```text
lib/
  features/
    login/
      bloc/
        login_bloc.dart
        login_event.dart
        login_state.dart
      view/
        login_page.dart
```

## 2. Naming Conventions
- **Events**: Should be in the **past tense** (e.g., `LoginStarted`, `ThemeChanged`).
- **States**: Should be descriptive nouns (e.g., `LoginInProgress`, `LoginSuccess`).

## 3. Immutability
Always use immutable states. Use packages like `freezed` or `equatable` for value equality.

```dart
class MyState extends Equatable {
  final int count;
  const MyState(this.count);

  @override
  List<Object> get props => [count];
}
```

## 4. UI logic vs Business logic
Keep the BLoC pure. Don't put formatting or navigation logic inside the BLoC; handle that in the `BlocListener` or a presentation-focused helper.
