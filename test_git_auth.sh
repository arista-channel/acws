#!/bin/bash

# Test Git Authentication Script
echo "🔐 Testing Git Authentication..."
echo "================================"

# Check current remote URL
echo "📡 Current remote URL:"
git remote -v

echo ""
echo "👤 Git user configuration:"
git config user.name
git config user.email

echo ""
echo "🧪 Testing GitHub connection..."

# Test with a simple fetch (doesn't modify anything)
if git fetch origin --dry-run 2>/dev/null; then
    echo "✅ GitHub authentication successful!"
    echo "🚀 Ready to push/deploy documentation"
else
    echo "❌ GitHub authentication failed"
    echo ""
    echo "💡 Solutions:"
    echo "1. Update remote URL with token:"
    echo "   git remote set-url origin https://mbalagot12:YOUR_TOKEN@github.com/mbalagot12/campus-workshop.git"
    echo ""
    echo "2. Or use credential manager:"
    echo "   git config --global credential.helper store"
    echo "   # Then Git will prompt for credentials on next push"
    echo ""
    echo "3. Verify your token has 'repo' and 'workflow' permissions"
fi

echo ""
echo "🔍 Current branch:"
git branch --show-current

echo ""
echo "📊 Git status:"
git status --porcelain
