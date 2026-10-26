#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR=$(cd "$(dirname "$0")/.." && pwd)
INSTALLER="$ROOT_DIR/install-skills.sh"
TEST_ROOT=$(mktemp -d)
trap 'rm -rf "$TEST_ROOT"' EXIT

UPSTREAM="$TEST_ROOT/upstream"
mkdir -p "$UPSTREAM/.agents/skills/upstream-skill" \
  "$UPSTREAM/.agents/workflows" \
  "$UPSTREAM/.bob/commands"
printf 'upstream skill\n' > "$UPSTREAM/.agents/skills/upstream-skill/SKILL.md"
printf 'workflow\n' > "$UPSTREAM/.agents/workflows/setup.md"
printf 'command\n' > "$UPSTREAM/.bob/commands/setup.md"
git -C "$UPSTREAM" init -q
git -C "$UPSTREAM" config user.name "Installer Test"
git -C "$UPSTREAM" config user.email "installer-test@example.invalid"
git -C "$UPSTREAM" add .
git -C "$UPSTREAM" commit -qm "Create installer fixture"

assert_linked_skill_tree() {
  local target="$1"
  [ -L "$target/.bob/skills" ]
  [ -L "$target/.claude/skills" ]
  [ "$(readlink "$target/.bob/skills")" = "../.agents/skills" ]
  [ "$(readlink "$target/.claude/skills")" = "../.agents/skills" ]
  cmp -s "$target/.agents/skills/upstream-skill/SKILL.md" "$target/.bob/skills/upstream-skill/SKILL.md"
  cmp -s "$target/.agents/skills/upstream-skill/SKILL.md" "$target/.claude/skills/upstream-skill/SKILL.md"
}

CLEAN_TARGET="$TEST_ROOT/clean-target"
mkdir -p "$CLEAN_TARGET/.bob/commands" \
  "$CLEAN_TARGET/.bob/skills/local-bob" \
  "$CLEAN_TARGET/.claude/commands" \
  "$CLEAN_TARGET/.claude/skills/local-claude"
printf 'local bob skill\n' > "$CLEAN_TARGET/.bob/skills/local-bob/SKILL.md"
printf 'local claude skill\n' > "$CLEAN_TARGET/.claude/skills/local-claude/SKILL.md"
printf 'keep bob command\n' > "$CLEAN_TARGET/.bob/commands/local.md"
printf 'keep claude command\n' > "$CLEAN_TARGET/.claude/commands/local.md"

(cd "$CLEAN_TARGET" && REPO_URL="$UPSTREAM" bash "$INSTALLER" >/dev/null)
assert_linked_skill_tree "$CLEAN_TARGET"
cmp -s "$CLEAN_TARGET/.agents/skills/local-bob/SKILL.md" "$CLEAN_TARGET/.bob/skills/local-bob/SKILL.md"
cmp -s "$CLEAN_TARGET/.agents/skills/local-claude/SKILL.md" "$CLEAN_TARGET/.claude/skills/local-claude/SKILL.md"
[ -f "$CLEAN_TARGET/.agents/workflows/setup.md" ]
[ -f "$CLEAN_TARGET/.bob/commands/local.md" ]
[ -f "$CLEAN_TARGET/.claude/commands/local.md" ]

(cd "$CLEAN_TARGET" && REPO_URL="$UPSTREAM" bash "$INSTALLER" >/dev/null)
assert_linked_skill_tree "$CLEAN_TARGET"

CONFLICT_TARGET="$TEST_ROOT/conflict-target"
mkdir -p "$CONFLICT_TARGET/.bob/skills/upstream-skill"
printf 'user-owned skill\n' > "$CONFLICT_TARGET/.bob/skills/upstream-skill/SKILL.md"
if (cd "$CONFLICT_TARGET" && REPO_URL="$UPSTREAM" bash "$INSTALLER" > "$TEST_ROOT/conflict.log" 2>&1); then
  printf '%s\n' "Expected installer to reject a conflicting Bob skill path" >&2
  exit 1
fi
grep -q "$CONFLICT_TARGET/.agents/skills/upstream-skill/SKILL.md" "$TEST_ROOT/conflict.log"
grep -q 'user-owned skill' "$CONFLICT_TARGET/.bob/skills/upstream-skill/SKILL.md"
[ -d "$CONFLICT_TARGET/.bob/skills" ] && [ ! -L "$CONFLICT_TARGET/.bob/skills" ]

printf '%s\n' "Installer tests passed."
