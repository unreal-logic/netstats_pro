---
name: flutter-adaptive-layouts
description: Expert in building Flutter user interfaces that look perfect across mobile, tablet, and desktop viewports seamlessly.
---

# Flutter Adaptive Layouts

## When to Use This Skill
- When building UIs that must support both portrait and landscape modes.
- When scaling a mobile app to iPad/Tablet or Web.
- When handling safe areas, notches, and keyboard overlaps.

## How to Use This Skill
1. **Analyze Viewports:** Determine the core breakpoints for compact, medium, and expanded layouts.
2. **Use Constraints:** Leverage `LayoutBuilder` to make decisions based on available parent space, not just physical screen size (`MediaQuery`).
3. **Adaptive Components (Material 3):** Implement conditional rendering based on class sizes. 
   - **Mobile (Compact):** Use the M3 `NavigationBar` at the bottom of the screen.
   - **Tablet (Medium):** Use the M3 `NavigationRail` vertically on the leading edge.
   - **Desktop (Expanded):** Use the M3 `NavigationDrawer` permanently affixed to the leading edge.
4. **Flexibility:** Use `Flexible`, `Expanded`, `Wrap`, and `Grid` layouts to flow content naturally instead of hardcoding heights and widths.

## Conventions
- Never stretch a `NavigationBar` across an ultra-wide desktop monitor.
- Avoid hardcoded magic numbers for sizing; use relative sizing and padding tokens.
- Always wrap top-level generic screens in a `SafeArea`.
- Test UIs by actively resizing the window boundaries to ensure components don't throw overflow exceptions.
