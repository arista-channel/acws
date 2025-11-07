#!/bin/bash

# 🔄 Branch Switching Utility for Campus Workshop
# Usage: ./scripts/switch-branch.sh [main|gh-pages|status]

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Functions
log_info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

log_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

log_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

log_error() {
    echo -e "${RED}❌ $1${NC}"
}

log_branch() {
    echo -e "${CYAN}🌿 $1${NC}"
}

show_current_status() {
    echo "🔍 **CURRENT BRANCH STATUS**"
    echo "=========================="
    
    # Show current branch
    local current_branch=$(git branch --show-current)
    log_branch "Current branch: $current_branch"
    
    echo ""
    echo "📁 **BRANCH PURPOSES:**"
    echo "   • main      - Source files (markdown, scripts, config)"
    echo "   • gh-pages  - Built HTML files (Mike versions)"
    
    echo ""
    echo "📋 **CURRENT DIRECTORY CONTENTS:**"
    if [[ "$current_branch" == "main" ]]; then
        echo "   📝 Source Files:"
        echo "      - docs/           (markdown content)"
        echo "      - mkdocs.yml      (configuration)"
        echo "      - data/           (CSV data files)"
        echo "      - scripts/        (deployment scripts)"
        
        # Show some key files
        if [[ -f "mkdocs.yml" ]]; then
            log_success "mkdocs.yml found ✓"
        fi
        if [[ -d "docs" ]]; then
            local md_count=$(find docs -name "*.md" | wc -l)
            log_success "docs/ directory with $md_count markdown files ✓"
        fi
        
    elif [[ "$current_branch" == "gh-pages" ]]; then
        echo "   🌐 Built HTML Files:"
        echo "      - 2025.4.ATL/     (Atlanta version)"
        echo "      - 2025.1.ORL/     (Orlando version)"
        echo "      - versions.json   (Mike version config)"
        echo "      - index.html      (site entry point)"
        
        # Show Mike versions
        if [[ -f "versions.json" ]]; then
            log_success "versions.json found ✓"
            echo "   📊 Mike Versions:"
            if command -v jq &> /dev/null; then
                jq -r '.[] | "      - \(.version) (\(.title))"' versions.json 2>/dev/null || \
                grep -o '"version":"[^"]*"' versions.json | sed 's/"version":"/      - /' | sed 's/"//'
            else
                ls -d 2025.* 2>/dev/null | sed 's/^/      - /' || echo "      - No version directories found"
            fi
        fi
    fi
    
    echo ""
    echo "🔄 **SWITCH COMMANDS:**"
    echo "   ./scripts/switch-branch.sh main      - Switch to source files"
    echo "   ./scripts/switch-branch.sh gh-pages  - Switch to built HTML"
    echo "   ./scripts/switch-branch.sh status    - Show this status"
}

switch_to_main() {
    log_info "Switching to main branch (source files)..."
    
    # Check for uncommitted changes
    if ! git diff --quiet || ! git diff --cached --quiet; then
        log_warning "You have uncommitted changes!"
        echo "Current changes:"
        git status --porcelain
        echo ""
        read -p "Continue switching? (y/N): " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            log_info "Switch cancelled"
            return 1
        fi
    fi
    
    git checkout main
    log_success "Switched to main branch"
    
    echo ""
    log_info "You can now edit:"
    echo "   📝 docs/*.md files (lab content)"
    echo "   📊 data/*.csv files (lab assignments)"
    echo "   🔧 mkdocs.yml (site configuration)"
    echo "   🚀 scripts/ (deployment tools)"
}

switch_to_gh_pages() {
    log_info "Switching to gh-pages branch (built HTML)..."
    
    # Check for uncommitted changes
    if ! git diff --quiet || ! git diff --cached --quiet; then
        log_warning "You have uncommitted changes!"
        echo "Current changes:"
        git status --porcelain
        echo ""
        read -p "Continue switching? (y/N): " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            log_info "Switch cancelled"
            return 1
        fi
    fi
    
    git checkout gh-pages
    log_success "Switched to gh-pages branch"
    
    echo ""
    log_info "You can now view:"
    echo "   🌐 Built HTML files"
    echo "   📊 Mike version structure"
    echo "   🔧 versions.json configuration"
    echo ""
    log_warning "⚠️  Don't edit HTML files directly!"
    log_warning "⚠️  Edit source files in main branch instead"
}

# Main execution
main() {
    local target=${1:-"status"}
    
    echo "🔄 Campus Workshop Branch Switcher"
    echo "=================================="
    
    # Check if we're in a git repository
    if ! git rev-parse --git-dir > /dev/null 2>&1; then
        log_error "Not in a git repository!"
        exit 1
    fi
    
    case $target in
        "main")
            switch_to_main
            echo ""
            show_current_status
            ;;
        "gh-pages")
            switch_to_gh_pages
            echo ""
            show_current_status
            ;;
        "status")
            show_current_status
            ;;
        *)
            log_error "Invalid target. Use: main, gh-pages, or status"
            echo ""
            echo "Usage: $0 [main|gh-pages|status]"
            echo ""
            echo "Commands:"
            echo "  main      - Switch to main branch (source files)"
            echo "  gh-pages  - Switch to gh-pages branch (built HTML)"
            echo "  status    - Show current branch status and file structure"
            exit 1
            ;;
    esac
}

# Run main function with all arguments
main "$@"
