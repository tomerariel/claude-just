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

# validate plugin.json is well-formed
check-plugin:
    @jq empty .claude-plugin/plugin.json && echo 'plugin.json: ok'

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
