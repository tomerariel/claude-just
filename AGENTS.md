# claude-just — Agent Guide

A Claude Code plugin that generates well-structured [justfiles](https://just.systems/).

## Repo Structure

```
.claude-plugin/plugin.json   # plugin metadata (name, version, license)
reference.md                 # just syntax quick reference — single source of truth
commands/
  new.md                     # /just:new — generate a complete justfile from scratch
  add.md                     # /just:add — add a recipe to an existing justfile
```

## Key Design Decisions

- **`reference.md` is the syntax source of truth.** Both commands link to it; neither should duplicate its content. When updating just syntax, update `reference.md` only.
- **`/just:new` generates full files; `/just:add` uses targeted edits.** The add command must use the Edit tool (not Write) to avoid rewriting existing justfiles.
- **Command descriptions appear in autocomplete.** The `description` field in each command's frontmatter is shown to users. Keep them precise and informative.

## Development

Run `just` in the repo root to see available recipes.

## Official Reference

- [just manual](https://just.systems/man/en/) — canonical syntax documentation
- [just GitHub](https://github.com/casey/just) — source and changelog
