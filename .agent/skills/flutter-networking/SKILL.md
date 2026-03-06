---
name: flutter-networking
description: Enforces robust HTTP networking and data fetching in Flutter apps using libraries like Dio. Handles REST APIs and serialization.
---

# Flutter Networking

## When to Use This Skill
- When syncing a local offline database with a cloud backend.
- When consuming third-party RESTful APIs.
- When writing interceptors for Authentication (Jwt, OAuth) or logging.
- When parsing complex JSON data models.

## How to Use This Skill
1. **Setup Client:** Use `dio` or standard `http` as the base network client.
2. **Serialize JSON:** Use `json_serializable` and `json_annotation` to map API payloads strictly to Dart objects. Run `build_runner` to generate the mappers.
3. **Interceptors:** Add Dio interceptors to automatically append auth headers or catch global 401 Unauthorized errors to log out users.
4. **Error Handling:** Map HTTP exceptions (e.g., timeouts, 500s) to domain-specific failures (`NetworkFailure`, `ServerFailure`).

## Conventions
- Never expose raw HTTP responses to the presentation layer. Use the Repository pattern to map them to Domain Entities.
- Prefer Dart's modern HTTP guidelines unless `dio` offers a specific required feature (like download progress chunks).
- Always set explicit timeouts to avoid infinite spinners on flaky networks.
