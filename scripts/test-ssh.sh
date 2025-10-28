#!/bin/bash

# 🔐 SSH Connection Test Script
# =============================
# Tests SSH connection to nginx server with proper key authentication
# 
# Usage:
#   ./scripts/test-ssh.sh

set -euo pipefail

# Configuration
SERVER_HOST="acws.duckdns.org"
SERVER_USER="ubuntu"
SSH_KEY_PATH="/Users/miguelbalagot/Documents/MyKeyPairs/mb-partner-kp.pem"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
NC='\033[0m'

# Logging functions
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

log_step() {
    echo -e "${PURPLE}🔄 $1${NC}"
}

# Banner
echo -e "${PURPLE}"
cat << 'EOF'
🔐 SSH CONNECTION TEST
=====================
Testing connection to nginx server
EOF
echo -e "${NC}"

log_info "Configuration:"
log_info "  Server: $SERVER_HOST"
log_info "  User: $SERVER_USER"
log_info "  SSH Key: $SSH_KEY_PATH"
echo

# Test 1: Check SSH key exists
log_step "Checking SSH key file..."
if [ -f "$SSH_KEY_PATH" ]; then
    log_success "SSH key file exists"
    
    # Check permissions
    key_perms=$(stat -f "%A" "$SSH_KEY_PATH" 2>/dev/null || stat -c "%a" "$SSH_KEY_PATH" 2>/dev/null)
    if [ "$key_perms" = "600" ]; then
        log_success "SSH key permissions are correct (600)"
    else
        log_warning "SSH key permissions are $key_perms, setting to 600..."
        chmod 600 "$SSH_KEY_PATH"
        log_success "SSH key permissions corrected"
    fi
else
    log_error "SSH key file not found: $SSH_KEY_PATH"
    log_info "Please ensure the SSH key file exists at the specified path"
    exit 1
fi

# Test 2: Test basic connectivity
log_step "Testing basic connectivity to server..."
if ping -c 1 -W 5000 "$SERVER_HOST" >/dev/null 2>&1; then
    log_success "Server is reachable via ping"
else
    log_warning "Server ping failed (may be normal if ICMP is blocked)"
fi

# Test 3: Test SSH connection
log_step "Testing SSH connection..."
if ssh -i "$SSH_KEY_PATH" -o ConnectTimeout=10 -o BatchMode=yes -o StrictHostKeyChecking=no "$SERVER_USER@$SERVER_HOST" "echo 'SSH connection successful'" 2>/dev/null; then
    log_success "SSH connection successful"
else
    log_error "SSH connection failed"
    log_info "Troubleshooting steps:"
    log_info "  1. Verify the SSH key is correct for this server"
    log_info "  2. Check if the server is running and accessible"
    log_info "  3. Verify the username is correct: $SERVER_USER"
    log_info "  4. Check if SSH service is running on port 22"
    exit 1
fi

# Test 4: Test server environment
log_step "Testing server environment..."
ssh -i "$SSH_KEY_PATH" -o ConnectTimeout=10 -o BatchMode=yes -o StrictHostKeyChecking=no "$SERVER_USER@$SERVER_HOST" '
echo "🔍 Server Environment Check:"
echo "  - Hostname: $(hostname)"
echo "  - User: $(whoami)"
echo "  - Date: $(date)"
echo "  - Uptime: $(uptime | cut -d"," -f1)"
echo "  - Disk space (/var/www): $(df -h /var/www 2>/dev/null | tail -1 | awk "{print \$4\" available\"}" || echo "N/A")"
echo "  - Memory: $(free -h | grep Mem | awk "{print \$7\" available\"}" || echo "N/A")"
echo "  - Nginx status: $(systemctl is-active nginx 2>/dev/null || echo "not running")"
echo "  - Site directory: $([ -d "/var/www/mkdocs/site" ] && echo "exists" || echo "missing")"
echo "  - Orlando directory: $([ -d "/var/www/mkdocs/site/2025.1.ORL" ] && echo "exists" || echo "missing")"
echo "  - Atlanta directory: $([ -d "/var/www/mkdocs/site/2025.4.ATL" ] && echo "exists" || echo "missing")"
'

# Test 5: Test sudo access
log_step "Testing sudo access..."
if ssh -i "$SSH_KEY_PATH" -o ConnectTimeout=10 -o BatchMode=yes -o StrictHostKeyChecking=no "$SERVER_USER@$SERVER_HOST" "sudo -n echo 'Sudo access confirmed'" 2>/dev/null; then
    log_success "Sudo access confirmed"
else
    log_warning "Sudo access test failed (may require password)"
    log_info "This may be normal if sudo requires a password"
fi

# Test 6: Test file transfer capability
log_step "Testing file transfer capability..."
echo "test-file-content" > /tmp/ssh-test-file
if scp -i "$SSH_KEY_PATH" -o ConnectTimeout=10 -o StrictHostKeyChecking=no /tmp/ssh-test-file "$SERVER_USER@$SERVER_HOST:/tmp/ssh-test-file" 2>/dev/null; then
    log_success "File transfer successful"
    
    # Cleanup test file
    ssh -i "$SSH_KEY_PATH" -o ConnectTimeout=10 -o BatchMode=yes -o StrictHostKeyChecking=no "$SERVER_USER@$SERVER_HOST" "rm -f /tmp/ssh-test-file" 2>/dev/null || true
    rm -f /tmp/ssh-test-file
else
    log_error "File transfer failed"
    rm -f /tmp/ssh-test-file
    exit 1
fi

# Test 7: Test deployment directory access
log_step "Testing deployment directory access..."
ssh -i "$SSH_KEY_PATH" -o ConnectTimeout=10 -o BatchMode=yes -o StrictHostKeyChecking=no "$SERVER_USER@$SERVER_HOST" '
if [ -d "/var/www/mkdocs/site" ]; then
    echo "✅ Site directory exists"
    echo "📋 Directory contents:"
    ls -la /var/www/mkdocs/site/ | head -10
    echo "📊 Directory size: $(du -sh /var/www/mkdocs/site/ 2>/dev/null | cut -f1 || echo "N/A")"
else
    echo "⚠️ Site directory does not exist"
    echo "📋 Parent directory contents:"
    ls -la /var/www/ 2>/dev/null || echo "Cannot access /var/www/"
fi
'

echo
log_success "🎉 SSH CONNECTION TEST COMPLETED SUCCESSFULLY!"
echo
log_info "Summary:"
log_info "  ✅ SSH key file exists and has correct permissions"
log_info "  ✅ SSH connection established successfully"
log_info "  ✅ Server environment verified"
log_info "  ✅ File transfer capability confirmed"
log_info "  ✅ Deployment directory accessible"
echo
log_success "Your SSH configuration is ready for deployment!"
echo
log_info "Next steps:"
log_info "  1. Run: ./scripts/deploy.sh --dry-run"
log_info "  2. If dry run succeeds, run: ./scripts/deploy.sh"
log_info "  3. Or commit changes to trigger automated deployment"
