#!/bin/bash

# Campus Workshop CI/CD Pipeline Setup Script
# This script helps configure the CI/CD pipeline for the campus-workshop project

set -e

echo "🚀 Campus Workshop CI/CD Pipeline Setup"
echo "========================================"
echo ""

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

print_info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

# Check if we're in the right directory
if [ ! -f "mkdocs.yml" ] || [ ! -d "docs" ]; then
    print_error "This script must be run from the campus-workshop root directory"
    exit 1
fi

print_status "Found campus-workshop project structure"

# Check if .github/workflows directory exists
if [ ! -d ".github/workflows" ]; then
    print_error "GitHub workflows directory not found. Please ensure CI/CD files are in place."
    exit 1
fi

print_status "GitHub workflows directory found"

# Check for required workflow files
REQUIRED_WORKFLOWS=(
    ".github/workflows/deploy-docs.yml"
    ".github/workflows/deploy-nginx.yml"
    ".github/workflows/test-docs.yml"
    ".github/workflows/maintenance.yml"
)

for workflow in "${REQUIRED_WORKFLOWS[@]}"; do
    if [ -f "$workflow" ]; then
        print_status "Found: $(basename $workflow)"
    else
        print_error "Missing: $workflow"
        exit 1
    fi
done

# Check Python environment
echo ""
echo "🐍 Checking Python Environment"
echo "==============================="

if [ -d ".venv" ]; then
    print_status "Virtual environment found"
    
    # Activate virtual environment
    source .venv/bin/activate
    
    # Check if mike is installed
    if command -v mike &> /dev/null; then
        print_status "Mike versioning tool is installed"
        
        # Check current versions
        echo ""
        print_info "Current Mike versions:"
        mike list || print_warning "No versions found (this is normal for new setups)"
    else
        print_error "Mike versioning tool not found. Please install requirements:"
        echo "  uv pip install -r requirements.txt"
        exit 1
    fi
else
    print_error "Virtual environment not found. Please set up the environment:"
    echo "  uv venv .venv"
    echo "  source .venv/bin/activate"
    echo "  uv pip install -r requirements.txt"
    exit 1
fi

# Check for Orlando protection
echo ""
echo "🛡️ Checking Orlando Protection"
echo "==============================="

# Check if Orlando data exists
if [ -f "data/orlando_lab_assignment.csv" ]; then
    print_status "Orlando lab assignment data found"
else
    print_warning "Orlando lab assignment data not found"
    print_info "This is required for Orlando 2025.1.ORL version"
fi

# Check if Orlando topology exists
if [ -f "docs/assets/images/topology/atd_student-light_orlando.png" ]; then
    print_status "Orlando topology image found"
else
    print_warning "Orlando topology image not found"
    print_info "This is required for Orlando 2025.1.ORL version"
fi

# Test MkDocs build
echo ""
echo "🔨 Testing MkDocs Build"
echo "========================"

if mkdocs build --strict; then
    print_status "MkDocs build successful"
    
    # Clean up test build
    rm -rf site
else
    print_error "MkDocs build failed. Please fix configuration issues."
    exit 1
fi

# Check Git configuration
echo ""
echo "📝 Checking Git Configuration"
echo "=============================="

if git config user.name &> /dev/null && git config user.email &> /dev/null; then
    print_status "Git user configuration found"
    print_info "User: $(git config user.name) <$(git config user.email)>"
else
    print_warning "Git user not configured. Setting up for pipeline testing..."
    git config user.name "Pipeline Test"
    git config user.email "pipeline@example.com"
    print_status "Git user configured for testing"
fi

# Check remote repository
if git remote get-url origin &> /dev/null; then
    REMOTE_URL=$(git remote get-url origin)
    print_status "Git remote configured: $REMOTE_URL"
    
    # Extract repository info
    if [[ $REMOTE_URL =~ github\.com[:/]([^/]+)/([^/]+)(\.git)?$ ]]; then
        REPO_OWNER="${BASH_REMATCH[1]}"
        REPO_NAME="${BASH_REMATCH[2]}"
        print_info "Repository: $REPO_OWNER/$REPO_NAME"
    fi
else
    print_error "Git remote not configured. Please add GitHub remote:"
    echo "  git remote add origin git@github.com:USERNAME/campus-workshop.git"
    exit 1
fi

# SSH Key Setup Instructions
echo ""
echo "🔑 SSH Key Setup for mb-acws1"
echo "=============================="

