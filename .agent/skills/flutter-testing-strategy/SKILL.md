---
name: flutter-testing-strategy
description: Senior SDET specializing in automated testing for Flutter. Guides writing unit, widget, and integration tests to guarantee code quality.
---

# Flutter Testing Strategy

## When to Use This Skill
- When writing Unit tests for Blocs, Cubits, or Repositories.
- When writing Widget tests for complex UI components.
- When performing end-to-end Integration testing.
- When setting up mocked environments (`mockito` or `mocktail`).

## How to Use This Skill
1. **Unit Testing:** Write pure Dart tests in the `test/` directory. Mock dependencies for BLoCs and assert predictable sets of outgoing states given a stream of events (`bloc_test`).
2. **Widget Testing:** Write tests that pump widgets in isolation. Use `find.byKey` or `find.text` to assert elements exist or render correctly based on given mocked state. 
3. **Integration Testing:** Write tests in the `integration_test/` directory to run the full app on an emulator/device and simulate real user flows (tapping, scrolling, typing).
4. **Mocking:** Generate mocks using `build_runner` or write manual stub implementations for repository contracts.

## Conventions
- **MCP Integration:** ALWAYS use the `mcp_dart-mcp-server_run_tests` tool to execute tests instead of running `flutter test` in the shell.
- Structure unit tests with the Arrange, Act, Assert pattern.
- Test edge cases, empty states, and error throws, not just standard "happy paths".
- Do not let tests interact with the real network or real database in Widget and Unit scopes. Use `mocktail`.
