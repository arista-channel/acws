#!/bin/bash

# Arista Campus Workshop - Enhanced Version Control Script with Protection
# This script manages documentation versioning using Mike with comprehensive protection

set -e  # Exit on any error

echo "🛡️ Arista Campus Workshop - Protected Documentation Version Control"
echo "=================================================================="

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP_DIR="${SCRIPT_DIR}/.mike-backups"
AUDIT_LOG="${SCRIPT_DIR}/mike-audit.log"
CONFIG_FILE="${SCRIPT_DIR}/mike-protection.conf"

# Version Protection Configuration
PROTECTED_VERSIONS=("2025.1.ORL")  # Historical versions - highest protection
RESTRICTED_VERSIONS=("2025.2.NAS") # Active versions - require confirmation
FLEXIBLE_VERSIONS=("2025.3.TOR")   # Development versions - standard deployment

# Protection settings
REQUIRE_CONFIRMATION=true
CREATE_BACKUPS=true
ENABLE_AUDIT_LOG=true
MAX_BACKUPS=10

# Function to print colored output
print_status() {
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

print_protected() {
    echo -e "${PURPLE}[PROTECTED]${NC} $1"
}

print_restricted() {
    echo -e "${CYAN}[RESTRICTED]${NC} $1"
}

# Audit logging function
audit_log() {
    if [ "$ENABLE_AUDIT_LOG" = true ]; then
        echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" >> "$AUDIT_LOG"
    fi
}

# Check version protection level
check_version_protection() {
    local version=$1
    
    if [[ " ${PROTECTED_VERSIONS[@]} " =~ " ${version} " ]]; then
        return 2  # PROTECTED
    elif [[ " ${RESTRICTED_VERSIONS[@]} " =~ " ${version} " ]]; then
        return 1  # RESTRICTED
    else
        return 0  # FLEXIBLE
    fi
}

# Get protection level name
get_protection_level() {
    local version=$1
    check_version_protection "$version"
    case $? in
        2) echo "PROTECTED" ;;
        1) echo "RESTRICTED" ;;
        0) echo "FLEXIBLE" ;;
    esac
}

