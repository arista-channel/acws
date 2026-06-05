#!/bin/bash

# Quick GitHub Actions Trigger - One-liner for fast deployment
# Usage: ./quick-deploy.sh [optional commit message]

set -e

COMMIT_MSG="${1:-🚀 Quick deploy trigger - $(date '+%Y-%m-%d %H:%M:%S')}"

echo "🚀 Quick GitHub Actions trigger..."
echo "📝 Commit message: $COMMIT_MSG"

# Quick method: empty commit + push
git commit --allow-empty -m "$COMMIT_MSG"
git push origin main

echo "✅ Done! Check: https://github.com/mbalagot12/campus-workshop/actions"
