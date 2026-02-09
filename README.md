# just — Claude Code Plugin

A Claude Code plugin that generates well-structured, idiomatic [justfiles](https://just.systems/) with best practices.

## Install

```bash
# from the marketplace
claude /plugin marketplace add tomerariel/just

# then install it
claude /plugin install just@tomerariel-just
```

## Usage

```
/just:new python web api with fastapi
/just:new rust cli tool with clap
/just:new node monorepo with turborepo
/just:new go microservice with docker
/just:new            # auto-detect from current project
```

The skill generates a complete `justfile` with:

- sensible defaults and structure conventions
- doc comments on every recipe (visible in `just --list`)
- grouped recipes for larger projects
- OS-specific recipes where appropriate
- private helper recipes
- common patterns for your stack (docker, db, ci/cd, etc.)

## What's Included

- **`/just:new`** — generate a new justfile from a project description or by analyzing the current codebase
- **`reference.md`** — comprehensive `just` syntax reference that Claude can consult for accurate, up-to-date syntax

## License

MIT
