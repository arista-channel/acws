#!/bin/bash

# Simple test script to demonstrate Mike protection system
echo "🛡️ Mike Version Protection System Test"
echo "======================================"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
NC='\033[0m'

# Version Protection Configuration
PROTECTED_VERSIONS=("2025.1.ORL")
RESTRICTED_VERSIONS=("2025.2.NAS")
FLEXIBLE_VERSIONS=("2025.3.TOR")

print_status() { echo -e "${BLUE}[INFO]${NC} $1"; }
print_success() { echo -e "${GREEN}[SUCCESS]${NC} $1"; }
print_warning() { echo -e "${YELLOW}[WARNING]${NC} $1"; }
print_error() { echo -e "${RED}[ERROR]${NC} $1"; }
print_protected() { echo -e "${PURPLE}[PROTECTED]${NC} $1"; }

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

get_protection_level() {
    local version=$1
    check_version_protection "$version"
    case $? in
        2) echo "PROTECTED" ;;
        1) echo "RESTRICTED" ;;
        0) echo "FLEXIBLE" ;;
    esac
}

list_versions_with_protection() {
    print_status "Documentation Versions with Protection Status:"
    echo ""
    
    # Get all versions from mike
    local versions=$(mike list 2>/dev/null | grep -E '^[0-9]' | awk '{print $1}' | sed 's/\[.*\]//' | tr -d '"')
    
    for version in $versions; do
        local protection_level=$(get_protection_level "$version")
        case "$protection_level" in
            "PROTECTED") 
                echo -e "  🔒 ${PURPLE}$version${NC} (PROTECTED - Historical)"
                ;;
            "RESTRICTED") 
                echo -e "  ⚠️  ${YELLOW}$version${NC} (RESTRICTED - Active)"
                ;;
            "FLEXIBLE") 
                echo -e "  ✅ ${GREEN}$version${NC} (FLEXIBLE - Development)"
                ;;
        esac
    done
    
    echo ""
    print_status "Raw Mike output:"
    mike list 2>/dev/null || echo "Mike not available or no versions found"
}

test_protection_blocking() {
    print_status "Testing protection blocking for 2025.1.ORL..."
    
    check_version_protection "2025.1.ORL"
    local protection_code=$?
    
    if [ $protection_code -eq 2 ]; then
        print_protected "🚫 DEPLOYMENT BLOCKED: 2025.1.ORL is PROTECTED"
        print_protected "This version contains historical content that should not be modified."
        print_protected "Protection system is working correctly!"
    else
        print_error "Protection system failed - 2025.1.ORL should be PROTECTED"
    fi
    
    echo ""
    
    print_status "Testing restricted warning for 2025.2.NAS..."
    check_version_protection "2025.2.NAS"
    protection_code=$?
    
    if [ $protection_code -eq 1 ]; then
        print_warning "⚠️ RESTRICTED VERSION: 2025.2.NAS"
        print_warning "This is an active version that may be in use"
        print_success "Restriction system is working correctly!"
    else
        print_error "Restriction system failed - 2025.2.NAS should be RESTRICTED"
    fi
    
    echo ""
    
    print_status "Testing flexible access for 2025.3.TOR..."
    check_version_protection "2025.3.TOR"
    protection_code=$?
    
    if [ $protection_code -eq 0 ]; then
        print_success "✅ FLEXIBLE VERSION: 2025.3.TOR"
        print_success "This version can be deployed without restrictions"
        print_success "Flexible system is working correctly!"
    else
        print_error "Flexible system failed - 2025.3.TOR should be FLEXIBLE"
    fi
}

show_protection_summary() {
    echo ""
    print_status "🛡️ Protection System Summary:"
    echo "================================"
    echo ""
    echo "🔒 PROTECTED Versions (Historical/Critical):"
    for version in "${PROTECTED_VERSIONS[@]}"; do
        echo "  - $version (Orlando workshop - historical)"
    done
    echo ""
    echo "⚠️ RESTRICTED Versions (Active/Current):"
    for version in "${RESTRICTED_VERSIONS[@]}"; do
        echo "  - $version (Nashville workshop - current)"
    done
    echo ""
    echo "✅ FLEXIBLE Versions (Development/Future):"
    for version in "${FLEXIBLE_VERSIONS[@]}"; do
        echo "  - $version (Toronto workshop - placeholder)"
    done
    echo ""
    print_success "Protection system is active and configured!"
}

# Main execution
main() {
    # Test 1: List versions with protection status
    list_versions_with_protection
    
    echo ""
    echo "=" * 50
    echo ""
    
    # Test 2: Test protection blocking
    test_protection_blocking
    
    echo ""
    echo "=" * 50
    echo ""
    
    # Test 3: Show protection summary
    show_protection_summary
    
    echo ""
    print_status "🎯 Next Steps:"
    echo "  1. Use 'mkdocs-version-control-protected.sh' for safe deployments"
    echo "  2. Use 'mike-safe-operations.sh' for individual operations"
    echo "  3. Check 'mike-protection.conf' to modify protection settings"
    echo "  4. Review 'MIKE-PROTECTION-README.md' for detailed documentation"
    echo ""
    print_success "Mike Protection System Test Complete! 🎉"
}

# Run the test
main "$@"
