---
name: flutter-device-integration
description: Expert system for native capabilities. Handles things outside the Flutter framework using MethodChannels, such as setting up push notifications, managing background execution, or accessing hardware.
---

# Flutter Device Integration

## When to Use This Skill
- When the app needs access to native APIs (Camera, Gallery, GPS Location).
- When implementing deep local push notifications (e.g., game reminders).
- When a task must continue running while the app is backgrounded (e.g., maintaining a live game clock ticker).
- When writing custom Swift/Kotlin code via `MethodChannel`.

## How to Use This Skill
1. **Find the Plugin:** Check if an official or highly rated community plugin exists on pub.dev (e.g., `image_picker`, `geolocator`, `flutter_local_notifications`).
2. **Permissions:** Configure native permissions rigorously:
   - iOS: Modify `Info.plist` to add required usage descriptions.
   - Android: Modify `AndroidManifest.xml` to add `<uses-permission>` tags.
3. **Write Channels (if needed):** Only write custom `MethodChannel` code if no plugin serves the specific niche purpose. Define robust message codecs.

## Conventions
- Always check and request permission gracefully before calling a native feature.
- Handle edge cases where the user denies permission (fallback states).
- Decouple device logic from UI using specific Device/Service abstractions.
