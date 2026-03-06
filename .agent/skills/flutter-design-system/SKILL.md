---
name: flutter-design-system
description: Guides the implementation of highly consistent, scalable visual design systems in Flutter using ThemeData and ThemeExtensions.
---

# Flutter Design System

## When to Use This Skill
- When translating Figma mocks or design specs into Flutter code.
- When setting up global typography, colors, and component themes.
- When enforcing a specific visual aesthetic like "Apple Square".
- When managing Light and Dark mode variations.

## How to Use This Skill
1. **Define Tokens:** Extract raw design values (colors, spacing, typography) into constant classes or `ThemeExtension`s.
2. **Build the Theme (Material 3):** Construct `ThemeData(useMaterial3: true)`. Generate your `ColorScheme` using `ColorScheme.fromSeed(seedColor: base)` to automatically generate the required tonal palettes (Primary, Secondary, Tertiary, Neutral, Error).
3. **Dynamic Color:** If applicable, wrap your `MaterialApp` in a `DynamicColorBuilder` (via the `dynamic_color` package) to adapt to the user's Android wallpaper.
4. **Apply the Theme:** Ensure the root `MaterialApp` uses the centralized theme.
5. **Access in UI:** Do not hardcode colors in standard widgets. Always use `Theme.of(context)` to access colors and M3 text styles (`displayLarge`, `headlineMedium`, `bodySmall`, etc.).

## Conventions
- **Widget Selection:** ALWAYS prefer Material 3 widgets over their legacy M2 counterparts. 
  - Use `NavigationBar` instead of `BottomNavigationBar`.
  - Use `FilledButton`, `FilledButton.tonal`, and `ElevatedButton` instead of legacy `RaisedButton` or custom styled buttons.
- **Elevation:** Rely on `surfaceTint` color blending for depth rather than harsh, dark drop shadows (`elevation: 0` is common in M3).
- Prefer semantic naming (e.g., `surface`, `onPrimary`, `error`) over literal naming (`red`, `blue`).
- Use `ThemeExtension` for custom tokens that don't fit perfectly into Material 3's `ColorScheme`.
- Keep text scaling accessible; use standard text spans.
