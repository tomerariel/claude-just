---
name: add
description: Add a recipe to an existing justfile, or create a minimal one if none exists. Use when automating a specific task with just.
argument-hint: "<task to automate>"
---

# Add Recipe to Justfile

Add a recipe (or small group of related recipes) to the project's `justfile` based on `$ARGUMENTS`.

For detailed syntax and built-in functions, see [reference.md](../../reference.md).

## Workflow

### 1. Read Existing Justfile

- Look for `justfile` (or `Justfile`, `.justfile`) in the working directory
- If found, parse its structure: settings, variables, groups, existing recipes
- If NOT found, you will create a minimal scaffold (see below)

### 2. Understand the Request

- Determine what task the user wants to automate
- Identify the appropriate recipe name, parameters, and commands
- Check if an existing recipe already covers this concern — if so, suggest modifying it rather than duplicating

### 3. Insert the Recipe

When a justfile exists:
- Place the recipe in the correct section per the ordering convention (settings → variables → default → grouped recipes → private helpers)
- Match the existing style: quote style, attribute usage, comment style
- If the justfile uses `[group()]`, assign an appropriate group
- Add doc comments consistent with existing recipes
- Add private helper recipes (prefixed with `_`) if needed
- Preserve ALL existing content — do not reformat or restructure unrelated recipes

### 4. Create Minimal Justfile (when none exists)

If no justfile is found, create one with this structure:

```just
default:
    @just --list

# <doc comment for the requested recipe>
<requested recipe>
```

Only include settings (e.g., `set shell`, `set dotenv-load`) if the recipe requires them.
Do NOT generate a full project-aware justfile — that's what `/just:new` is for.

## Output Requirements

- Output the **complete justfile** with the new recipe integrated
- Write it to `./justfile` using the Write tool
- Include a doc comment on the new recipe
- Use `@` prefix on echo/printf lines
- Quote `{{…}}` substitutions containing spaces

## Anti-patterns

- Do NOT rewrite or reformat existing recipes
- Do NOT add unrelated recipes "while you're at it"
- Do NOT reorganize or regroup existing recipes
- Do NOT remove or rename existing recipes
- Do NOT generate a full project-aware justfile — suggest `/just:new` if the user needs that
