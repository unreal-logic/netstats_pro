---
name: flutter-state-management
description: Expert system for Flutter state management, specifically focused on the BLoC pattern. Guides the predictable flow of data from events to states.
---

# Flutter State Management

## When to Use This Skill
- When building interactive UIs that require predictable state updates.
- When separating business logic from Widget `build` methods.
- When writing robust, testable state transitions.

## How to Use This Skill
1. **Identify the Scope:** Decide if the state is Local (ephemeral, like a toggle) or Global (app-wide, like a user session). Use standard `setState` for purely local UI animation state if needed, but BLoC for business logic.
2. **Define Events & States:** Create sealed classes for your Events (inputs) and States (outputs).
3. **Implement the BLoC:** Map incoming events to outgoing states using `on<Event>`. Handle loading, success, and error states gracefully.
4. **Bind UI:** Use `BlocBuilder` for rebuilding UI, `BlocListener` for side effects (navigation/snackbars), and `BlocConsumer` for both.

## Conventions
- Never perform UI-specific logic (like routing context) inside a BLoC.
- Keep states immutable using packages like `equatable` or `freezed`.
- Dispatch events to trigger changes; do not mutate state directly.
