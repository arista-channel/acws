#!/bin/bash

# Setup SSH Key for Campus Workshop CI/CD Pipeline
# This script helps you add the mb-partner-kp.pem key to GitHub secrets

set -e

echo "🔑 Campus Workshop SSH Key Setup"
echo "================================="
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

# Check if key file exists
KEY_PATH="$HOME/Documents/MyKeyPairs/mb-partner-kp.pem"

if [ ! -f "$KEY_PATH" ]; then
    print_error "SSH key not found at: $KEY_PATH"
    exit 1
fi

print_status "Found SSH key: $KEY_PATH"

# Check key permissions
KEY_PERMS=$(stat -f "%A" "$KEY_PATH")
if [ "$KEY_PERMS" != "600" ]; then
    print_warning "Key permissions are $KEY_PERMS, should be 600"
    echo "Fixing permissions..."
    chmod 600 "$KEY_PATH"
    print_status "Key permissions fixed to 600"
else
    print_status "Key permissions are correct (600)"
fi

# Test SSH connection
echo ""
print_info "Testing SSH connection to ec2-3-148-13-216.us-east-2.compute.amazonaws.com..."

if ssh -i "$KEY_PATH" -o ConnectTimeout=10 -o BatchMode=yes ubuntu@ec2-3-148-13-216.us-east-2.compute.amazonaws.com "echo 'Connection test successful'" 2>/dev/null; then
    print_status "SSH connection successful!"
else
    print_warning "SSH connection failed (server may be down or network issue)"
    print_info "This is normal if the server is not currently running"
fi

# Display key content for copying
echo ""
echo "🔐 SSH Key Content for GitHub Secrets"
echo "====================================="
echo ""
print_info "Copy the ENTIRE content below (including BEGIN/END lines):"
echo ""
echo "--- START COPYING FROM HERE ---"
cat "$KEY_PATH"
echo "--- END COPYING HERE ---"
echo ""

# Instructions for adding to GitHub
echo ""
echo "📋 GitHub Secrets Setup Instructions"
echo "===================================="
echo ""
print_info "1. Go to your GitHub repository:"
echo "   https://github.com/mbalagot12/campus-workshop/settings/secrets/actions"
echo ""
print_info "2. Click 'New repository secret'"
echo ""
print_info "3. Enter the secret details:"
echo "   Name: NGINX_SERVER_SSH_KEY"
echo "   Value: [Paste the key content from above]"
echo ""
print_info "4. Click 'Add secret'"
echo ""

# Verification steps
echo ""
echo "🧪 Verification Steps"
echo "===================="
echo ""
print_info "After adding the secret to GitHub:"
echo ""
echo "1. 🔄 Commit and push the pipeline files:"
echo "   git add .github/ *.md setup-*.sh"
echo "   git commit -m 'Add CI/CD pipeline with SSH key authentication'"
echo "   git push origin main"
echo ""
echo "2. 🧪 Test the pipeline with dry run:"
echo "   - Go to GitHub Actions"
echo "   - Select 'Deploy Campus Workshop Documentation'"
echo "   - Click 'Run workflow'"
echo "   - Set version: 2025.2.NAS"
echo "   - Check 'Dry run' option"
echo "   - Run workflow"
echo ""
echo "3. ✅ If dry run succeeds, run without dry run option"
echo ""

# Security reminder
echo ""
echo "🔒 Security Reminder"
echo "==================="
echo ""
print_warning "IMPORTANT: Keep your private key secure!"
echo "- ✅ The key is stored locally with correct permissions (600)"
echo "- ✅ GitHub secrets are encrypted and secure"
echo "- ❌ Never share the private key content publicly"
echo "- ❌ Never commit the private key to git repositories"
echo ""

# Server information
echo ""
echo "🖥️  Server Information"
echo "====================="
echo ""
echo "Server: ec2-3-148-13-216.us-east-2.compute.amazonaws.com"
echo "User: ubuntu"
echo "Key: mb-partner-kp.pem"
echo "Deployment Path: /var/www/campus-workshop"
echo ""

print_status "SSH key setup instructions complete!"
print_info "Next: Add the key to GitHub secrets and test the pipeline"

echo ""
echo "🌐 Quick Links:"
echo "==============="
echo "📊 GitHub Actions: https://github.com/mbalagot12/campus-workshop/actions"
echo "🔐 GitHub Secrets: https://github.com/mbalagot12/campus-workshop/settings/secrets/actions"
echo "📖 Pipeline Guide: ./CI_CD_PIPELINE.md"
echo "🚀 Quick Reference: ./PIPELINE_QUICK_REFERENCE.md"
echo ""

print_status "Ready to deploy with SSH key authentication! 🔑🚀✨"
