---
name: firebase-basics
description: Guide for setting up and using Firebase. Use this skill when the user is getting started with Firebase - setting up local environment, using Firebase for the first time, or adding Firebase to their app.
---
## Prerequisites

### Node.js and npm
To use the Firebase CLI, you need Node.js (version 20+ required) and npm (which comes with Node.js).

**Recommended: Use a Node Version Manager (nvm)**
This avoids permission issues when installing global packages.

1.  **Install nvm:**
    - Mac/Linux: `curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash`
    - Windows: Download [nvm-windows](https://github.com/coreybutler/nvm-windows/releases)

2.  **Install Node.js:**
    ```bash
    nvm install 24
    nvm use 24
    ```

**Alternative: Official Installer**
Download and install the LTS version from [nodejs.org](https://nodejs.org/).

**Verify Installation:**
```bash
node --version
npm --version
```

## Core Workflow

### 1. Installation

The Firebase CLI tools are often pre-installed, but you can verify or install them if needed. In this environment, you should prioritize using the `firebase-mcp-server` tools.

### 2. Authentication

Log in to Firebase using the MCP tool:

```bash
# Use this tool to sign the user into the Firebase CLI and MCP server
mcp_firebase-mcp-server_firebase_login
```

To check the current environment (authenticated user, active project, etc.):
```bash
mcp_firebase-mcp-server_firebase_get_environment
```

### 3. Projects

List and create projects using MCP tools:

- **List Projects**: `mcp_firebase-mcp-server_firebase_list_projects`
- **Create Project**: `mcp_firebase-mcp-server_firebase_create_project`

To set the active project for the current directory:
```bash
mcp_firebase-mcp-server_firebase_update_environment(active_project: "YOUR_PROJECT_ID")
```

### 4. Initialization

Initialize Firebase services in your project directory using the MCP tool. This is more reliable than the interactive shell:

```bash
# Example: Initialize Firestore and Hosting
mcp_firebase-mcp-server_firebase_init(
  features: {
    firestore: { location_id: "us-central1" },
    hosting: { public_directory: "public" }
  }
)
```

- **Command Help**: Get detailed usage for a specific command.
  ```bash
  firebase [command] --help
  # Example:
  firebase deploy --help
  firebase firestore:indexes --help
  ```

## SDK Setup

Detailed guides for adding Firebase to your app:

- **Web**: See [references/web_setup.md](references/web_setup.md)

## Common Issues

- **Permission Denied (EACCES)**: If `npm install -g` fails, suggest using a node version manager (nvm) or `sudo` (caution advised).
- **Login Issues**: If the browser doesn't open, try `firebase login --no-localhost`.
