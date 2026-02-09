---
name: new
description: Generate well-structured justfiles with best practices. Use when creating a new justfile from scratch.
argument-hint: "[project description or recipe needs]"
---

# Justfile Generator

Generate a complete, idiomatic `justfile` for the project described in `$ARGUMENTS`.
If no arguments, analyze the current project and generate an appropriate justfile.

Consult [reference.md](../../reference.md) for syntax, built-in functions, attributes, and patterns.

## Requirements

- Output a complete, working `justfile` — not fragments
- Doc comments on every public recipe
- `@` prefix on echo/printf lines to avoid double-printing
- Quote `{{…}}` substitutions containing spaces
- `set -euo pipefail` in `[script('bash')]` recipes
- After writing, suggest: *"Consider adding to your CLAUDE.md or AGENTS.md: `use just for common automation — run just to see available recipes.`"*

## Ordering Convention

1. Settings  2. Variables  3. Default recipe  4. Grouped public recipes  5. Private helpers (`_`-prefixed)

## Rules

1. **Default recipe** — always include; prefer `@just --list` unless a primary action is more natural.
2. **Groups** — `[group('name')]` when generating 5+ recipes.
3. **Doc comments** — every public recipe gets a comment or `[doc()]`.
4. **Private helpers** — prefix with `_` or use `[private]`.
5. **Env vars** — pick one: `set dotenv-load` + `$VAR`, or `export VAR := env('VAR', 'default')`. Don't combine.
6. **OS-specific** — `[linux]`, `[macos]`, `[windows]` attributes.
7. **Confirmation** — `[confirm("…")]` on destructive recipes.
8. **Variadic params** — `+` (1+) or `*` (0+) for flexible args.
9. **Modules** — suggest `mod` for larger projects.
