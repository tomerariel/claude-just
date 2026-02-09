---
name: new
description: Generate well-structured justfiles with best practices. Use when creating a new justfile, adding recipes, or asking about just syntax and patterns.
argument-hint: "[project description or recipe needs]"
---

# Justfile Generator

Generate a complete, idiomatic `justfile` for the project described in `$ARGUMENTS`.
If no arguments, analyze the current project and generate an appropriate justfile.

For detailed syntax and built-in functions, see [reference.md](../../reference.md).

## Output Requirements

- Output a complete, working `justfile` — not fragments
- Include doc comments on every public recipe (shown in `just --list`)
- Use `@` prefix on echo/printf lines to avoid double-printing
- Quote `{{…}}` substitutions containing spaces
- After writing the justfile, suggest: *"Consider adding to your project's CLAUDE.md or AGENTS.md: `use just for common automation — run just to see available recipes.`"*

## Structure Convention

Follow this ordering in every generated justfile:

```
# 1. Settings (shell, dotenv, etc.)
# 2. Variables
# 3. Default recipe (list or primary action)
# 4. Grouped public recipes (by concern)
# 5. Private helper recipes (prefixed with _)
```

## Best Practices

### Default Recipe
Always include a default recipe. Prefer listing available recipes:
```just
default:
    @just --list
```

### Doc Comments
Comments immediately preceding a recipe appear in `just --list`:
```just
# run all tests with coverage
test:
    cargo test
```

Or use the `[doc]` attribute for explicit control:
```just
[doc('Run the full test suite')]
test:
    cargo test
```

### Groups
Organize related recipes into groups for large justfiles:
```just
[group('dev')]
dev:
    npm run dev

[group('dev')]
lint:
    npm run lint

[group('deploy')]
deploy env='staging':
    ./deploy.sh {{env}}
```

### Parameters and Defaults
```just
# build the project in the given mode
build mode='debug':
    cargo build {{ if mode == "release" { "--release" } else { "" } }}
```

Variadic params — `+` requires one or more, `*` accepts zero or more:
```just
# run specific test files
test +FILES:
    pytest {{FILES}}

# pass extra flags to the linter
lint *FLAGS:
    eslint {{FLAGS}} src/
```

### Environment Variables
```just
set dotenv-load  # load .env file

export DATABASE_URL := env('DATABASE_URL', 'postgres://localhost/dev')
```

Export a parameter as an env var with `$`:
```just
test $RUST_BACKTRACE="1":
    cargo test
```

### Conditional Logic
```just
greeting := if env('CI', '') != '' { "CI build" } else { "local build" }
```

### OS-Specific Recipes
```just
[linux]
install:
    sudo apt install -y mypackage

[macos]
install:
    brew install mypackage
```

### Confirmation for Dangerous Actions
```just
[confirm("This will delete all data. Continue?")]
reset-db:
    dropdb myapp && createdb myapp
```

### Shebang Recipes (Multi-line Scripts)
Use when you need shell variables, loops, or conditionals across lines:
```just
[script('bash')]
migrate:
    set -euo pipefail
    for f in migrations/*.sql; do
        echo "Applying $f..."
        psql "$DATABASE_URL" -f "$f"
    done
```

### Private Helpers
Prefix with `_` or use `[private]` — hidden from `just --list`:
```just
[private]
_ensure-deps:
    command -v node >/dev/null || (echo "node required" && exit 1)

build: _ensure-deps
    npm run build
```

### Aliases
```just
alias b := build
alias t := test
```

### Modules (for larger projects)
```just
mod docker        # loads docker.just or docker/mod.just
mod ci 'ci.just'  # explicit path

# invoke with: just docker build
```

### Imports (shared recipes)
```just
import 'common.just'      # required
import? 'local.just'      # optional, no error if missing
```

## Common Recipe Patterns

### Docker
```just
# build the docker image
docker-build tag='latest':
    docker build -t myapp:{{tag}} .

# run the container locally
docker-run tag='latest' *FLAGS:
    docker run --rm -it {{FLAGS}} myapp:{{tag}}
```

### Database
```just
# run pending migrations
db-migrate:
    @echo "Running migrations..."
    ./manage.py migrate

# open a database shell
db-shell:
    psql "$DATABASE_URL"
```

### CI/CD
```just
# run the full CI pipeline locally
ci: lint test build

# format, lint, and fix
fix:
    @just fmt
    @just lint --fix
```

### Python
```just
# create/activate venv and install deps
setup:
    [ -d .venv ] || python3 -m venv .venv
    .venv/bin/pip install -r requirements.txt

# run with the venv python
run *ARGS:
    .venv/bin/python main.py {{ARGS}}
```

### Node.js
```just
# install dependencies
setup:
    npm ci

# start dev server with hot reload
dev:
    npm run dev

# build for production
build:
    npm run build

# run tests in watch mode
test-watch:
    npm test -- --watch
```

### Go
```just
# build the binary
build:
    go build -o bin/app ./cmd/app

# run tests with race detection
test *FLAGS:
    go test -race ./... {{FLAGS}}

# run the linter
lint:
    golangci-lint run
```

### Rust
```just
# build in debug mode
build *FLAGS:
    cargo build {{FLAGS}}

# run all tests
test:
    cargo test

# check, clippy, and format
check:
    cargo check
    cargo clippy -- -D warnings
    cargo fmt --check
```
