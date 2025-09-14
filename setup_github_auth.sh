#!/bin/bash

# GitHub Authentication Setup Script
echo "🔐 GitHub Authentication Setup"
echo "=============================="

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

print_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if token is provided as argument
if [ -z "$1" ]; then
    echo ""
    print_warning "Usage: ./setup_github_auth.sh YOUR_PERSONAL_ACCESS_TOKEN"
    echo ""
    echo "📝 To create a Personal Access Token:"
    echo "   1. Go to: https://github.com/settings/tokens"
    echo "   2. Click 'Generate new token (classic)'"
    echo "   3. Select scopes: 'repo' and 'workflow'"
    echo "   4. Copy the token and run:"
    echo "      ./setup_github_auth.sh ghp_your_token_here"
    echo ""
    exit 1
fi

TOKEN="$1"

# Validate token format
if [[ ! "$TOKEN" =~ ^ghp_[a-zA-Z0-9]{36}$ ]]; then
    print_warning "Token format doesn't match expected pattern (ghp_...)"
    print_info "Proceeding anyway - token might be valid"
fi

print_info "Setting up GitHub authentication..."

# Method 1: Update remote URL with token
print_info "Updating remote URL with token..."
git remote set-url origin "https://mbalagot12:${TOKEN}@github.com/mbalagot12/campus-workshop.git"

if [ $? -eq 0 ]; then
    print_success "Remote URL updated successfully"
else
    print_error "Failed to update remote URL"
    exit 1
fi

# Test the authentication
print_info "Testing authentication..."
if git ls-remote origin HEAD > /dev/null 2>&1; then
    print_success "✅ GitHub authentication successful!"
    
    # Test push capability
    print_info "Testing push capability..."
    
    # Create a test commit (if there are changes)
    if [ -n "$(git status --porcelain)" ]; then
        print_info "Staging and committing current changes..."
        git add .
        git commit -m "Update documentation and version control"
        
        # Test push
        if git push origin main; then
            print_success "✅ Push successful!"
        else
            print_error "❌ Push failed - check token permissions"
            exit 1
        fi
    else
        print_info "No changes to commit - authentication setup complete"
    fi
    
else
    print_error "❌ Authentication failed"
    print_info "Please check:"
    print_info "  1. Token is valid and not expired"
    print_info "  2. Token has 'repo' and 'workflow' permissions"
    print_info "  3. You have write access to the repository"
    exit 1
fi

print_success "🎉 GitHub authentication setup complete!"
print_info "You can now run: ./mkdocs-version-control.sh"

# Clean up - remove the token from command history
history -d $(history 1 | awk '{print $1}') 2>/dev/null || true
