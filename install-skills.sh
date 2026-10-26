#!/usr/bin/env bash
# Installs the shared skills-open-horizon configuration into the current directory.

set -euo pipefail

REPO_URL="${REPO_URL:-https://github.com/open-horizon-services/skills-open-horizon.git}"
TMP_DIR=$(mktemp -d)

cleanup() {
  rm -rf "$TMP_DIR"
}
trap cleanup EXIT

fail() {
  printf 'Error: %s\n' "$1" >&2
  exit 1
}

merge_tree() {
  local source_root="$1"
  local destination_root="$2"
  local source_path relative_path destination_path destination_parent symlink_path

  [ -d "$source_root" ] || fail "Expected source directory at $source_root"
  if [ -L "$destination_root" ] || { [ -e "$destination_root" ] && [ ! -d "$destination_root" ]; }; then
    fail "Cannot install into $destination_root because it is not a regular directory"
  fi

  symlink_path=$(find "$source_root" -type l -print -quit)
  [ -z "$symlink_path" ] || fail "Cannot safely merge symbolic link $symlink_path"

  mkdir -p "$destination_root"
  while IFS= read -r -d '' source_path; do
    relative_path="${source_path#"$source_root"/}"
    destination_path="$destination_root/$relative_path"
    destination_parent=$(dirname "$destination_path")

    if [ -L "$destination_parent" ] || { [ -e "$destination_parent" ] && [ ! -d "$destination_parent" ]; }; then
      fail "Cannot safely install $destination_path because its parent path is not a regular directory"
    fi
    mkdir -p "$destination_parent"

    if [ -e "$destination_path" ] || [ -L "$destination_path" ]; then
      if [ -f "$destination_path" ] && cmp -s "$source_path" "$destination_path"; then
        continue
      fi
      fail "Conflicting file at $destination_path; existing content was preserved"
    fi
    cp -p "$source_path" "$destination_path"
  done < <(find "$source_root" -type f -print0)
}

ensure_shared_skill_link() {
  local link_path="$1"
  local current_target

  mkdir -p "$(dirname "$link_path")"
  if [ -L "$link_path" ]; then
    current_target=$(readlink "$link_path")
    [ "$current_target" = "../.agents/skills" ] || fail "Conflicting symbolic link at $link_path; expected ../.agents/skills"
    return
  fi

  if [ -e "$link_path" ]; then
    [ -d "$link_path" ] || fail "Cannot replace $link_path because it is not a directory"
    merge_tree "$link_path" "$PWD/.agents/skills"
    rm -rf "$link_path"
  fi
  ln -s ../.agents/skills "$link_path"
}

echo "Cloning skills-open-horizon..."
git clone --depth 1 "$REPO_URL" "$TMP_DIR/repository"

echo "Merging canonical .agents configuration..."
merge_tree "$TMP_DIR/repository/.agents" "$PWD/.agents"

echo "Installing Bob commands..."
mkdir -p "$PWD/.bob/commands"
cp -R "$TMP_DIR/repository/.bob/commands/." "$PWD/.bob/commands/"

echo "Linking tool skill directories to .agents/skills..."
ensure_shared_skill_link "$PWD/.bob/skills"
ensure_shared_skill_link "$PWD/.claude/skills"

echo "Done. Shared skills are available in $(pwd)/.agents/skills, .bob/skills, and .claude/skills."
