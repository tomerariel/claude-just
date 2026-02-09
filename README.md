# just — Claude Code Plugin

A Claude Code plugin that generates well-structured, idiomatic [justfiles](https://just.systems/) with best practices.

## Install

```bash
# from the marketplace
claude /plugin marketplace add tomerariel/just

# then install it
claude /plugin install just@tomerariel-just
```

## Skills

### `/just:new` — generate a complete justfile

```
/just:new python web api with fastapi
/just:new rust cli tool with clap
/just:new node monorepo with turborepo
/just:new go microservice with docker
/just:new            # auto-detect from current project
```

Generates a full, project-aware justfile with sensible defaults, doc comments, grouped recipes, OS-specific recipes, and common patterns for your stack.

### `/just:add` — add a recipe to an existing justfile

```
/just:add run database migrations
/just:add lint and format code
/just:add deploy to staging with docker
/just:add           # describe what you want to automate
```

Adds a recipe (or small group of related recipes) to your existing justfile, respecting its structure and style. Creates a minimal justfile if none exists.

## What's Included

- **`/just:new`** — generate a new justfile from a project description or by analyzing the current codebase
- **`/just:add`** — add a recipe to an existing justfile, or create a minimal one if none exists
- **`reference.md`** — comprehensive `just` syntax reference that Claude can consult for accurate, up-to-date syntax

## Tip: Make Agents Aware

After generating a justfile, consider adding this to your project's `CLAUDE.md` or `AGENTS.md`:

```
use `just` for common automation — run `just` to see available recipes.
```

This ensures AI agents know to use `just` instead of raw shell commands or other task runners.

## License

MIT
