#!/bin/bash

# Arista Campus Workshop - Version Control Script
# This script manages documentation versioning using Mike

set -e  # Exit on any error

echo "🚀 Arista Campus Workshop - Documentation Version Control"
echo "========================================================"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

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

# Check if mike is installed
if ! command -v mike &> /dev/null; then
    print_error "Mike is not installed. Please install it with: pip install mike"
    exit 1
fi

# Check if we're in a git repository
if ! git rev-parse --git-dir > /dev/null 2>&1; then
    print_error "Not in a git repository"
    exit 1
fi

# Function to deploy a version
deploy_version() {
    local version=$1
    local alias=$2
    local is_latest=$3

    print_status "Deploying version: $version"

    if [ "$is_latest" = true ]; then
        mike deploy --push --update-aliases --ignore-remote-status "$version" "$alias"
        print_success "Deployed $version as $alias (latest)"
    else
        mike deploy --push --ignore-remote-status "$version"
        print_success "Deployed $version"
    fi
}

# Deploy latest version (Toronto 2025.3)
print_status "Deploying latest version: 2025.3.TOR"
deploy_version "2025.3.TOR" "latest" true

# Deploy current versions
print_status "Deploying current versions..."
deploy_version "2025.2.NAS" "" false

# Deploy historical versions
print_status "Deploying historical versions..."
deploy_version "2025.1.ORL" "" false

# Set default version
print_status "Setting default version to 'latest'"
mike set-default --push latest
print_success "Default version set to 'latest'"

# List all versions
print_status "Current documentation versions:"
mike list

print_success "Version control deployment completed!"
print_status "Documentation available at: https://mbalagot12.github.io/campus-workshop/"

echo ""
echo "📚 Available versions:"
echo "  - latest (2025.3.TOR) - Current Toronto workshop"
echo "  - 2025.2.NAS - Nashville workshop"
echo "  - 2025.1.ORL - Orlando workshop (historical)"
echo ""
echo "🔗 Version selector available in the documentation header"