# Create backup of current version
create_backup() {
    local version=$1
    local timestamp=$(date '+%Y%m%d_%H%M%S')
    local backup_path="${BACKUP_DIR}/${version}_${timestamp}"
    
    if [ "$CREATE_BACKUPS" = true ]; then
        print_status "Creating backup for version: $version"
        
        # Create backup directory
        mkdir -p "$backup_path"
        
        # Check if version exists
        if mike list | grep -q "$version"; then
            # Create git-based backup
            git worktree add "$backup_path" gh-pages 2>/dev/null || {
                print_warning "Could not create git worktree backup, using alternative method"
                # Alternative: copy from site directory if available
                if [ -d "site" ]; then
                    cp -r site/* "$backup_path/" 2>/dev/null || true
                fi
            }
            
            # Save metadata
            cat > "${backup_path}/backup_metadata.json" << EOF
{
    "version": "$version",
    "timestamp": "$timestamp",
    "protection_level": "$(get_protection_level "$version")",
    "backup_type": "pre_deployment",
    "git_commit": "$(git rev-parse HEAD 2>/dev/null || echo 'unknown')"
}
EOF
            
            print_success "Backup created: ${backup_path}"
            audit_log "BACKUP_CREATED: $version -> $backup_path"
        else
            print_warning "Version $version does not exist, skipping backup"
        fi
        
        # Cleanup old backups
        cleanup_old_backups "$version"
    fi
}

# Cleanup old backups
cleanup_old_backups() {
    local version=$1
    local backup_count=$(find "$BACKUP_DIR" -name "${version}_*" -type d | wc -l)
    
    if [ "$backup_count" -gt "$MAX_BACKUPS" ]; then
        print_status "Cleaning up old backups for $version (keeping $MAX_BACKUPS)"
        find "$BACKUP_DIR" -name "${version}_*" -type d | sort | head -n -"$MAX_BACKUPS" | xargs rm -rf
        audit_log "BACKUP_CLEANUP: $version - removed $((backup_count - MAX_BACKUPS)) old backups"
    fi
}

# User confirmation prompt
confirm_deployment() {
    local version=$1
    local protection_level=$2
    local message=$3
    
    if [ "$REQUIRE_CONFIRMATION" = true ]; then
        echo ""
        case "$protection_level" in
            "PROTECTED")
                print_protected "⚠️  PROTECTED VERSION DEPLOYMENT ⚠️"
                print_protected "Version: $version"
                print_protected "Protection Level: $protection_level"
                print_protected "This is a historical/critical version!"
                print_protected "$message"
                ;;
            "RESTRICTED")
                print_restricted "⚠️  RESTRICTED VERSION DEPLOYMENT ⚠️"
                print_restricted "Version: $version"
                print_restricted "Protection Level: $protection_level"
                print_restricted "$message"
                ;;
            *)
                print_status "Deploying version: $version ($protection_level)"
                ;;
        esac
        
        if [ "$protection_level" = "PROTECTED" ] || [ "$protection_level" = "RESTRICTED" ]; then
            echo ""
            read -p "Are you sure you want to proceed? (type 'YES' to confirm): " confirmation
            if [ "$confirmation" != "YES" ]; then
                print_error "Deployment cancelled by user"
                audit_log "DEPLOYMENT_CANCELLED: $version - user cancelled"
                exit 1
            fi
        fi
    fi
}

# Enhanced deploy function with protection
deploy_version() {
    local version=$1
    local alias=$2
    local is_latest=$3
    local force_protected=${4:-false}
    
    # Check protection level
    check_version_protection "$version"
    local protection_code=$?
    local protection_level=$(get_protection_level "$version")
    
    print_status "Analyzing version: $version (Protection: $protection_level)"
    
    # Handle protected versions
    if [ $protection_code -eq 2 ] && [ "$force_protected" != true ]; then
        print_protected "🚫 DEPLOYMENT BLOCKED: $version is PROTECTED"
        print_protected "This version contains historical content that should not be modified."
        print_protected "If you absolutely must deploy, use: --force-protected flag"
        audit_log "DEPLOYMENT_BLOCKED: $version - protected version without force flag"
        return 1
    fi
    
    # Check if version already exists
    local version_exists=false
    if mike list | grep -q "$version"; then
        version_exists=true
    fi
    
    # Prepare confirmation message
    local message=""
    if [ "$version_exists" = true ]; then
        message="This will OVERWRITE existing content!"
    else
        message="This will create a new version."
    fi
    
    # Get user confirmation
    confirm_deployment "$version" "$protection_level" "$message"
    
    # Create backup before deployment
    if [ "$version_exists" = true ]; then
        create_backup "$version"
    fi
    
    # Perform deployment
    print_status "Deploying version: $version"
    audit_log "DEPLOYMENT_START: $version (protection: $protection_level, exists: $version_exists)"
    
    if [ "$is_latest" = true ]; then
        mike deploy --push --update-aliases --ignore-remote-status "$version" "$alias"
        print_success "Deployed $version as $alias (latest)"
        audit_log "DEPLOYMENT_SUCCESS: $version as $alias (latest)"
    else
        mike deploy --push --ignore-remote-status "$version"
        print_success "Deployed $version"
        audit_log "DEPLOYMENT_SUCCESS: $version"
    fi
}

# Initialize protection system
initialize_protection() {
    print_status "Initializing protection system..."
    
    # Create backup directory
    mkdir -p "$BACKUP_DIR"
    
    # Create audit log
    if [ "$ENABLE_AUDIT_LOG" = true ]; then
        touch "$AUDIT_LOG"
        audit_log "SYSTEM_INIT: Protection system initialized"
    fi
    
    # Create configuration file if it doesn't exist
    if [ ! -f "$CONFIG_FILE" ]; then
        cat > "$CONFIG_FILE" << EOF
# Mike Protection Configuration
# Edit this file to customize protection settings

# Protected versions (highest protection - blocks deployment)
PROTECTED_VERSIONS=(2025.1.ORL)

# Restricted versions (requires confirmation)
RESTRICTED_VERSIONS=(2025.2.NAS)

# Flexible versions (standard deployment)
FLEXIBLE_VERSIONS=(2025.3.TOR)

# Protection settings
REQUIRE_CONFIRMATION=true
CREATE_BACKUPS=true
ENABLE_AUDIT_LOG=true
MAX_BACKUPS=10
EOF
        print_success "Created protection configuration: $CONFIG_FILE"
    fi
    
    print_success "Protection system ready"
}

# Main execution
main() {
    # Check prerequisites
    if ! command -v mike &> /dev/null; then
        print_error "Mike is not installed. Please install it with: pip install mike"
        exit 1
    fi
    
    if ! git rev-parse --git-dir > /dev/null 2>&1; then
        print_error "Not in a git repository"
        exit 1
    fi
    
    # Initialize protection system
    initialize_protection
    
    # Load configuration if exists
    if [ -f "$CONFIG_FILE" ]; then
        source "$CONFIG_FILE"
    fi
    
    # Show current protection status
    print_status "Current Protection Configuration:"
    echo "  Protected: ${PROTECTED_VERSIONS[*]}"
    echo "  Restricted: ${RESTRICTED_VERSIONS[*]}"
    echo "  Flexible: ${FLEXIBLE_VERSIONS[*]}"
    echo ""
    
    # Deploy latest version (Nashville 2025.2)
    print_status "Deploying latest version: 2025.2.NAS"
    deploy_version "2025.2.NAS" "latest" true
    
    # Deploy placeholder versions
    print_status "Deploying placeholder versions..."
    deploy_version "2025.3.TOR" "" false
    
    # Handle historical versions with protection
    print_status "Checking historical versions..."
    if mike list | grep -q "2025.1.ORL"; then
        print_protected "2025.1.ORL already exists - PROTECTED from overwrite"
        audit_log "PROTECTED_SKIP: 2025.1.ORL - already exists and protected"
    else
        print_warning "2025.1.ORL does not exist - this should be restored manually"
        audit_log "PROTECTED_MISSING: 2025.1.ORL - version missing"
    fi
    
    # Set default version
    print_status "Setting default version to 'latest'"
    mike set-default --push latest
    print_success "Default version set to 'latest'"
    audit_log "DEFAULT_SET: latest"
    
    # List all versions
    print_status "Current documentation versions:"
    mike list
    
    print_success "Protected version control deployment completed!"
    print_status "Documentation available at: https://mbalagot12.github.io/campus-workshop/"
    
    echo ""
    echo "📚 Available versions:"
    echo "  - latest (2025.2.NAS) - Current Nashville workshop"
    echo "  - 2025.3.TOR - Toronto workshop (placeholder)"
    echo "  - 2025.1.ORL - Orlando workshop (historical) 🔒"
    echo ""
    echo "🛡️ Protection Status:"
    echo "  - Audit log: $AUDIT_LOG"
    echo "  - Backups: $BACKUP_DIR"
    echo "  - Config: $CONFIG_FILE"
    
    audit_log "DEPLOYMENT_COMPLETE: All versions processed successfully"
}

# Run main function
main "$@"
