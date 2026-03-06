---
name: flutter-motion-and-haptics
description: Comprehensive guide for implementing animations in Flutter. Focuses on implicit, explicit, and hero animations, as well as integrating haptic feedback.
---

# Flutter Motion and Haptics

## When to Use This Skill
- When an interface feels static and needs delightful micro-interactions.
- When transforming between different UI states (e.g., expanding a card).
- When transitioning between completely different screens (Hero).
- When physical feedback is needed for button presses or substitutions (Haptics).

## How to Use This Skill
1. **Choose Animation Type:** 
   - **Implicit:** Use `AnimatedContainer`, `AnimatedOpacity`, etc., for "set and forget" value changes without complex curves.
   - **Explicit:** Use `AnimationController` and `Tween`s when you need granular control, looping, playing in reverse, or sequencing.
   - **Transitions:** Use `Hero` for shared elements between navigations.
2. **Implement:** Write the animation tied to the Flutter render loop or `TickerProvider`.
3. **Haptics:** Use the `HapticFeedback` class (`lightImpact`, `mediumImpact`, `vibrate`) to complement the visual animation with physical responses.

## Conventions
- Do not animate components arbitrarily—every animation should serve a purpose (drawing attention, covering latency, spatial context).
- Ensure animations respect the device's accessibility settings (e.g., `disableAnimations` flag).
- Release `AnimationController`s in `dispose` to prevent memory leaks.
