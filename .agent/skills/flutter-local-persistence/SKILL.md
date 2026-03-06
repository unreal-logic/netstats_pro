---
name: flutter-local-persistence
description: Complete guide for using the drift database library in Flutter applications. Specialized for offline-first architecture.
---

# Flutter Local Persistence (Drift)

## When to Use This Skill
- When building offline-first apps that need a resilient local database (SQLite).
- When defining local data models and schemas.
- When writing type-safe SQL queries/daos.
- When needing to listen to reactive streams of database changes in the UI.

## How to Use This Skill
1. **Define Schema:** Write DataClasses using Drift's `Table` definitions in Dart.
2. **Setup DB:** Instantiate the Drift database instance (specifying native SQLite mappings).
3. **Generate Code:** Use `build_runner` to generate the `.g.dart` mappings.
4. **Queries & Streams:** Write DAOs (Data Access Objects) to expose standard CRUD methods or reactive `watch()` queries that emit realtime data arrays.

## Conventions
- **MCP Integration:** When adding database dependencies, use `mcp_dart-mcp-server_pub_dev_search` to find them and `mcp_dart-mcp-server_pub` to add them. Use `run_command` via terminal only for `build_runner` code generation as MCP does not natively wrap `build_runner` yet, but use `mcp_dart-mcp-server_dart_fix` afterwards.
- Abstract the direct `DriftDatabase` via Repository interfaces in the domain layer.
- Keep complex business validation separate from the raw drift entity mappings.
- Use atomic transactions when performing bulk inserts to prevent data corruption.
