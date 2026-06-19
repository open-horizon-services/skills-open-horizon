#!/usr/bin/env bash
# install-skills.sh
# Copies the .agent folder contents from skills-open-horizon into the current directory.

set -e

REPO_URL="https://github.com/open-horizon-services/skills-open-horizon.git"
TMP_DIR=$(mktemp -d)

cleanup() {
  rm -rf "$TMP_DIR"
}
trap cleanup EXIT

echo "Cloning skills-open-horizon..."
git clone --depth 1 "$REPO_URL" "$TMP_DIR"

echo "Copying .agent contents..."
cp -r "$TMP_DIR/.agent/." ./.agent/

echo "Done. .agent contents have been installed into $(pwd)/.agent"
