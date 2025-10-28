#!/bin/bash

# 🧪 Campus Workshop Deployment Test Suite
# =========================================
# Comprehensive testing for deployment system
# 
# Usage:
#   ./scripts/test-deployment.sh [OPTIONS]
#
# Options:
#   --quick             Run only quick tests (no server tests)
#   --server-only       Run only server connectivity tests
#   --full              Run complete test suite (default)
#   --help              Show this help message

set -euo pipefail

# Configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
SERVER_HOST="acws.duckdns.org"
SERVER_USER="ubuntu"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
NC='\033[0m'

# Test counters
TESTS_RUN=0
TESTS_PASSED=0
TESTS_FAILED=0

# Logging functions
log_test() {
    echo -e "${BLUE}🧪 TEST: $1${NC}"
    ((TESTS_RUN++))
}

log_pass() {
    echo -e "${GREEN}✅ PASS: $1${NC}"
    ((TESTS_PASSED++))
}

log_fail() {
    echo -e "${RED}❌ FAIL: $1${NC}"
    ((TESTS_FAILED++))
}

log_info() {
    echo -e "${YELLOW}ℹ️  $1${NC}"
}

log_step() {
    echo -e "${PURPLE}🔄 $1${NC}"
}

# Parse arguments
TEST_MODE="full"
while [[ $# -gt 0 ]]; do
    case $1 in
        --quick)
            TEST_MODE="quick"
            shift
            ;;
        --server-only)
            TEST_MODE="server"
            shift
            ;;
        --full)
            TEST_MODE="full"
            shift
            ;;
        --help)
            cat << EOF
🧪 Campus Workshop Deployment Test Suite

USAGE:
    $0 [OPTIONS]

OPTIONS:
    --quick             Run only quick tests (no server tests)
    --server-only       Run only server connectivity tests  
    --full              Run complete test suite (default)
    --help              Show this help message

TESTS INCLUDED:
    Quick Tests:
    - File structure validation
    - CSV format validation
    - MkDocs configuration
    - ATD Token format checking
    - Virtual environment setup

    Server Tests:
    - SSH connectivity
    - Server disk space
    - Nginx status
    - Site accessibility
    - Orlando protection verification

EOF
            exit 0
            ;;
        *)
            echo "Unknown option: $1"
            exit 1
            ;;
    esac
done

# Banner
echo -e "${PURPLE}"
cat << 'EOF'
🧪 DEPLOYMENT TEST SUITE
========================
Validating Campus Workshop Deployment System
EOF
echo -e "${NC}"

log_info "Test Mode: $TEST_MODE"
log_info "Project Root: $PROJECT_ROOT"
echo

cd "$PROJECT_ROOT"

