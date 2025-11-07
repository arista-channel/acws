#!/bin/bash

# 🔄 Branch Switching Aliases for Campus Workshop
# Source this file to get convenient aliases: source scripts/branch-aliases.sh

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

# Branch switching aliases
alias to-main='./scripts/switch-branch.sh main'
alias to-gh-pages='./scripts/switch-branch.sh gh-pages'
alias branch-status='./scripts/switch-branch.sh status'

# Quick navigation aliases
alias edit-docs='./scripts/switch-branch.sh main && echo "📝 Ready to edit docs/ files"'
alias view-site='./scripts/switch-branch.sh gh-pages && echo "🌐 Viewing built HTML files"'

# Deployment aliases
alias quick-deploy='./scripts/quick-deploy.sh both'
alias deploy-github='./scripts/quick-deploy.sh github'
alias deploy-nginx='./scripts/quick-deploy.sh nginx'

# Orlando protection aliases
alias protect-orlando='./scripts/protect-orlando.sh verify'
alias restore-orlando='./scripts/protect-orlando.sh restore'

# Git status with branch info
alias git-status='echo -e "${CYAN}🌿 Branch: $(git branch --show-current)${NC}" && git status'

echo -e "${GREEN}✅ Campus Workshop aliases loaded!${NC}"
echo ""
echo -e "${BLUE}📋 Available aliases:${NC}"
echo "   🔄 Branch Switching:"
echo "      to-main          - Switch to main branch (source files)"
echo "      to-gh-pages      - Switch to gh-pages branch (built HTML)"
echo "      branch-status    - Show current branch status"
echo ""
echo "   📝 Quick Navigation:"
echo "      edit-docs        - Switch to main and ready for editing"
echo "      view-site        - Switch to gh-pages to view built site"
echo ""
echo "   🚀 Deployment:"
echo "      quick-deploy     - Deploy to both GitHub Pages and nginx"
echo "      deploy-github    - Deploy to GitHub Pages only"
echo "      deploy-nginx     - Deploy to nginx server only"
echo ""
echo "   🛡️ Orlando Protection:"
echo "      protect-orlando  - Verify Orlando version integrity"
echo "      restore-orlando  - Restore Orlando from backup"
echo ""
echo "   📊 Git Status:"
echo "      git-status       - Show git status with branch info"
echo ""
echo -e "${BLUE}💡 Usage: Just type the alias name, e.g., 'to-main'${NC}"
