---
title: Dependency Injection
description: Providing Blocs and Repositories
---

# Dependency Injection

## BlocProvider
Creates and provides a BLoC to the subtree. Handles automatic disposal.

```dart
BlocProvider(
  create: (context) => MyBloc(repository: context.read<MyRepository>()),
  child: MyWidget(),
)
```

## MultiBlocProvider
Avoids "pyramid of doom" when providing multiple blocs.

```dart
MultiBlocProvider(
  providers: [
    BlocProvider(create: (_) => AuthBloc()),
    BlocProvider(create: (_) => SettingsBloc()),
  ],
  child: MyApp(),
)
```

## RepositoryProvider
Standard way to provide data sources (Repositories) to Blocs.

```dart
RepositoryProvider(
  create: (context) => WeatherRepository(api: WeatherApi()),
  child: MultiBlocProvider(...),
)
```

## MultiRepositoryProvider
Similar to MultiBlocProvider for repositories.
