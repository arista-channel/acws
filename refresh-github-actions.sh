#!/bin/bash

# GitHub Actions Refresh Script for Campus Workshop
# This script forces GitHub Actions to refresh and trigger workflows

set -e  # Exit on any error

echo "🔄 GITHUB ACTIONS REFRESH SCRIPT"
echo "================================="
echo ""

# Check if we're in a git repository
if ! git rev-parse --git-dir > /dev/null 2>&1; then
    echo "❌ Error: Not in a git repository"
    echo "Please run this script from the campus-workshop directory"
    exit 1
fi

# Check if we're on the main branch
CURRENT_BRANCH=$(git branch --show-current)
if [ "$CURRENT_BRANCH" != "main" ]; then
    echo "⚠️  Warning: You're on branch '$CURRENT_BRANCH', not 'main'"
    echo "Switching to main branch..."
    git checkout main
    git pull origin main
fi

echo "📋 Current status:"
echo "- Branch: $(git branch --show-current)"
echo "- Last commit: $(git log -1 --oneline)"
echo ""

# Method selection
echo "🔧 Select refresh method:"
echo "1. Quick refresh (empty commit)"
echo "2. Docs trigger (modify docs/index.md)"
echo "3. Both methods (recommended)"
echo "4. Force workflow file refresh"
echo ""
read -p "Choose method (1-4) [default: 3]: " METHOD
METHOD=${METHOD:-3}

case $METHOD in
    1)
        echo "🚀 Method 1: Empty commit refresh..."
        git commit --allow-empty -m "🔄 GitHub Actions refresh - $(date '+%Y-%m-%d %H:%M:%S')"
        ;;
    2)
        echo "📝 Method 2: Docs trigger refresh..."
        # Add a timestamp comment to docs/index.md
        TIMESTAMP="<!-- CI/CD Refresh: $(date '+%Y-%m-%d %H:%M:%S') -->"
        if grep -q "<!-- CI/CD Refresh:" docs/index.md; then
            # Replace existing timestamp
            sed -i.bak "s/<!-- CI\/CD Refresh:.*-->/$TIMESTAMP/" docs/index.md
            rm docs/index.md.bak 2>/dev/null || true
        else
            # Add new timestamp after the first line
            sed -i.bak "1a\\
$TIMESTAMP" docs/index.md
            rm docs/index.md.bak 2>/dev/null || true
        fi
        git add docs/index.md
        git commit -m "📝 Trigger GitHub Actions - Update docs timestamp

- Force docs change detection for workflow trigger
- Timestamp: $(date '+%Y-%m-%d %H:%M:%S')"
        ;;
    3)
        echo "🎯 Method 3: Both methods (recommended)..."
        # First, empty commit
        git commit --allow-empty -m "🔄 GitHub Actions refresh - $(date '+%Y-%m-%d %H:%M:%S')"
        
        # Then, docs change
        TIMESTAMP="<!-- CI/CD Refresh: $(date '+%Y-%m-%d %H:%M:%S') -->"
        if grep -q "<!-- CI/CD Refresh:" docs/index.md; then
            sed -i.bak "s/<!-- CI\/CD Refresh:.*-->/$TIMESTAMP/" docs/index.md
            rm docs/index.md.bak 2>/dev/null || true
        else
            sed -i.bak "1a\\
$TIMESTAMP" docs/index.md
            rm docs/index.md.bak 2>/dev/null || true
        fi
        git add docs/index.md
        git commit -m "📝 Force workflow trigger - Update docs timestamp

- Ensure docs/** path filter is triggered
- Double-trigger for maximum reliability
- Timestamp: $(date '+%Y-%m-%d %H:%M:%S')"
        ;;
    4)
        echo "🔧 Method 4: Force workflow file refresh..."
        WORKFLOW_COMMENT="# Workflow refresh: $(date '+%Y-%m-%d %H:%M:%S')"
        echo "$WORKFLOW_COMMENT" >> .github/workflows/deploy-docs.yml
        git add .github/workflows/deploy-docs.yml
        git commit -m "🔧 Force workflow file refresh

- Update workflow file to trigger GitHub Actions refresh
- Timestamp: $(date '+%Y-%m-%d %H:%M:%S')"
        ;;
    *)
        echo "❌ Invalid selection. Using method 3 (both methods)..."
        METHOD=3
        # Repeat method 3 logic here if needed
        ;;
esac

echo ""
echo "📤 Pushing changes to GitHub..."
git push origin main

echo ""
echo "✅ GitHub Actions refresh complete!"
echo ""
echo "📊 Next steps:"
echo "1. Check GitHub Actions: https://github.com/mbalagot12/campus-workshop/actions"
echo "2. Look for 'Deploy Campus Workshop Documentation' workflow"
echo "3. Monitor deployment progress"
echo ""
echo "🌐 Expected deployment targets:"
echo "- GitHub Pages: https://mbalagot12.github.io/campus-workshop/"
echo "- nginx Server: acws.duckdns.org"
echo ""
echo "⏱️  Typical deployment time: 3-5 minutes"
echo ""
echo "🎉 Done! Your GitHub Actions should now be refreshed and running."
