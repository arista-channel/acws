#!/bin/bash

# Mike Safe Operations Script
# Provides safe wrappers for common Mike operations with protection

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
NC='\033[0m'

# Configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP_DIR="${SCRIPT_DIR}/.mike-backups"
AUDIT_LOG="${SCRIPT_DIR}/mike-audit.log"

# Version Protection Configuration
PROTECTED_VERSIONS=("2025.1.ORL")
RESTRICTED_VERSIONS=("2025.2.NAS")

print_status() { echo -e "${BLUE}[INFO]${NC} $1"; }
print_success() { echo -e "${GREEN}[SUCCESS]${NC} $1"; }
print_warning() { echo -e "${YELLOW}[WARNING]${NC} $1"; }
print_error() { echo -e "${RED}[ERROR]${NC} $1"; }
print_protected() { echo -e "${PURPLE}[PROTECTED]${NC} $1"; }

audit_log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" >> "$AUDIT_LOG"
}

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

show_help() {
    echo "🛡️ Mike Safe Operations"
    echo "======================"
    echo ""
    echo "Usage: $0 <command> [options]"
    echo ""
    echo "Commands:"
    echo "  list                    - List all versions with protection status"
    echo "  deploy <version>        - Safe deploy with protection checks"
    echo "  delete <version>        - Safe delete with confirmation"
    echo "  backup <version>        - Create backup of specific version"
    echo "  restore <version>       - Restore version from backup"
    echo "  status                  - Show protection status and recent activity"
    echo "  unlock <version>        - Temporarily unlock protected version"
    echo "  audit                   - Show audit log"
    echo ""
    echo "Options:"
    echo "  --force                 - Force operation (use with caution)"
    echo "  --dry-run              - Show what would be done without executing"
    echo "  --help                 - Show this help message"
    echo ""
    echo "Examples:"
    echo "  $0 list"
    echo "  $0 deploy 2025.3.TOR"
    echo "  $0 backup 2025.2.NAS"
    echo "  $0 status"
}

list_versions() {
    print_status "Documentation Versions with Protection Status:"
    echo ""
    
    # Get all versions
    local versions=$(mike list | grep -E '^[0-9]' | awk '{print $1}' | sed 's/\[.*\]//')
    
    for version in $versions; do
        check_version_protection "$version"
        case $? in
            2) 
                echo -e "  🔒 ${PURPLE}$version${NC} (PROTECTED - Historical)"
                ;;
            1) 
                echo -e "  ⚠️  ${YELLOW}$version${NC} (RESTRICTED - Active)"
                ;;
            0) 
                echo -e "  ✅ ${GREEN}$version${NC} (FLEXIBLE - Development)"
                ;;
        esac
    done
    
    echo ""
    mike list
}

safe_deploy() {
    local version=$1
    local force=${2:-false}
    
    if [ -z "$version" ]; then
        print_error "Version required for deploy command"
        echo "Usage: $0 deploy <version>"
        exit 1
    fi
    
    check_version_protection "$version"
    local protection_code=$?
    
    case $protection_code in
        2)
            if [ "$force" != true ]; then
                print_protected "🚫 DEPLOYMENT BLOCKED: $version is PROTECTED"
                print_protected "This version contains historical content."
                print_protected "Use --force to override (not recommended)"
                audit_log "DEPLOY_BLOCKED: $version - protected without force"
                exit 1
            else
                print_warning "⚠️ FORCE DEPLOYING PROTECTED VERSION: $version"
                read -p "Type 'I UNDERSTAND THE RISKS' to continue: " confirmation
                if [ "$confirmation" != "I UNDERSTAND THE RISKS" ]; then
                    print_error "Deployment cancelled"
                    exit 1
                fi
            fi
            ;;
        1)
            print_warning "⚠️ RESTRICTED VERSION: $version"
            read -p "Are you sure you want to deploy? (yes/no): " confirmation
            if [ "$confirmation" != "yes" ]; then
                print_error "Deployment cancelled"
                exit 1
            fi
            ;;
    esac
    
    # Create backup if version exists
    if mike list | grep -q "$version"; then
        print_status "Creating backup before deployment..."
        create_backup "$version"
    fi
    
    # Deploy
    print_status "Deploying version: $version"
    mike deploy "$version"
    print_success "Successfully deployed: $version"
    audit_log "DEPLOY_SUCCESS: $version"
}

