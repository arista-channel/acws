#!/bin/bash

# 🛡️ Orlando Version Protection Script
# This script ensures Orlando 2025.1.ORL is never overwritten

set -e

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

ORLANDO_VERSION="2025.1.ORL"
BACKUP_BRANCH="backup-gh-pages-20250914-162844"
NGINX_HOST="acws.duckdns.org"
NGINX_USER="ubuntu"
SSH_KEY_PATH="/Users/miguelbalagot/Documents/MyKeyPairs/mb-partner-kp.pem"

log_info() {
    echo -e "${GREEN}🛡️  $1${NC}"
}

log_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

log_error() {
    echo -e "${RED}❌ $1${NC}"
}

validate_ssh_connection() {
    log_info "Validating SSH connection to nginx server..."

    # Check if SSH key exists
    if [[ ! -f "$SSH_KEY_PATH" ]]; then
        log_error "SSH key not found at: $SSH_KEY_PATH"
        return 1
    fi

    # Check SSH key permissions
    local key_perms=$(stat -f "%A" "$SSH_KEY_PATH" 2>/dev/null || stat -c "%a" "$SSH_KEY_PATH" 2>/dev/null)
    if [[ "$key_perms" != "600" ]]; then
        log_warning "SSH key permissions are $key_perms, should be 600"
        log_info "Fixing SSH key permissions..."
        chmod 600 "$SSH_KEY_PATH"
    fi

    # Test SSH connection
    log_info "Testing SSH connection to $NGINX_USER@$NGINX_HOST..."
    if ssh -i "$SSH_KEY_PATH" -o ConnectTimeout=10 -o BatchMode=yes -o StrictHostKeyChecking=no \
           "$NGINX_USER@$NGINX_HOST" "echo 'SSH connection successful'" &>/dev/null; then
        log_info "✅ SSH connection validated"
        return 0
    else
        log_error "SSH connection failed!"
        log_error "Please check SSH configuration"
        return 1
    fi
}

create_orlando_backup() {
    log_info "Creating Orlando backup..."
    
    # Switch to gh-pages and backup Orlando
    git checkout gh-pages
    
    if [[ -d "$ORLANDO_VERSION" ]]; then
        # Create timestamped backup
        local timestamp=$(date +"%Y%m%d_%H%M%S")
        cp -r "$ORLANDO_VERSION" "/tmp/orlando_backup_$timestamp"
        log_info "Orlando backed up to /tmp/orlando_backup_$timestamp"
    else
        log_warning "Orlando version not found in current gh-pages"
    fi
    
    git checkout main
}

restore_orlando() {
    log_info "Restoring Orlando from backup branch..."
    
    # Check if backup branch exists
    if ! git show-branch "$BACKUP_BRANCH" &> /dev/null; then
        log_error "Backup branch $BACKUP_BRANCH not found!"
        return 1
    fi
    
    # Get Orlando from backup branch
    git checkout "$BACKUP_BRANCH"
    
    if [[ -d "$ORLANDO_VERSION" ]]; then
        cp -r "$ORLANDO_VERSION" "/tmp/orlando_restore"
        log_info "Orlando content extracted from backup"
        
        # Switch to gh-pages and restore
        git checkout gh-pages
        rm -rf "$ORLANDO_VERSION"
        cp -r "/tmp/orlando_restore" "$ORLANDO_VERSION"
        
        # Commit the restoration
        git add "$ORLANDO_VERSION"
        git commit -m "🛡️ PROTECT: Restore Orlando $ORLANDO_VERSION from backup

- Emergency restoration from $BACKUP_BRANCH
- Protecting historical Orlando content
- Automated protection script execution"
        
        log_info "Orlando version restored and committed"
        
        # Cleanup
        rm -rf "/tmp/orlando_restore"
        
    else
        log_error "Orlando version not found in backup branch!"
        return 1
    fi
    
    git checkout main
}

verify_orlando() {
    log_info "Verifying Orlando version integrity..."
    
    git checkout gh-pages
    
    if [[ -d "$ORLANDO_VERSION" ]]; then
        local file_count=$(find "$ORLANDO_VERSION" -type f | wc -l)
        log_info "Orlando version found with $file_count files"
        
        # Check for key files
        if [[ -f "$ORLANDO_VERSION/index.html" ]]; then
            log_info "✅ Orlando index.html exists"
        else
            log_warning "⚠️ Orlando index.html missing"
        fi
        
        if [[ -d "$ORLANDO_VERSION/assets" ]]; then
            log_info "✅ Orlando assets directory exists"
        else
            log_warning "⚠️ Orlando assets directory missing"
        fi
        
    else
        log_error "Orlando version directory not found!"
        git checkout main
        return 1
    fi
    
    git checkout main
    return 0
}

main() {
    local action=${1:-"verify"}
    
    echo "🛡️ Orlando Version Protection"
    echo "============================="
    
    case $action in
        "backup")
            create_orlando_backup
            ;;
        "restore")
            restore_orlando
            ;;
        "verify")
            verify_orlando
            ;;
        *)
            echo "Usage: $0 [backup|restore|verify]"
            echo ""
            echo "Commands:"
            echo "  backup  - Create backup of current Orlando version"
            echo "  restore - Restore Orlando from backup branch"
            echo "  verify  - Verify Orlando version integrity"
            exit 1
            ;;
    esac
    
    if [[ $? -eq 0 ]]; then
        log_info "🎊 Orlando protection operation completed successfully!"
    else
        log_error "Orlando protection operation failed!"
        exit 1
    fi
}

main "$@"
