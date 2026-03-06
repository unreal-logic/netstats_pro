---
title: Migrations
description: Database schema migrations in drift
---

## Step-by-Step Migrations
```dart
@override
MigrationStrategy get migration {
  return MigrationStrategy(
    onUpgrade: stepByStep(
      from1To2: (m, schema) async {
        await m.addColumn(schema.todoItems, schema.todoItems.dueDate);
      },
    ),
  );
}
```
