#!/usr/bin/env bash
# Commit and push the dashboard to GitHub Pages.
# Usage: ./deploy.sh "optional commit message"
set -euo pipefail

MSG="${1:-Weekly AR dashboard refresh $(date +%Y-%m-%d)}"

cd "$(dirname "$0")"

if [ ! -d .git ]; then
  echo "No .git found in $(pwd). Run:"
  echo "  git init && git branch -M main"
  echo "  git remote add origin https://github.com/<you>/aviva-ar-dashboard.git"
  exit 1
fi

git add -A
if git diff --cached --quiet; then
  echo "No changes to commit."
  exit 0
fi

git commit -m "$MSG"
git push origin main
echo "Deployed: https://$(git config user.name).github.io/$(basename "$(git rev-parse --show-toplevel)")/"
