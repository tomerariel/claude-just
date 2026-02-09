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

# validate plugin.json and marketplace.json structure
check-plugin:
    @jq -e '.name // empty' .claude-plugin/plugin.json > /dev/null \
        || { echo 'error: plugin.json missing "name"' >&2; exit 1; }
    @jq -e '.description // empty' .claude-plugin/plugin.json > /dev/null \
        || { echo 'error: plugin.json missing "description"' >&2; exit 1; }
    @jq -e '.author.name // empty' .claude-plugin/plugin.json > /dev/null \
        || { echo 'error: plugin.json missing "author.name"' >&2; exit 1; }
    @jq -e '.version // empty | test("^[0-9]+\\.[0-9]+\\.[0-9]+$")' .claude-plugin/plugin.json > /dev/null \
        || { echo 'error: plugin.json missing "version" or not semver (x.y.z)' >&2; exit 1; }
    @jq -e '.name // empty' .claude-plugin/marketplace.json > /dev/null \
        || { echo 'error: marketplace.json missing "name"' >&2; exit 1; }
    @jq -e '.owner.name // empty' .claude-plugin/marketplace.json > /dev/null \
        || { echo 'error: marketplace.json missing "owner.name"' >&2; exit 1; }
    @jq -e '.plugins // empty | if type == "array" and length > 0 then true else false end' .claude-plugin/marketplace.json > /dev/null \
        || { echo 'error: marketplace.json "plugins" missing or not a non-empty array' >&2; exit 1; }
    @jq -e '.plugins[0].version // empty | test("^[0-9]+\\.[0-9]+\\.[0-9]+$")' .claude-plugin/marketplace.json > /dev/null \
        || { echo 'error: marketplace.json plugins[0].version missing or not semver (x.y.z)' >&2; exit 1; }
    @echo 'plugin.json: ok'
    @echo 'marketplace.json: ok'

# print the official just manual URL for cross-referencing
docs:
    @echo 'https://just.systems/man/en/'

# bump plugin version — just bump major|minor|patch
bump part:
    @current=$(jq -r '.plugins[0].version' .claude-plugin/marketplace.json) && \
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
    jq --arg v "$new" '.plugins[0].version = $v' .claude-plugin/marketplace.json > .claude-plugin/marketplace.tmp.json && \
    mv .claude-plugin/marketplace.tmp.json .claude-plugin/marketplace.json && \
    jq --arg v "$new" '.version = $v' .claude-plugin/plugin.json > .claude-plugin/plugin.tmp.json && \
    mv .claude-plugin/plugin.tmp.json .claude-plugin/plugin.json && \
    echo "$current → $new"
