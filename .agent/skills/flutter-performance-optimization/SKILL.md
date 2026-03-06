---
name: flutter-performance-optimization
description: Specialized instructions for identifying and resolving app jank, frame drops, and inefficient rendering loops in Flutter.
---

# Flutter Performance Optimization

## When to Use This Skill
- When the UI stutters or drops below 60fps (especially on older devices or during complex scroll animations).
- When a `build()` method is doing too much work.
- When diagnosing memory leaks.

## How to Use This Skill
1. **Identify the Bottleneck:** Is it CPU (Dart code execution) or GPU (rendering complex gradients, opacities, or clipping bounds)?
2. **Profile:** Use the Flutter DevTools profiler to observe the frame timeline. Look for red blocks.
3. **Optimize Builds:** Push state down the tree. Don't call `setState` at the top of a deep widget tree. Use `const` widgets extensively.
4. **Optimize Rendering:** Avoid overusing `Opacity` with animations; prefer `AnimatedOpacity` or `FadeTransition`. Avoid unneeded `ClipRRect` and excessive nesting.

## Conventions
- **MCP Integration:** ALWAYS leverage the `dart-mcp-server` to inspect the running app. Use tools like `mcp_dart-mcp-server_launch_app`, `get_widget_tree` to inspect the hierarchy, and `get_runtime_errors` to diagnose crashes before making changes.
- Add the `const` keyword everywhere possible; it flags widgets so Flutter skips rebuilding them entirely.
- Move heavy data parsing or JSON decoding to separate isolates using `compute()`.
- Pre-cache heavy images where applicable.
