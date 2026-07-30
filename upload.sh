#!/usr/bin/env bash
set -e

export GH_PAGER=""

OWNER="zachdai"
REPO="zachdai.github.io"

gh repo delete "$OWNER/$REPO" --yes 2>/dev/null || true
gh repo create "$OWNER/$REPO" --public

rm -rf .git
git init
git add .
git commit -m "Initial commit"

git branch -M main
git remote add origin "https://github.com/$OWNER/$REPO.git"

git push -u origin main

gh api \
  --method PUT \
  "repos/$OWNER/$REPO/pages" \
  -f build_type=workflow