---
title: Streams
description: Reactive database streams in drift
---

## Basic Stream
```dart
final todosStream = select(todoItems).watch();
```

## StreamBuilder
```dart
StreamBuilder<List<TodoItem>>(
  stream: select(todoItems).watch(),
  builder: (context, snapshot) {
    final todos = snapshot.data ?? [];
    return ListView.builder(
      itemCount: todos.length,
      itemBuilder: (context, index) => Text(todos[index].title),
    );
  },
)
```
