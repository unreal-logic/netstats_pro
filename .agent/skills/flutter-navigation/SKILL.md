---
name: flutter-navigation
description: Architect for Flutter navigation and deep linking. Focuses on using `go_router` for robust, scalable routing, including nested navigators and route guards.
---

# Flutter Navigation

## When to Use This Skill
- When setting up the app's routing configuration.
- When implementing deep linking or web URLs.
- When creating nested navigation (e.g., persistent Bottom Navigation Bars).
- When protecting routes with authentication guards.

## How to Use This Skill
1. **Define Routes:** Use `GoRoute` to define paths, names, and builder functions. Keep routes distinct and hierarchical.
2. **Handle State:** Use the `redirect` property for route guards (e.g., redirecting to `/login` if unauthenticated).
3. **Navigate:** Use `context.go()` for replacing the stack (ideal for bottom navs) and `context.push()` for adding to the stack.
4. **Nested Navigation:** Implement `ShellRoute` or `StatefulShellRoute` for preserving state across different bottom navigation tabs.

## Conventions
- Prefer `go_router` over standard Navigator 1.0 for cross-platform compatibility.
- Pass complex objects as extra data only when necessary; prefer passing IDs in the path and fetching data in the target screen.
- Keep route names centralized in a constants file.
