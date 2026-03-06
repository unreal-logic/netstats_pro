---
title: Writes
description: Inserting, updating, and deleting data in drift
---

## Insert
```dart
await into(todoItems).insert(
  TodoItemsCompanion.insert(title: 'New todo'),
);
```

## Update
```dart
await (update(todoItems)
  ..where((t) => t.id.equals(1))
  ).write(TodoItemsCompanion(
    title: const Value('Updated title'),
  ));
```

## Delete
```dart
await (delete(todoItems)
  ..where((t) => t.id.equals(1))
  ).go();
```

## Transactions
```dart
await transaction(() async {
  await into(todoItems).insert(...);
  await into(categories).insert(...);
});
```
