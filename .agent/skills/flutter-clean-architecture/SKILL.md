---
name: flutter-clean-architecture
description: Enforces Clean Architecture principles in Flutter projects. Guides the separation of presentation, domain, and data layers to ensure maintainable, testable, and scalable codebases.
---

# Flutter Clean Architecture

## When to Use This Skill
- When setting up a new Flutter feature or module.
- When refactoring "spaghetti code" into maintainable layers.
- When configuring dependency injection (e.g., using `get_it` or `injectable`).
- When deciding where business logic, API calls, or routing should live.

## How to Use This Skill
1. **Analyze:** Look at the feature requirements and identify the required data sources, models, and UI components.
2. **Structure:** Enforce the following separation:
   - **Data Layer:** Models, DTOs, Repositories, Data Sources (API, Local DB).
   - **Domain Layer:** Entities, Use Cases (Interactors), Repository Interfaces.
   - **Presentation Layer:** UI (Widgets/Screens), State Management (BLoC/Provider).
3. **Implement:** Scaffold the files accordingly, ensuring inner layers (Domain) never depend on outer layers (Data/Presentation).

## Conventions
- Use interfaces (`abstract class`) in the domain layer to invert dependencies.
- Models in the data layer should extend entities from the domain layer.
- Keep the UI completely ignorant of HTTP or database implementation details.
