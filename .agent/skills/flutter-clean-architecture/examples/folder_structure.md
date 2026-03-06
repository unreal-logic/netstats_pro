# Clean Architecture Folder Structure Example

```text
lib/
└── features/
    └── game/
        ├── data/
        │   ├── datasources/
        │   │   ├── game_local_datasource.dart
        │   │   └── game_remote_datasource.dart
        │   ├── models/
        │   │   └── game_model.dart
        │   └── repositories/
        │       └── game_repository_impl.dart
        ├── domain/
        │   ├── entities/
        │   │   └── game_entity.dart
        │   ├── repositories/
        │   │   └── game_repository.dart
        │   └── usecases/
        │       └── get_game_details_usecase.dart
        └── presentation/
            ├── blocs/
            │   ├── game_bloc.dart
            │   ├── game_event.dart
            │   └── game_state.dart
            ├── pages/
            │   └── game_page.dart
            └── widgets/
                └── game_card.dart
```
