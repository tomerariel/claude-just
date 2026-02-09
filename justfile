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
