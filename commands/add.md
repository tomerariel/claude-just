---
description: Add a recipe to an existing justfile, or create a minimal one if none exists. Use when automating a specific task with just.
argument-hint: "<task to automate>"
allowed-tools: [Read, Edit, Glob, Bash, AskUserQuestion]
---

# Add Recipe to Justfile

Add a recipe (or small group of related recipes) to the project's `justfile` based on `$ARGUMENTS`.

See [reference.md](../reference.md) for syntax and built-in functions.

## Workflow

1. **Read** — find `justfile` / `Justfile` / `.justfile`; parse structure if found.
2. **Plan** — determine recipe name, params, commands. If an existing recipe covers this concern, suggest modifying it instead.
3. **Insert** (justfile exists) — place recipe in correct section (settings → vars → default → grouped → private helpers). Match existing style. Add doc comment. Preserve all existing content.
4. **Create** (no justfile) — write a minimal scaffold with `default: @just --list` plus the requested recipe. Only add settings if the recipe requires them. Suggest `/just:new` for full project-aware generation.

## Output Rules

- Use **Edit tool** to insert — never rewrite the file (use Write only when creating a new justfile)
- Doc comment on new recipe
- `@` on echo/printf lines
- Quote `{{…}}` with spaces

## Anti-patterns

- Don't rewrite, reformat, reorganize, or remove existing recipes
- Don't add unrelated recipes
