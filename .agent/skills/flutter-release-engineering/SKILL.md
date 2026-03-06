---
name: flutter-release-engineering
description: To get the app to the finish line. Manages environment variables/flavors (Dev, Staging, Prod), app signing, obfuscation, and configuring Firebase Crashlytics.
---

# Flutter Release Engineering

## When to Use This Skill
- When setting up different build environments (development, staging, production).
- When preparing an app for Google Play Store or Apple App Store submission.
- When configuring app signing keys and provisioning profiles.
- When integrating error reporting (Crashlytics, Sentry) and Analytics.

## How to Use This Skill
1. **Define Flavors:** Separate configurations using different main entry points (e.g., `main_dev.dart`, `main_prod.dart`) or native flavors (ProductFlavors in Gradle, Build Schemes in Xcode).
2. **Manage Secrets:** Use environment variables (via `--dart-define` or `.env` files) to keep API keys and secrets out of the codebase.
3. **App Signing:** Ensure secure generation and storage of the `upload-keystore.jks` for Android and the correct Certificates/Profiles for iOS.
4. **Obfuscation:** Run build commands with `--obfuscate --split-debug-info` to protect source code in production.

## Conventions
- **MCP Integration:** If Firebase Crashlytics or Analytics are required, utilize the `firebase-mcp-server` tools (like `mcp_firebase-mcp-server_firebase_create_app`) instead of manual Firebase console navigation or raw shell CLI usage.
- Never commit production API keys to source control.
- Ensure all logging (`print()`) is stripped out in production builds using `kReleaseMode` or custom logger wrappers.
- Set up a CI/CD pipeline (GitHub Actions, Codemagic) to automate the release builds.
