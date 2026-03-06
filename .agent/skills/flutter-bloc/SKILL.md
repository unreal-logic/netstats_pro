---
name: flutter-bloc
description: Professional state management using the BLoC library. Handles predictable state transitions via Cubit (methods) and BLoC (events). Enforces separation of concerns between UI and business logic. Includes specialized widgets like BlocBuilder, BlocListener, and BlocConsumer for reactive UI.
metadata:
  author: Antigravity
  version: "1.0"
---

# Flutter BLoC

Professional state management for Flutter, maintaining a clear separation between the UI and business logic.

## Overview
The **BLoC (Business Logic Component)** pattern helps decouple the presentation layer from the business logic, making code more testable, reusable, and predictable. This skill covers both **Cubits** (for simple logic) and **Blocs** (for complex, event-driven logic).

## Quick Start
Add the necessary dependencies to `pubspec.yaml`:

```yaml
dependencies:
  flutter_bloc: ^8.1.6
  bloc: ^8.1.4

dev_dependencies:
  bloc_test: ^9.1.5
```

## Core Selection Guide
- **Use Cubit** when: You have simple state transitions, few states, or logic that can be handled by direct method calls.
- **Use BLoC** when: You need to handle complex events, requires event transformations (debouncing, throttling), or need an audit trail of events.

## Reference Files
Detailed documentation and patterns for every aspect of BLoC:

- [setup.md](references/setup.md) - Project configuration and initial setup.
- [cubits.md](references/cubits.md) - Implementing simple state management.
- [blocs.md](references/blocs.md) - Mastering event-driven state transitions.
- [widgets.md](references/widgets.md) - BlocBuilder, Listener, and Consumer guide.
- [dependency-injection.md](references/dependency-injection.md) - Scoping with BlocProvider.
- [testing.md](references/testing.md) - Unit testing with bloc_test.
- [best-practices.md](references/best-practices.md) - Folder structure and naming conventions.

## Common Pattern: BlocProvider Usage
```dart
void main() {
  runApp(
    BlocProvider(
      create: (context) => MyCubit(),
      child: MyApp(),
    ),
  );
}
```

## Design Goal
Aim for **State-Driven UIs**: The UI should always be a function of the current state emitted by the BLoC/Cubit.
