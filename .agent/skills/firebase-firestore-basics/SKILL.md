---
name: firebase-firestore-basics
description: Comprehensive guide for Firestore basics including provisioning, security rules, and SDK usage. Use this skill when the user needs help setting up Firestore, writing security rules, or using the Firestore SDK in their application.
compatibility: This skill is best used with the Firebase CLI, but does not require it. Install it by running `npm install -g firebase-tools`. 
---

# Firestore Basics

This skill provides a complete guide for getting started with Cloud Firestore, including provisioning, securing, and integrating it into your application.

## Provisioning & Rules

Use the `firebase-mcp-server` to provision Firestore and manage security rules automatically.

- **Provision Firestore**: 
  ```bash
  mcp_firebase-mcp-server_firebase_init(
    features: {
      firestore: { 
        location_id: "us-central1",
        rules: "service cloud.firestore { match /databases/{database}/documents { match /{document=**} { allow read, write: if request.auth != null; } } }"
      }
    }
  )
  ```
- **Get Rules**: Use `mcp_firebase-mcp-server_firebase_get_security_rules(type: "firestore")` to retrieve current rules.

## SDK Usage

To learn how to use Cloud Firestore in your application code, choose your platform:

*   **Web (Modular SDK)**: [web_sdk_usage.md](references/web_sdk_usage.md)

## Indexes

For checking index types, query support tables, and best practices, see [indexes.md](references/indexes.md).