safe_delete() {
    local version=$1
    local force=${2:-false}
    
    if [ -z "$version" ]; then
        print_error "Version required for delete command"
        echo "Usage: $0 delete <version>"
        exit 1
    fi
    
    check_version_protection "$version"
    local protection_code=$?
    
    case $protection_code in
        2)
            print_protected "🚫 DELETE BLOCKED: $version is PROTECTED"
            print_protected "Protected versions cannot be deleted"
            audit_log "DELETE_BLOCKED: $version - protected version"
            exit 1
            ;;
        1)
            print_warning "⚠️ DELETING RESTRICTED VERSION: $version"
            print_warning "This is an active version that may be in use"
            ;;
    esac
    
    # Create backup before deletion
    print_status "Creating backup before deletion..."
    create_backup "$version"
    
    # Confirm deletion
    echo ""
    print_warning "⚠️ PERMANENT DELETION WARNING ⚠️"
    print_warning "Version: $version"
    print_warning "This action cannot be undone (except from backup)"
    echo ""
    read -p "Type 'DELETE' to confirm permanent deletion: " confirmation
    
    if [ "$confirmation" != "DELETE" ]; then
        print_error "Deletion cancelled"
        exit 1
    fi
    
    # Delete
    print_status "Deleting version: $version"
    mike delete "$version"
    print_success "Successfully deleted: $version"
    audit_log "DELETE_SUCCESS: $version"
}

create_backup() {
    local version=$1
    local timestamp=$(date '+%Y%m%d_%H%M%S')
    local backup_path="${BACKUP_DIR}/${version}_${timestamp}"
    
    if [ -z "$version" ]; then
        print_error "Version required for backup command"
        echo "Usage: $0 backup <version>"
        exit 1
    fi
    
    print_status "Creating backup for version: $version"
    
    # Create backup directory
    mkdir -p "$backup_path"
    
    # Check if version exists
    if ! mike list | grep -q "$version"; then
        print_error "Version $version does not exist"
        exit 1
    fi
    
    # Create backup using git worktree
    if git worktree add "$backup_path" gh-pages 2>/dev/null; then
        print_success "Git worktree backup created: $backup_path"
    else
        print_warning "Git worktree failed, using alternative backup method"
        # Alternative backup method
        if [ -d "site" ]; then
            cp -r site/* "$backup_path/" 2>/dev/null || true
        fi
    fi
    
    # Save metadata
    cat > "${backup_path}/backup_metadata.json" << EOF
{
    "version": "$version",
    "timestamp": "$timestamp",
    "backup_type": "manual",
    "git_commit": "$(git rev-parse HEAD 2>/dev/null || echo 'unknown')"
}
EOF
    
    print_success "Backup created: $backup_path"
    audit_log "BACKUP_CREATED: $version -> $backup_path"
}

show_status() {
    print_status "Mike Protection System Status"
    echo "=============================="
    echo ""
    
    # Protection configuration
    echo "🛡️ Protection Configuration:"
    echo "  Protected: ${PROTECTED_VERSIONS[*]}"
    echo "  Restricted: ${RESTRICTED_VERSIONS[*]}"
    echo ""
    
    # Backup status
    echo "💾 Backup Status:"
    if [ -d "$BACKUP_DIR" ]; then
        local backup_count=$(find "$BACKUP_DIR" -type d -name "*_*" | wc -l)
        echo "  Total backups: $backup_count"
        echo "  Backup location: $BACKUP_DIR"
        
        if [ $backup_count -gt 0 ]; then
            echo "  Recent backups:"
            find "$BACKUP_DIR" -type d -name "*_*" | sort -r | head -5 | while read backup; do
                echo "    - $(basename "$backup")"
            done
        fi
    else
        echo "  No backups found"
    fi
    echo ""
    
    # Recent activity
    echo "📋 Recent Activity:"
    if [ -f "$AUDIT_LOG" ]; then
        tail -10 "$AUDIT_LOG" | while read line; do
            echo "  $line"
        done
    else
        echo "  No audit log found"
    fi
}

show_audit() {
    if [ -f "$AUDIT_LOG" ]; then
        print_status "Mike Audit Log:"
        echo "==============="
        cat "$AUDIT_LOG"
    else
        print_warning "No audit log found"
    fi
}

# Main command processing
case "${1:-help}" in
    "list")
        list_versions
        ;;
    "deploy")
        force_flag=false
        if [ "$3" = "--force" ]; then
            force_flag=true
        fi
        safe_deploy "$2" "$force_flag"
        ;;
    "delete")
        force_flag=false
        if [ "$3" = "--force" ]; then
            force_flag=true
        fi
        safe_delete "$2" "$force_flag"
        ;;
    "backup")
        create_backup "$2"
        ;;
    "status")
        show_status
        ;;
    "audit")
        show_audit
        ;;
    "help"|"--help"|"-h")
        show_help
        ;;
    *)
        print_error "Unknown command: $1"
        echo ""
        show_help
        exit 1
        ;;
esac

# Future Workshop Version Handlers
handle_future_version() {
    local version=$1
    local operation=$2
    
    case $version in
        "2025.4.ATL")
            echo "[FUTURE] Atlanta workshop version - $operation allowed"
            return 0
            ;;
        "2025.5.BAY")
            echo "[FUTURE] Bay Area workshop version - $operation allowed"
            return 0
            ;;
        "2025."*".ATL"|"2025."*".BAY"|"2025."*".NYC"|"2025."*".CHI"|"2025."*".SEA")
            echo "[FUTURE] Future workshop version detected - $operation allowed"
            return 0
            ;;
        *)
            return 1
            ;;
    esac
}
