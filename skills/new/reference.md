# Just Syntax Reference

Comprehensive reference for `just` syntax. See https://just.systems/man/en/ for the full manual.

## Settings

Settings control justfile behavior. Each may appear at most once, anywhere in the file.

```just
set shell := ["bash", "-uc"]          # shell for recipe lines and backticks
set dotenv-load                       # load .env file if present
set dotenv-filename := ".env.local"   # custom .env filename
set dotenv-path := "/etc/app/.env"    # exact path (errors if missing)
set dotenv-required                   # error if .env not found
set dotenv-override                   # .env overrides existing env vars
set export                            # export all just variables as env vars
set positional-arguments              # pass recipe args as $1, $2, etc.
set quiet                             # suppress recipe line echoing globally
set fallback                          # search parent dirs for recipes
set ignore-comments                   # ignore lines starting with #
set unstable                          # enable unstable features
set tempdir := '/tmp/just'            # custom temp dir for scripts
set working-directory := 'subdir'     # override working directory
set script-interpreter := ['uv', 'run', '--script']  # for [script] recipes
set windows-shell := ["powershell.exe", "-NoLogo", "-Command"]
```

Boolean settings: `set NAME` is equivalent to `set NAME := true`.

## Variables and Expressions

### Assignment
```just
version := "1.0.0"
commit  := `git rev-parse --short HEAD`   # backtick captures stdout
tmpdir  := `mktemp -d`
```

### String Types
```just
single := 'no escape sequences'
double := "supports \n \t \\ \""
triple := '''
  indented multiline
  common indent stripped
'''
shell_expanded := x'~/$FOO/${BAR}'         # expands env vars and ~
format_str     := f'version={{version}}'   # inline interpolation (1.44+)
```

### Operators
```just
joined := "foo" + "bar"           # concatenation: "foobar"
path   := "src" / "main.rs"      # path join: "src/main.rs"
maybe  := '' || 'fallback'       # logical OR (unstable)
both   := 'a' && 'b'             # logical AND (unstable)
```

### Conditionals
```just
mode := if env('CI', '') != '' { "release" } else { "debug" }

# operators: ==, !=, =~ (regex match)
foo := if version =~ '^\d+\.\d+' { "semver" } else { "other" }

# chained
bar := if os() == "linux" {
  "apt"
} else if os() == "macos" {
  "brew"
} else {
  error("unsupported OS: " + os())
}
```

### Command-line Overrides
```just
# just version=2.0.0 build
version := "1.0.0"
build:
    echo {{version}}
```

## Recipe Syntax

### Basic
```just
recipe-name:
    command1
    command2
```

### With Parameters
```just
build target mode='debug':           # positional with default
    cargo build --target {{target}} {{ if mode == "release" { "--release" } else { "" } }}

backup +FILES:                        # variadic, one or more
    scp {{FILES}} server:

commit MESSAGE *FLAGS:                # variadic, zero or more
    git commit {{FLAGS}} -m "{{MESSAGE}}"

serve $PORT="8080":                   # exported as env var
    python -m http.server $PORT
```

### Dependencies
```just
test: build                           # build runs first
build:
    make

deploy: build && notify cleanup       # notify, cleanup run after deploy
    ./deploy.sh

default: (build "main")              # pass args to dependency
build target:
    make {{target}}
```

### Line Prefixes
```just
recipe:
    @echo "quiet — line not echoed"   # @ suppresses echo
    -failing-command                   # - ignores errors
```

### Quiet Recipes
```just
@recipe:                              # invert: only @-prefixed lines echo
    echo "not echoed"
    @echo "this IS echoed"
```

## Attributes

```just
[private]                    # hidden from --list
[no-cd]                      # don't cd to justfile dir
[no-exit-message]            # suppress error message on failure
[no-quiet]                   # override global `set quiet`
[confirm]                    # require confirmation before running
[confirm("Are you sure?")]   # custom confirmation prompt
[doc('Do the thing')]        # explicit doc comment
[group('dev')]               # group in --list output
[linux]                      # only run on linux
[macos]                      # only run on macos
[unix]                       # only run on unix (includes macos)
[windows]                    # only run on windows
[script]                     # run as script (uses script-interpreter)
[script('python3')]          # run as script with specific interpreter
[extension('.py')]           # set script file extension
[positional-arguments]       # per-recipe positional args
[default]                    # use as module's default recipe
[working-directory: 'sub']   # per-recipe working dir
[parallel]                   # run dependencies in parallel

# multiple attributes
[no-cd, private, group('internal')]
helper:
    echo "hidden helper"
```

