#!/bin/bash

# 🚀 Quick Deploy Script for Campus Workshop
# Usage: ./scripts/quick-deploy.sh [github|nginx|both]

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
ATLANTA_VERSION="2025.4.ATL"
ORLANDO_VERSION="2025.1.ORL"
NGINX_HOST="acws.duckdns.org"
NGINX_USER="ubuntu"
SSH_KEY_PATH="/Users/miguelbalagot/Documents/MyKeyPairs/mb-partner-kp.pem"

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

check_prerequisites() {
    log_info "Checking prerequisites..."

    # Check if we're in the right directory
    if [[ ! -f "mkdocs.yml" ]]; then
        log_error "Not in campus-workshop directory. Please run from project root."
        exit 1
    fi

    # Check if virtual environment is activated
    if [[ -z "$VIRTUAL_ENV" ]]; then
        log_info "Activating virtual environment..."
        source .venv/bin/activate
    fi

    # Check if mike is installed
    if ! command -v mike &> /dev/null; then
        log_error "Mike is not installed. Please install with: pip install mike"
        exit 1
    fi

    log_success "Prerequisites checked"
}

validate_ssh_connection() {
    log_info "Validating SSH connection to nginx server..."

    # Check if SSH key exists
    if [[ ! -f "$SSH_KEY_PATH" ]]; then
        log_error "SSH key not found at: $SSH_KEY_PATH"
        log_error "Please ensure the keypair file exists"
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
        log_success "SSH connection validated ✓"
        return 0
    else
        log_error "SSH connection failed!"
        log_error "Please check:"
        log_error "  - SSH key path: $SSH_KEY_PATH"
        log_error "  - Server hostname: $NGINX_HOST"
        log_error "  - Username: $NGINX_USER"
        log_error "  - Network connectivity"
        return 1
    fi
}

protect_orlando() {
    log_info "Protecting Orlando version..."
    
    # Check if Orlando version exists in gh-pages
    if git show-branch remotes/origin/gh-pages &> /dev/null; then
        git checkout gh-pages
        if [[ -d "$ORLANDO_VERSION" ]]; then
            log_success "Orlando version found and protected"
        else
            log_warning "Orlando version not found - will need manual restoration"
        fi
        git checkout main
    else
        log_warning "gh-pages branch not found"
    fi
}

deploy_github() {
    log_info "Deploying to GitHub Pages..."
    
    # Protect Orlando first
    protect_orlando
    
    # Deploy Atlanta version
    mike deploy --push --update-aliases --ignore-remote-status $ATLANTA_VERSION latest
    
    # Verify Orlando still exists
    git checkout gh-pages
    if [[ -d "$ORLANDO_VERSION" ]]; then
        log_success "Orlando version preserved ✓"
    else
        log_error "Orlando version was overwritten! Manual recovery needed."
        exit 1
    fi
    git checkout main
    
    log_success "GitHub Pages deployment completed"
}

deploy_nginx() {
    log_info "Deploying to nginx server..."

    # Validate SSH connection first
    if ! validate_ssh_connection; then
        log_error "SSH validation failed. Cannot proceed with nginx deployment."
        return 1
    fi

    # Create deployment package from gh-pages
    git checkout gh-pages
    
    # Create clean package
    tar -czf /tmp/campus-deployment.tar.gz --exclude='.git' --exclude='.DS_Store' .
    
    log_info "Transferring to nginx server..."
    scp -i "$SSH_KEY_PATH" /tmp/campus-deployment.tar.gz $NGINX_USER@$NGINX_HOST:/tmp/
    
    log_info "Deploying on nginx server..."
    ssh -i "$SSH_KEY_PATH" $NGINX_USER@$NGINX_HOST '
        echo "🧹 Creating backup..."
        sudo rm -rf /var/www/mkdocs/site.backup
        sudo mv /var/www/mkdocs/site /var/www/mkdocs/site.backup
        sudo mkdir -p /var/www/mkdocs/site
        
        echo "📦 Extracting content..."
        cd /tmp
        sudo tar -xzf campus-deployment.tar.gz -C /var/www/mkdocs/site
        
        echo "🔧 Setting permissions..."
        sudo chown -R www-data:www-data /var/www/mkdocs/site
        sudo chmod -R 755 /var/www/mkdocs/site
        
        echo "🧹 Cleaning up..."
        rm -f /tmp/campus-deployment.tar.gz
        
        echo "✅ nginx deployment completed"
    '
    
    # Cleanup
    rm -f /tmp/campus-deployment.tar.gz
    git checkout main
    
    log_success "nginx server deployment completed"
}

# Main execution
main() {
    local target=${1:-"github"}
    
    echo "🚀 Campus Workshop Quick Deploy"
    echo "================================"
    
    check_prerequisites
    
    case $target in
        "github")
            deploy_github
            ;;
        "nginx")
            deploy_nginx
            ;;
        "both")
            deploy_github
            deploy_nginx
            ;;
        *)
            log_error "Invalid target. Use: github, nginx, or both"
            exit 1
            ;;
    esac
    
    echo ""
    log_success "🎊 Deployment completed successfully!"
    echo ""
    echo "🌐 Access URLs:"
    echo "   • GitHub Pages: https://mbalagot12.github.io/campus-workshop/"
    echo "   • nginx Server: https://acws.duckdns.org/"
}

# Run main function with all arguments
main "$@"
