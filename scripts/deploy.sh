#!/bin/bash

# 🚀 Campus Workshop Deployment Script
# =====================================
# Comprehensive, error-free deployment automation
# 
# Usage:
#   ./scripts/deploy.sh [OPTIONS]
#
# Options:
#   --dry-run           Test deployment without making changes
#   --force             Force deployment even if no changes detected
#   --skip-orlando      Skip Orlando protection (DANGEROUS)
#   --local-only        Only build locally, don't deploy
#   --help              Show this help message

set -euo pipefail  # Exit on error, undefined vars, pipe failures

# Configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
VENV_PATH="$PROJECT_ROOT/.venv"
SERVER_HOST="acws.duckdns.org"
SERVER_USER="ubuntu"
SERVER_PATH="/var/www/mkdocs/site"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

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

log_result() {
    echo -e "${CYAN}🎯 $1${NC}"
}

# Parse command line arguments
DRY_RUN=false
FORCE_DEPLOY=false
SKIP_ORLANDO=false
LOCAL_ONLY=false
SHOW_HELP=false

while [[ $# -gt 0 ]]; do
    case $1 in
        --dry-run)
            DRY_RUN=true
            shift
            ;;
        --force)
            FORCE_DEPLOY=true
            shift
            ;;
        --skip-orlando)
            SKIP_ORLANDO=true
            shift
            ;;
        --local-only)
            LOCAL_ONLY=true
            shift
            ;;
        --help)
            SHOW_HELP=true
            shift
            ;;
        *)
            log_error "Unknown option: $1"
            SHOW_HELP=true
            shift
            ;;
    esac
done

# Show help if requested
if [ "$SHOW_HELP" = true ]; then
    cat << EOF
🚀 Campus Workshop Deployment Script

USAGE:
    $0 [OPTIONS]

OPTIONS:
    --dry-run           Test deployment without making changes
    --force             Force deployment even if no changes detected
    --skip-orlando      Skip Orlando protection (DANGEROUS - only use if Orlando is corrupted)
    --local-only        Only build locally, don't deploy to server
    --help              Show this help message

EXAMPLES:
    $0                  # Normal deployment
    $0 --dry-run        # Test deployment
    $0 --force          # Force deployment
    $0 --local-only     # Build only, no deployment

ENVIRONMENT:
    Server: $SERVER_HOST
    Path: $SERVER_PATH
    Orlando Protection: $($SKIP_ORLANDO && echo "DISABLED" || echo "ENABLED")

EOF
    exit 0
fi

# Banner
echo -e "${PURPLE}"
cat << 'EOF'
🚀 CAMPUS WORKSHOP DEPLOYMENT
=============================
Automated, Error-Free Update System
EOF
echo -e "${NC}"

log_info "Deployment Configuration:"
log_info "  Server: $SERVER_HOST"
log_info "  Dry Run: $DRY_RUN"
log_info "  Force Deploy: $FORCE_DEPLOY"
log_info "  Orlando Protection: $($SKIP_ORLANDO && echo "DISABLED" || echo "ENABLED")"
log_info "  Local Only: $LOCAL_ONLY"
echo

# Change to project root
cd "$PROJECT_ROOT"

# Step 1: Environment Setup
log_step "Setting up environment..."

# Check if UV is available
if ! command -v uv &> /dev/null; then
    log_warning "UV not found, installing..."
    curl -LsSf https://astral.sh/uv/install.sh | sh
    export PATH="$HOME/.cargo/bin:$PATH"
fi

# Setup virtual environment
if [ ! -d "$VENV_PATH" ]; then
    log_step "Creating virtual environment with UV..."
    uv venv "$VENV_PATH"
fi

# Activate virtual environment
log_step "Activating virtual environment..."
source "$VENV_PATH/bin/activate"

# Install dependencies
log_step "Installing dependencies..."
uv pip install -r requirements.txt

log_success "Environment setup completed"

# Step 2: Pre-deployment Validation
log_step "Running pre-deployment validation..."

# Check required files
required_files=("mkdocs.yml" "data/lab_assignment.csv" "docs/a_wired/a02_atd.md")
for file in "${required_files[@]}"; do
    if [ -f "$file" ]; then
        log_success "Found required file: $file"
    else
        log_error "Missing required file: $file"
        exit 1
    fi
done

# Validate CSV format
log_step "Validating ATD Token CSV format..."
if grep -q "🚀 ATD Lab" data/lab_assignment.csv; then
    atd_count=$(grep -c "🚀 ATD Lab" data/lab_assignment.csv)
    log_success "Found $atd_count ATD Lab entries in CSV"
