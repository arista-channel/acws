#!/bin/bash

# Safe Content Import Script for Campus Workshop
# Safely imports content from another project to a specific Mike version
# with interactive prompts and protection for existing versions

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() { echo -e "${GREEN}✅ $1${NC}"; }
print_warning() { echo -e "${YELLOW}⚠️  $1${NC}"; }
print_error() { echo -e "${RED}❌ $1${NC}"; }
print_info() { echo -e "${BLUE}ℹ️  $1${NC}"; }
print_header() { echo -e "${PURPLE}🎯 $1${NC}"; }

# Function to prompt for yes/no
prompt_yes_no() {
    local prompt="$1"
    local response
    while true; do
        echo -e "${CYAN}❓ $prompt (y/n): ${NC}"
        read -r response
        case $response in
            [Yy]* ) return 0;;
            [Nn]* ) return 1;;
            * ) echo "Please answer yes (y) or no (n).";;
        esac
    done
}

# Function to show file differences
show_file_diff() {
    local source_file="$1"
    local target_file="$2"
    
    if [ -f "$target_file" ]; then
        echo -e "${YELLOW}📄 File exists, showing differences:${NC}"
        echo "Source: $source_file"
        echo "Target: $target_file"
        echo "----------------------------------------"
        diff -u "$target_file" "$source_file" || true
        echo "----------------------------------------"
    else
        echo -e "${GREEN}📄 New file will be created:${NC}"
        echo "Target: $target_file"
        echo "Content preview (first 10 lines):"
        echo "----------------------------------------"
        head -10 "$source_file" 2>/dev/null || echo "Cannot preview file"
        echo "----------------------------------------"
    fi
}

print_header "SAFE CONTENT IMPORT FOR CAMPUS WORKSHOP"
echo "========================================"
echo ""

# Check if we're in the right directory
if [ ! -f "mkdocs.yml" ]; then
    print_error "Not in a MkDocs project directory. Please run from campus-workshop root."
    exit 1
fi

# Check if virtual environment is activated
if [ -z "$VIRTUAL_ENV" ]; then
    print_warning "Virtual environment not activated. Activating..."
    if [ -f ".venv/bin/activate" ]; then
        source .venv/bin/activate
        print_status "Virtual environment activated"
    else
        print_error "Virtual environment not found. Please run 'uv sync' first."
        exit 1
    fi
fi

# Get source project path
echo -e "${CYAN}📁 Enter the path to your source project:${NC}"
read -r SOURCE_PROJECT

if [ ! -d "$SOURCE_PROJECT" ]; then
    print_error "Source project directory not found: $SOURCE_PROJECT"
    exit 1
fi

if [ ! -f "$SOURCE_PROJECT/mkdocs.yml" ]; then
    print_error "Source directory is not a MkDocs project (no mkdocs.yml found)"
    exit 1
fi

print_status "Source project found: $SOURCE_PROJECT"

# Show current Mike versions
print_header "CURRENT MIKE VERSIONS"
echo "====================="
mike list
echo ""

# Get target version
echo -e "${CYAN}🎯 Enter the Mike version to update (e.g., 2025.1.SDW):${NC}"
read -r TARGET_VERSION

if [ -z "$TARGET_VERSION" ]; then
    print_error "Target version cannot be empty"
    exit 1
fi

# Protect Orlando version
if [ "$TARGET_VERSION" = "2025.1.ORL" ]; then
    print_error "PROTECTION: Cannot modify Orlando 2025.1.ORL version!"
    print_error "This version is historically protected."
    exit 1
fi

print_status "Target version: $TARGET_VERSION"

# Create backup
print_header "CREATING BACKUP"
echo "==============="
BACKUP_DIR="backup-$(date +%Y%m%d-%H%M%S)"
cp -r docs/ "$BACKUP_DIR"
print_status "Backup created: $BACKUP_DIR"

# Analyze what will be copied
print_header "ANALYZING SOURCE CONTENT"
echo "========================"

# Find common files to copy
COMMON_FILES=(
    "docs/index.md"
    "docs/references/lab_assignment.md"
    "docs/lab/access.md"
    "data/lab_assignment.csv"
)

# Check which files exist in source
EXISTING_FILES=()
for file in "${COMMON_FILES[@]}"; do
    if [ -f "$SOURCE_PROJECT/$file" ]; then
        EXISTING_FILES+=("$file")
    fi
done

if [ ${#EXISTING_FILES[@]} -eq 0 ]; then
    print_warning "No common files found in source project"
    echo "Looking for any docs/ files..."
    find "$SOURCE_PROJECT/docs" -name "*.md" -type f | head -10
fi

print_info "Found ${#EXISTING_FILES[@]} common files to potentially copy"

# Show what will be copied and prompt for each
print_header "CONTENT IMPORT PREVIEW"
echo "======================"

for file in "${EXISTING_FILES[@]}"; do
    echo ""
    echo -e "${PURPLE}📄 File: $file${NC}"
    
    if prompt_yes_no "Show preview of this file?"; then
        show_file_diff "$SOURCE_PROJECT/$file" "$file"
    fi
    
    if prompt_yes_no "Copy this file?"; then
        # Create directory if needed
        mkdir -p "$(dirname "$file")"
        cp "$SOURCE_PROJECT/$file" "$file"
        print_status "Copied: $file"
    else
        print_info "Skipped: $file"
    fi
done

# Final confirmation
echo ""
print_header "FINAL CONFIRMATION"
echo "=================="
print_warning "About to deploy to Mike version: $TARGET_VERSION"
print_info "Orlando 2025.1.ORL will remain protected"
print_info "Other versions will remain unchanged"

if prompt_yes_no "Deploy to $TARGET_VERSION now?"; then
    print_status "Deploying to $TARGET_VERSION..."
    mike deploy "$TARGET_VERSION" --title "$TARGET_VERSION Workshop"
    print_status "Deployment complete!"
    
    echo ""
    print_header "TESTING"
    echo "======="
    print_info "Test locally: mike serve"
    print_info "Then visit: http://127.0.0.1:8000/$TARGET_VERSION/"
    
    if prompt_yes_no "Start local test server now?"; then
        mike serve
    fi
else
    print_info "Deployment cancelled. Files have been copied but not deployed to Mike version."
    print_info "You can manually deploy later with: mike deploy $TARGET_VERSION"
fi

print_status "Safe content import completed!"
print_info "Backup available at: $BACKUP_DIR"
