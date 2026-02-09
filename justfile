ref := "reference.md"

default:
    @just --list

# count approximate tokens in each skill and the reference
tokens:
    @echo "Approx tokens (chars/4):"
    @for f in skills/*/SKILL.md {{ ref }}; do chars=$(wc -c < "$f"); printf '  %5d  %s\n' $((chars / 4)) "$f"; done

# show what Claude sees when a skill is invoked (skill + reference)
preview skill:
    @cat skills/{{ skill }}/SKILL.md && echo "\n---\n" && cat {{ ref }}

# validate plugin.json structure and required marketplace fields
check-plugin:
    @jq -e '.name // empty' .claude-plugin/plugin.json > /dev/null \
        || { echo 'error: missing "name"' >&2; exit 1; }
    @jq -e '.description // empty' .claude-plugin/plugin.json > /dev/null \
        || { echo 'error: missing "description"' >&2; exit 1; }
    @jq -e '.version // empty | test("^[0-9]+\\.[0-9]+\\.[0-9]+$")' .claude-plugin/plugin.json > /dev/null \
        || { echo 'error: "version" missing or not semver (x.y.z)' >&2; exit 1; }
    @jq -e '.author.name // empty' .claude-plugin/plugin.json > /dev/null \
        || { echo 'error: missing "author.name"' >&2; exit 1; }
    @jq -e '.license // empty' .claude-plugin/plugin.json > /dev/null \
        || { echo 'error: missing "license"' >&2; exit 1; }
    @jq -e '.keywords // empty | if type == "array" and length > 0 then true else false end' .claude-plugin/plugin.json > /dev/null \
        || { echo 'error: "keywords" missing or not a non-empty array' >&2; exit 1; }
    @jq -e '.homepage // empty' .claude-plugin/plugin.json > /dev/null \
        || { echo 'error: missing "homepage"' >&2; exit 1; }
    @jq -e '.repository // empty' .claude-plugin/plugin.json > /dev/null \
        || { echo 'error: missing "repository"' >&2; exit 1; }
    @echo 'plugin.json: ok'

# print the official just manual URL for cross-referencing
docs:
    @echo 'https://just.systems/man/en/'

# bump plugin version — just bump major|minor|patch
bump part:
    @current=$(jq -r .version .claude-plugin/plugin.json) && \
    major=$(echo "$current" | cut -d. -f1) && \
    minor=$(echo "$current" | cut -d. -f2) && \
    patch=$(echo "$current" | cut -d. -f3) && \
    case "{{part}}" in \
        major) major=$((major + 1)); minor=0; patch=0 ;; \
        minor) minor=$((minor + 1)); patch=0 ;; \
        patch) patch=$((patch + 1)) ;; \
        *) echo "error: unknown part '{{part}}' — use major, minor, or patch" >&2; exit 1 ;; \
    esac && \
    new="$major.$minor.$patch" && \
    jq --arg v "$new" '.version = $v' .claude-plugin/plugin.json > .claude-plugin/plugin.tmp.json && \
    mv .claude-plugin/plugin.tmp.json .claude-plugin/plugin.json && \
    echo "$current → $new"