else
    log_error "No ATD Lab entries found in CSV"
    exit 1
fi

log_success "Pre-deployment validation passed"

# Step 3: Fix ATD Token Issues
log_step "Applying ATD Token fixes..."

cat > fix_atd_tokens.py << 'EOF'
import csv
import re
import sys

def fix_csv_file(filepath):
    print(f"🔍 Processing {filepath}...")
    
    try:
        with open(filepath, 'r', encoding='utf-8') as f:
            content = f.read()
        
        original_content = content
        
        # Fix 1: Double quotes in target attribute
        content = content.replace('""_blank""', '"_blank"')
        
        # Fix 2: Unquoted target attributes
        content = re.sub(r'target=_blank(?!")', 'target="_blank"', content)
        
        # Fix 3: Remove unnecessary quote wrapping around markdown links
        content = re.sub(r',"(\[🚀 ATD Lab.*?\})"', r',\1', content)
        
        # Fix 4: Ensure proper markdown link format
        content = re.sub(r'\[🚀 ATD Lab (\d+)\]\((https://testdrive\.arista\.com/[^)]+)\)\{:target="_blank"\}', 
                       r'[🚀 ATD Lab \1](\2){:target="_blank"}', content)
        
        if content != original_content:
            with open(filepath, 'w', encoding='utf-8') as f:
                f.write(content)
            print("✅ CSV fixes applied successfully")
            
            # Verify fixes
            with open(filepath, 'r', encoding='utf-8') as f:
                lines = f.readlines()
            
            atd_count = sum(1 for line in lines if '🚀 ATD Lab' in line and 'testdrive.arista.com' in line)
            print(f"✅ Found {atd_count} ATD Lab entries")
            
            target_blank_count = sum(1 for line in lines if 'target="_blank"' in line)
            print(f"✅ Found {target_blank_count} properly formatted target attributes")
            
        else:
            print("✅ No CSV fixes needed")
            
    except Exception as e:
        print(f"❌ Error processing CSV: {e}")
        sys.exit(1)

if __name__ == "__main__":
    fix_csv_file("data/lab_assignment.csv")
EOF

python fix_atd_tokens.py
rm fix_atd_tokens.py

log_success "ATD Token fixes applied"

# Step 4: Build Documentation
log_step "Building documentation with Mike..."

# Clean any existing builds
rm -rf site/

# Deploy Atlanta version with Mike
mike deploy --push --update-aliases 2025.4.ATL latest

# Verify Mike structure
log_step "Verifying Mike structure..."
mike list

log_success "Documentation built successfully"

# Step 5: Verify ATD Token Rendering
log_step "Verifying ATD Token rendering..."

if [ -f "2025.4.ATL/a_wired/a02_atd/index.html" ]; then
    log_success "ATD lab page found"
    
    # Count ATD Token links
    atd_links=$(grep -c 'href="https://testdrive.arista.com' 2025.4.ATL/a_wired/a02_atd/index.html || echo "0")
    log_result "Found $atd_links ATD Token links"
    
    # Check target attributes
    target_attrs=$(grep -c 'target="_blank"' 2025.4.ATL/a_wired/a02_atd/index.html || echo "0")
    log_result "Found $target_attrs target='_blank' attributes"
    
    if [ "$atd_links" -gt "0" ] && [ "$target_attrs" -gt "0" ]; then
        log_success "ATD Token links are properly rendered"
    else
        log_warning "ATD Token links may have rendering issues"
    fi
else
    log_warning "ATD lab page not found in built site"
fi

# Exit here if local-only mode
if [ "$LOCAL_ONLY" = true ]; then
    log_success "Local build completed (local-only mode)"
    log_result "Built site available in current directory"
    exit 0
fi

# Step 6: Deploy to Server (if not dry run)
if [ "$DRY_RUN" = true ]; then
    log_step "DRY RUN MODE - Simulating deployment..."
    log_info "Would deploy to: $SERVER_HOST"
    log_info "Orlando protection: $($SKIP_ORLANDO && echo "DISABLED" || echo "ENABLED")"
    log_info "Package size would be: $(du -sh . | cut -f1)"
    log_success "Dry run completed successfully"
    exit 0
fi

log_step "Deploying to nginx server..."

# Create deployment package
log_step "Creating deployment package..."
tar -czf nginx-deployment.tar.gz --exclude='.git' --exclude='.venv' --exclude='node_modules' .

