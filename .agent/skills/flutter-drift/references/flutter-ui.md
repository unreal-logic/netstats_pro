---
title: Flutter UI
description: Integrating drift with Flutter UI and state management
---

## Provider Integration
```dart
final databaseProvider = Provider<AppDatabase>((ref) {
  final database = AppDatabase();
  ref.onDispose(database.close);
  return database;
});
```

## Search with Debounce
```dart
onChanged: (query) {
  _debounce?.cancel();
  _debounce = Timer(const Duration(milliseconds: 300), () {
    setState(() {});
  });
}
```
