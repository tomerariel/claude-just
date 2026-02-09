# claude-just — Agent Guide

A Claude Code plugin that generates well-structured [justfiles](https://just.systems/).

## Repo Structure

```
.claude-plugin/plugin.json   # plugin metadata (name, version, license)
reference.md                 # just syntax quick reference — single source of truth
skills/
  new/SKILL.md               # /just:new — generate a complete justfile from scratch
  add/SKILL.md               # /just:add — add a recipe to an existing justfile
```

## Key Design Decisions

- **`reference.md` is the syntax source of truth.** Both skills link to it; neither should duplicate its content. When updating just syntax, update `reference.md` only.
- **`/just:new` generates full files; `/just:add` uses targeted edits.** The add skill must use the Edit tool (not Write) to avoid rewriting existing justfiles.
- **Skill descriptions drive routing.** The `description` field in each `SKILL.md` frontmatter determines which skill Claude Code selects. Keep them precise and non-overlapping.

## Useful Commands

```bash
just          # list available recipes (if justfile exists)
just lint     # lint markdown files
just check    # validate reference against official docs
```

## Official Reference

- [just manual](https://just.systems/man/en/) — canonical syntax documentation
- [just GitHub](https://github.com/casey/just) — source and changelog