### Argument Attributes (1.45+)
```just
[arg('n', pattern='\d+')]               # validate with regex
[arg('bar', long="bar")]                # --bar option
[arg('v', short="v")]                   # -v option
[arg('force', long, value="true")]      # --force flag (no value)
[arg('target', help="Build target")]    # help text for --usage
```

## Shebang and Script Recipes

### Shebang
```just
python-task:
    #!/usr/bin/env python3
    import json
    print(json.dumps({"status": "ok"}))

safe-bash:
    #!/usr/bin/env bash
    set -euxo pipefail
    echo "safe bash recipe"
```

### Script Attribute
```just
[script('bash')]
deploy:
    set -euo pipefail
    echo "deploying..."
    ./deploy.sh

[script('python3')]
analyze:
    import sys
    print(f"Python {sys.version}")
```

## Built-in Functions

### System Info
```just
arch()          # "x86_64", "aarch64", etc.
os()            # "linux", "macos", "windows", etc.
os_family()     # "unix" or "windows"
num_cpus()      # number of logical CPUs
```

### Environment
```just
env('KEY')                   # get env var (error if missing)
env('KEY', 'default')        # get env var with fallback
```

### Paths and Directories
```just
justfile()                   # path to current justfile
justfile_directory()         # dir containing justfile
source_file()                # path of current source (for imports/modules)
source_directory()           # dir of current source
invocation_directory()       # where `just` was called from
home_directory()             # user home dir
config_directory()           # user config dir
cache_directory()            # user cache dir
data_directory()             # user data dir
```

### Path Manipulation
```just
absolute_path("./foo")       # resolve to absolute
canonicalize("./foo/../bar") # resolve symlinks too
extension("foo.tar.gz")      # "gz"
file_name("/a/b.txt")        # "b.txt"
file_stem("/a/b.txt")        # "b"
parent_directory("/a/b")     # "/a"
without_extension("b.txt")   # "b"
clean("a//b/../c")           # "a/c"
join("a", "b", "c")          # "a/b/c" (uses OS separator)
```

### String Functions
```just
uppercase("foo")             # "FOO"
lowercase("BAR")             # "bar"
trim("  hi  ")               # "hi"
trim_start("  hi")           # "hi"
trim_end("hi  ")             # "hi"
replace("aab", "a", "x")    # "xxb"
replace_regex("foo123", '\d+', "N")  # "fooN"
quote("it's")                # "'it'\\''s'"
kebabcase("fooBar")          # "foo-bar"
snakecase("fooBar")          # "foo_bar"
capitalize("hello")          # "Hello"
```

### Filesystem
```just
path_exists("/some/path")   # "true" or "false"
read("version.txt")         # file contents as string
```

### Other
```just
error("something broke")    # abort with message
uuid()                      # random UUID v4
sha256("string")             # SHA-256 hash
blake3("string")             # BLAKE3 hash
sha256_file("path")          # hash of file
choose('16', HEX)            # random hex string
datetime("%Y-%m-%d")         # local datetime
datetime_utc("%H:%M:%S")    # UTC datetime
just_executable()            # path to just binary
just_pid()                   # PID of just process
require("node")              # full path or error
which("node")                # full path or "" (unstable)
shell('echo $1', 'arg')      # run command, return stdout
```

### Useful Constants
```just
HEX           # "0123456789abcdef"
HEXUPPER      # "0123456789ABCDEF"
PATH_SEP      # "/" or "\" on windows
BOLD          # "\e[1m"
NORMAL        # "\e[0m"
RED, GREEN, YELLOW, BLUE, CYAN, MAGENTA, WHITE, BLACK  # foreground colors
BG_RED, BG_GREEN, BG_YELLOW, BG_BLUE  # background colors
```

## Modules and Imports

### Imports (merge into current namespace)
```just
import 'lib/common.just'       # required
import? 'local-overrides.just' # optional
```

### Modules (separate namespace)
```just
mod docker                      # searches docker.just, docker/mod.just, etc.
mod ci 'ci/pipeline.just'      # explicit path
mod? optional_mod               # no error if missing

# doc comment for --list
# Docker build and deploy recipes
mod docker
```

Invoke module recipes: `just docker build` or `just docker::build`

## Escaping and Interpolation

- `{{variable}}` — substitute variable/expression in recipe body
- `{{{{` — literal `{{` in recipe body
- `@` before a line — suppress echo
- `-` before a line — ignore errors
- `\` at end of line — continuation (outside recipes, 1.15+)

## Aliases

```just
alias b := build
alias t := test
alias d := docker::build   # alias to module recipe
```
