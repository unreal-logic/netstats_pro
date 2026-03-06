---
name: flutter-accessibility-and-i18n
description: Ensures the app is universally usable. Handles translating the app into different languages and ensuring all UI components work correctly with native screen readers.
---

# Flutter Accessibility and I18N

## When to Use This Skill
- When building an app intended for a global audience requiring multiple languages.
- When adapting to Right-to-Left (RTL) reading directions.
- When ensuring blind or visually impaired users can navigate the app using VoiceOver (iOS) or TalkBack (Android).

## How to Use This Skill
1. **Translations (I18N):** Use the `flutter_localizations` package and `.arb` (Application Resource Bundle) files. Run `flutter gen-l10n` to automatically generate the AppLocalizations dart equivalents.
2. **Semantic UI:** Do not rely purely on visual hierarchy. Wrap complex widgets with `Semantics()` to supply the screen reader with meaningful labels, hints, and interactions.
3. **Dynamic Type:** Respect the user's OS text scale factor. Do not aggressively restrict text scaling unless absolutely necessary to prevent severe layout breaks.

## Conventions
- Stop hardcoding strings in UI widgets. Use `AppLocalizations.of(context)!.myLabel`.
- For image/icon buttons with no text, ALWAYS provide a `semanticLabel`.
- When merging a complex UI component (like a custom multi-element card), use `ExcludeSemantics` on the children and define a single overarching `Semantics` label for the parent to prevent the screen reader from reading disjointed fragments.
