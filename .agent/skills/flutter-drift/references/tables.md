---
title: Tables
description: Table definitions, columns, and constraints in drift
---

## Basic Table Structure
All tables in drift extend the `Table` class:

```dart
class TodoItems extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text()();
  DateTimeColumn get createdAt => dateTime().nullable()();
}
```

## Column Types
| Dart Type | Drift Column | SQL Type |
|------------|---------------|-----------|
| `int` | `integer()` | `INTEGER` |
| `String` | `text()` | `TEXT` |
| `bool` | `boolean()` | `INTEGER` (1 or 0) |
| `double` | `real()` | `REAL` |
| `DateTime` | `dateTime()` | `INTEGER` |

## Primary Keys
```dart
class Profiles extends Table {
  late final email = text()();

  @override
  Set<Column<Object>> get primaryKey => {email};
}
```

## Foreign Keys
```dart
class Albums extends Table {
  late final artist = integer().references(Artists, #id)();
}
```
