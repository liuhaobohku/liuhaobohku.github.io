#!/usr/bin/env bash
set -euo pipefail

if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  echo "Error: please run this script inside your website git repository."
  exit 1
fi

repo_root="$(git rev-parse --show-toplevel)"
cd "$repo_root"

echo "Website repository:"
echo "  $repo_root"
echo

if [[ -z "$(git status --short)" ]]; then
  echo "No local changes to publish."
  exit 0
fi

echo "Local changes:"
git status --short
echo

read -r -p "Commit message [Update website]: " commit_message
commit_message="${commit_message:-Update website}"

echo
echo "Staging changes..."
git add -A

echo "Creating commit..."
git commit -m "$commit_message"

current_branch="$(git branch --show-current)"
if [[ -z "$current_branch" ]]; then
  echo "Error: cannot determine current branch."
  exit 1
fi

echo
echo "Pushing to origin/$current_branch..."
git push origin "$current_branch"

echo
echo "Done. GitHub Pages should update in a few minutes:"
echo "  https://liuhaobohku.github.io/"