# Quick Tests
if [[ "$TEST_MODE" == "quick" || "$TEST_MODE" == "full" ]]; then
    log_step "Running Quick Tests..."
    echo

    # Test 1: Required Files
    log_test "Required files exist"
    required_files=(
        "mkdocs.yml"
        "requirements.txt"
        "data/lab_assignment.csv"
        "docs/a_wired/a02_atd.md"
        "scripts/deploy.sh"
        ".github/workflows/automated-update.yml"
    )
    
    missing_files=()
    for file in "${required_files[@]}"; do
        if [ ! -f "$file" ]; then
            missing_files+=("$file")
        fi
    done
    
    if [ ${#missing_files[@]} -eq 0 ]; then
        log_pass "All required files exist"
    else
        log_fail "Missing files: ${missing_files[*]}"
    fi

    # Test 2: CSV Format
    log_test "ATD Token CSV format"
    if [ -f "data/lab_assignment.csv" ]; then
        # Check for ATD Lab entries
        atd_count=$(grep -c "🚀 ATD Lab" data/lab_assignment.csv || echo "0")
        if [ "$atd_count" -gt "0" ]; then
            log_pass "Found $atd_count ATD Lab entries"
            
            # Check for proper target attributes
            target_count=$(grep -c 'target="_blank"' data/lab_assignment.csv || echo "0")
            if [ "$target_count" -gt "0" ]; then
                log_pass "Found $target_count properly formatted target attributes"
            else
                log_fail "No properly formatted target attributes found"
            fi
        else
            log_fail "No ATD Lab entries found in CSV"
        fi
    else
        log_fail "CSV file not found"
    fi

    # Test 3: MkDocs Configuration
    log_test "MkDocs configuration"
    if command -v python3 &> /dev/null; then
        if python3 -c "import yaml; yaml.safe_load(open('mkdocs.yml'))" 2>/dev/null; then
            log_pass "MkDocs configuration is valid YAML"
        else
            log_fail "MkDocs configuration has YAML syntax errors"
        fi
    else
        log_info "Python3 not available, skipping YAML validation"
    fi

    # Test 4: Virtual Environment
    log_test "Virtual environment setup"
    if [ -d ".venv" ]; then
        log_pass "Virtual environment directory exists"
        
        if [ -f ".venv/bin/activate" ]; then
            log_pass "Virtual environment activation script exists"
        else
            log_fail "Virtual environment activation script missing"
        fi
    else
        log_info "Virtual environment not found (will be created during deployment)"
    fi

    # Test 5: UV Package Manager
    log_test "UV package manager availability"
    if command -v uv &> /dev/null; then
        uv_version=$(uv --version 2>/dev/null || echo "unknown")
        log_pass "UV is available: $uv_version"
    else
        log_info "UV not found (will be installed during deployment)"
    fi

    # Test 6: Deploy Script
    log_test "Deploy script permissions"
    if [ -x "scripts/deploy.sh" ]; then
        log_pass "Deploy script is executable"
    else
        log_fail "Deploy script is not executable"
    fi

    # Test 7: GitHub Workflow
    log_test "GitHub Actions workflow syntax"
    if command -v python3 &> /dev/null; then
        if python3 -c "import yaml; yaml.safe_load(open('.github/workflows/automated-update.yml'))" 2>/dev/null; then
            log_pass "GitHub Actions workflow is valid YAML"
        else
            log_fail "GitHub Actions workflow has YAML syntax errors"
        fi
    else
        log_info "Python3 not available, skipping workflow validation"
    fi

    echo
fi

# Server Tests
if [[ "$TEST_MODE" == "server" || "$TEST_MODE" == "full" ]]; then
    log_step "Running Server Tests..."
    echo

    # Test 8: SSH Connectivity
    log_test "SSH connectivity to server"
    if ssh -o ConnectTimeout=10 -o BatchMode=yes "$SERVER_USER@$SERVER_HOST" "echo 'SSH test successful'" 2>/dev/null; then
        log_pass "SSH connection successful"
        
        # Test 9: Server Disk Space
        log_test "Server disk space"
        available_space=$(ssh "$SERVER_USER@$SERVER_HOST" "df /var/www | tail -1 | awk '{print \$4}'" 2>/dev/null || echo "0")
        if [ "$available_space" -gt 2097152 ]; then  # 2GB in KB
            space_gb=$((available_space / 1024 / 1024))
            log_pass "Sufficient disk space: ${space_gb}GB available"
        else
            log_fail "Insufficient disk space: ${available_space}KB available (need 2GB+)"
        fi

        # Test 10: Nginx Status
        log_test "Nginx service status"
        if ssh "$SERVER_USER@$SERVER_HOST" "systemctl is-active --quiet nginx" 2>/dev/null; then
            log_pass "Nginx is running"
        else
            log_fail "Nginx is not running"
        fi

        # Test 11: Site Directory
        log_test "Site directory structure"
        if ssh "$SERVER_USER@$SERVER_HOST" "[ -d '/var/www/mkdocs/site' ]" 2>/dev/null; then
            log_pass "Site directory exists"
            
            # Check for Orlando
            if ssh "$SERVER_USER@$SERVER_HOST" "[ -d '/var/www/mkdocs/site/2025.1.ORL' ]" 2>/dev/null; then
                log_pass "Orlando 2025.1.ORL directory exists"
            else
                log_info "Orlando 2025.1.ORL directory not found"
            fi
        else
            log_fail "Site directory does not exist"
        fi

        # Test 12: Site Accessibility
        log_test "Site accessibility"
        if curl -s -o /dev/null -w "%{http_code}" "http://$SERVER_HOST/" | grep -q "200\|301\|302"; then
            log_pass "Site is accessible"
        else
            log_fail "Site is not accessible"
        fi

    else
        log_fail "SSH connection failed"
        log_info "Skipping remaining server tests due to connection failure"
    fi

    echo
fi

# Test Summary
log_step "Test Summary"
echo
echo -e "${PURPLE}📊 TEST RESULTS${NC}"
echo "==============="
echo -e "Tests Run:    ${BLUE}$TESTS_RUN${NC}"
echo -e "Tests Passed: ${GREEN}$TESTS_PASSED${NC}"
echo -e "Tests Failed: ${RED}$TESTS_FAILED${NC}"

if [ $TESTS_FAILED -eq 0 ]; then
    echo
    echo -e "${GREEN}🎉 ALL TESTS PASSED!${NC}"
    echo -e "${GREEN}✅ Deployment system is ready${NC}"
    exit 0
else
    echo
    echo -e "${RED}❌ SOME TESTS FAILED${NC}"
    echo -e "${YELLOW}⚠️  Please address the failed tests before deployment${NC}"
    exit 1
fi
