---
title: Queries
description: Reading data with drift queries
---

## Basic Select
```dart
final allTodos = await select(todoItems).get();
final allTodosStream = select(todoItems).watch();
```

## Where Clause
```dart
final completedTodos = await (select(todoItems)
  ..where((t) => t.isCompleted.equals(true))
  ).get();
```

## Joins
```dart
final results = await (select(todoItems)
  .join([
    innerJoin(categories, categories.id.equalsExp(todoItems.category)),
  ])
  .get();
```