# Test SSH connection
log_step "Testing server connection..."
if ! ssh -o ConnectTimeout=10 -o BatchMode=yes "$SERVER_USER@$SERVER_HOST" "echo 'Connection test successful'"; then
    log_error "Cannot connect to server $SERVER_HOST"
    exit 1
fi

log_success "Server connection verified"

# Transfer deployment package
log_step "Transferring deployment package..."
scp nginx-deployment.tar.gz "$SERVER_USER@$SERVER_HOST:/tmp/"

log_success "Deployment package transferred"

# Execute server-side deployment
log_step "Executing server-side deployment..."

# Create deployment script
cat > deploy_server.sh << 'DEPLOY_SCRIPT'
#!/bin/bash
set -e

DEPLOY_TIMESTAMP=$(date -u '+%Y%m%d_%H%M%S')
BACKUP_DIR="/tmp/nginx_backup_${DEPLOY_TIMESTAMP}"
TEMP_DIR="/tmp/nginx_deploy_${DEPLOY_TIMESTAMP}"
SITE_DIR="/var/www/mkdocs/site"

echo "🚀 Server-side deployment started: $(date)"

# Create backup
echo "💾 Creating backup..."
sudo mkdir -p "$BACKUP_DIR"
if [ -d "$SITE_DIR" ]; then
    sudo cp -r "$SITE_DIR" "$BACKUP_DIR/site_backup"
    echo "✅ Backup created"
fi

# Orlando protection
ORLANDO_PROTECTED=false
if [ -d "$SITE_DIR/2025.1.ORL" ] && [ "$SKIP_ORLANDO_PROTECTION" != "true" ]; then
    echo "🛡️ Protecting Orlando..."
    sudo cp -r "$SITE_DIR/2025.1.ORL" "/tmp/orlando_protected_${DEPLOY_TIMESTAMP}"
    ORLANDO_PROTECTED=true
    echo "✅ Orlando protected"
fi

# Extract and deploy
echo "📦 Extracting deployment..."
rm -rf "$TEMP_DIR"
mkdir -p "$TEMP_DIR"
cd "$TEMP_DIR"
tar -xzf /tmp/nginx-deployment.tar.gz

echo "🚀 Deploying..."
sudo mkdir -p "$SITE_DIR"
sudo rm -rf "$SITE_DIR"/*
sudo cp -r . "$SITE_DIR/"

# Restore Orlando
if [ "$ORLANDO_PROTECTED" = true ]; then
    echo "🛡️ Restoring Orlando..."
    sudo cp -r "/tmp/orlando_protected_${DEPLOY_TIMESTAMP}" "$SITE_DIR/2025.1.ORL"
    sudo rm -rf "/tmp/orlando_protected_${DEPLOY_TIMESTAMP}"
    echo "✅ Orlando restored"
fi

# Set permissions and reload
echo "🔐 Setting permissions..."
sudo chown -R www-data:www-data "$SITE_DIR"
sudo chmod -R 755 "$SITE_DIR"

echo "🔄 Reloading nginx..."
sudo systemctl reload nginx

# Cleanup
echo "🧹 Cleaning up..."
rm -rf "$TEMP_DIR" /tmp/nginx-deployment.tar.gz

echo "🎉 Deployment completed successfully!"
DEPLOY_SCRIPT

# Transfer and execute deployment script
scp deploy_server.sh "$SERVER_USER@$SERVER_HOST:/tmp/"
ssh "$SERVER_USER@$SERVER_HOST" "SKIP_ORLANDO_PROTECTION=$SKIP_ORLANDO bash /tmp/deploy_server.sh"

# Cleanup local files
rm -f nginx-deployment.tar.gz deploy_server.sh

log_success "Nginx deployment completed successfully!"

# Final summary
echo
log_result "🎉 DEPLOYMENT COMPLETED SUCCESSFULLY!"
log_result "=================================="
log_result "🌐 Site URL: http://$SERVER_HOST/"
log_result "📅 Deployment: $(date -u '+%Y-%m-%d %H:%M:%S UTC')"
log_result "🛡️ Orlando Protected: $($SKIP_ORLANDO && echo "NO" || echo "YES")"
log_result "📋 Available Versions:"
log_result "  - 🎯 Atlanta 2025.4.ATL [latest] - WITH enumerated ATD Lab labels"
log_result "  - 🛡️ Orlando 2025.1.ORL [historical] - PROTECTED"
echo
log_success "Campus Workshop deployment automation completed!"
