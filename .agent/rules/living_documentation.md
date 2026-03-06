# Living Documentation Rule

The `docs/` folder (specifically `netstatspro-blueprint.md` and `netstatspro-schema.rs`) is the absolute **Source of Truth** for this application's development.

Whenever you implement a new feature, modify the database schema, change architectural patterns, or alter the product's scope, you MUST:
1. Review the existing documentation to see if it contradicts your proposed changes.
2. Update the relevant files in `docs/` to reflect the new reality *as part of your task*.

Consider documentation updates just as critical as code updates. The documentation must always describe the current, working state of the application.