print_info "To complete the pipeline setup, you need to:"
echo ""
echo "1. 📋 Copy your SSH private key for ec2-3-148-13-216.us-east-2.compute.amazonaws.com server"
echo "2. 🔐 Add it as a GitHub secret named: NGINX_SERVER_SSH_KEY"
echo "3. 🌐 Go to: https://github.com/$REPO_OWNER/$REPO_NAME/settings/secrets/actions"
echo "4. ➕ Click 'New repository secret'"
echo "5. 📝 Name: NGINX_SERVER_SSH_KEY"
echo "6. 📄 Value: [Paste your private key content]"
echo ""

# Test SSH connection (if possible)
print_info "Testing SSH connection to ec2-3-148-13-216.us-east-2.compute.amazonaws.com..."
if ssh -o ConnectTimeout=5 -o BatchMode=yes ubuntu@ec2-3-148-13-216.us-east-2.compute.amazonaws.com "echo 'SSH connection successful'" 2>/dev/null; then
    print_status "SSH connection to ec2-3-148-13-216.us-east-2.compute.amazonaws.com successful"
else
    print_warning "Cannot connect to ec2-3-148-13-216.us-east-2.compute.amazonaws.com (this is normal if not on the same network)"
    print_info "The pipeline will handle SSH connections using the configured key"
fi

# Pipeline Testing Instructions
echo ""
echo "🧪 Pipeline Testing"
echo "==================="

print_info "To test the pipeline:"
echo ""
echo "1. 🔄 Commit and push the workflow files:"
echo "   git add .github/"
echo "   git commit -m 'Add CI/CD pipeline with Orlando protection'"
echo "   git push origin main"
echo ""
echo "2. 🧪 Test with dry run:"
echo "   - Go to GitHub Actions"
echo "   - Select 'Deploy Campus Workshop Documentation'"
echo "   - Click 'Run workflow'"
echo "   - Set version: 2025.2.NAS (NOT 2025.1.ORL)"
echo "   - Check 'Dry run' option"
echo "   - Run the workflow"
echo ""
echo "3. ✅ If dry run succeeds, run without dry run option"
echo ""

# Orlando Protection Reminder
echo ""
echo "🛡️ CRITICAL: Orlando Protection Reminder"
echo "========================================"

print_error "NEVER deploy to version 2025.1.ORL"
print_error "Orlando 2025.1.ORL is historically protected!"
echo ""
print_info "Safe versions to deploy:"
echo "  ✅ 2025.2.NAS - Nashville Workshop"
echo "  ✅ 2025.3.TOR - Toronto Workshop"
echo "  ✅ 2025.4.ATL - Atlanta Workshop"
echo "  ✅ 2025.5.BAY - Bay Area Workshop"
echo "  ✅ 2025.X.XXX - Future workshops"
echo ""
print_error "Protected version (DO NOT USE):"
echo "  ❌ 2025.1.ORL - Orlando Historical"
echo ""

# Final Summary
echo ""
echo "📋 Setup Summary"
echo "================"

print_status "✅ Project structure verified"
print_status "✅ GitHub workflows installed"
print_status "✅ Python environment ready"
print_status "✅ MkDocs build tested"
print_status "✅ Git configuration checked"
echo ""
print_warning "⚠️  Still needed:"
echo "  🔐 Add NGINX_SERVER_SSH_KEY to GitHub secrets"
echo "  🧪 Test pipeline with dry run"
echo "  🚀 Deploy to non-Orlando versions only"
echo ""

print_status "🎉 Campus Workshop CI/CD Pipeline setup complete!"
print_info "📖 See CI_CD_PIPELINE.md for detailed usage instructions"

echo ""
echo "🌐 Useful URLs:"
echo "==============="
if [ -n "$REPO_OWNER" ] && [ -n "$REPO_NAME" ]; then
    echo "📊 GitHub Actions: https://github.com/$REPO_OWNER/$REPO_NAME/actions"
    echo "🔐 Secrets: https://github.com/$REPO_OWNER/$REPO_NAME/settings/secrets/actions"
    echo "🌐 GitHub Pages: https://$REPO_OWNER.github.io/$REPO_NAME/"
fi
echo "🖥️  Nginx Server: http://ec2-3-148-13-216.us-east-2.compute.amazonaws.com/"
echo ""

print_status "Setup script completed successfully! 🚀✨🛡️"
