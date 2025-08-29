#!/bin/bash

#
# Zeppelin Home - Test Script
# 
# This script runs various tests and validations for the Zeppelin Home project.
#
# Usage:
#   ./test.sh [--build] [--links] [--html] [--all]
#
# Options:
#   --build  Test Jekyll build process
#   --links  Check for broken links
#   --html   Validate HTML markup
#   --all    Run all tests
#
# Author: Zeppelin Home Team
# Version: 1.0.0
#

set -euo pipefail

# Configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
TEST_BUILD=false
TEST_LINKS=false
TEST_HTML=false
RUN_ALL=false

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --build)
            TEST_BUILD=true
            shift
            ;;
        --links)
            TEST_LINKS=true
            shift
            ;;
        --html)
            TEST_HTML=true
            shift
            ;;
        --all)
            RUN_ALL=true
            shift
            ;;
        *)
            echo "Unknown option: $1"
            echo "Usage: $0 [--build] [--links] [--html] [--all]"
            exit 1
            ;;
    esac
done

# Set all tests if --all is specified
if [[ "$RUN_ALL" == "true" ]]; then
    TEST_BUILD=true
    TEST_LINKS=true
    TEST_HTML=true
fi

# If no specific test is selected, default to build test
if [[ "$TEST_BUILD" == "false" && "$TEST_LINKS" == "false" && "$TEST_HTML" == "false" ]]; then
    TEST_BUILD=true
fi

# Logging functions
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Test results tracking
TESTS_PASSED=0
TESTS_FAILED=0

# Record test result
record_result() {
    local test_name="$1"
    local result="$2"
    
    if [[ "$result" == "PASS" ]]; then
        log_success "✓ $test_name"
        ((TESTS_PASSED++))
    else
        log_error "✗ $test_name"
        ((TESTS_FAILED++))
    fi
}

# Change to project root
cd "$PROJECT_ROOT"

log_info "Starting Zeppelin Home test suite..."

# Test Jekyll build
if [[ "$TEST_BUILD" == "true" ]]; then
    log_info "Testing Jekyll build process..."
    
    if bundle exec jekyll build --quiet; then
        if [[ -d "_site" ]] && [[ -f "_site/index.html" ]]; then
            record_result "Jekyll Build Test" "PASS"
        else
            record_result "Jekyll Build Test" "FAIL"
        fi
    else
        record_result "Jekyll Build Test" "FAIL"
    fi
fi

# Test for broken links
if [[ "$TEST_LINKS" == "true" ]]; then
    log_info "Checking for broken internal links..."
    
    if [[ ! -d "_site" ]]; then
        log_warning "Site not built, building now..."
        bundle exec jekyll build --quiet
    fi
    
    # Simple link check for internal references
    BROKEN_LINKS=0
    
    # Check for broken internal links in HTML files
    find _site -name "*.html" -exec grep -l "href.*\.md\|src.*\.md" {} \; > /tmp/potential_broken_links.txt 2>/dev/null || true
    
    if [[ -s /tmp/potential_broken_links.txt ]]; then
        log_warning "Found potential broken links (markdown files referenced in HTML)"
        BROKEN_LINKS=1
    fi
    
    # Check for missing images referenced in docs
    grep -r "!\[.*\](" docs/ | grep -o "media/[^)]*" | while read -r img_path; do
        if [[ ! -f "$img_path" ]]; then
            log_warning "Missing image: $img_path"
            BROKEN_LINKS=1
        fi
    done 2>/dev/null || true
    
    if [[ "$BROKEN_LINKS" == "0" ]]; then
        record_result "Link Check Test" "PASS"
    else
        record_result "Link Check Test" "FAIL"
    fi
    
    rm -f /tmp/potential_broken_links.txt
fi

# Test HTML validation
if [[ "$TEST_HTML" == "true" ]]; then
    log_info "Validating HTML markup..."
    
    if [[ ! -d "_site" ]]; then
        log_warning "Site not built, building now..."
        bundle exec jekyll build --quiet
    fi
    
    # Basic HTML validation checks
    HTML_ERRORS=0
    
    # Check for basic HTML structure
    find _site -name "*.html" | while read -r html_file; do
        if ! grep -q "<html" "$html_file"; then
            log_warning "Missing <html> tag in: $html_file"
            HTML_ERRORS=$((HTML_ERRORS + 1))
        fi
        
        if ! grep -q "<head>" "$html_file"; then
            log_warning "Missing <head> tag in: $html_file"
            HTML_ERRORS=$((HTML_ERRORS + 1))
        fi
        
        if ! grep -q "<title>" "$html_file"; then
            log_warning "Missing <title> tag in: $html_file"
            HTML_ERRORS=$((HTML_ERRORS + 1))
        fi
    done
    
    if [[ "$HTML_ERRORS" == "0" ]]; then
        record_result "HTML Validation Test" "PASS"
    else
        record_result "HTML Validation Test" "FAIL"
    fi
fi

# Test summary
log_info "Test Summary:"
log_info "Tests passed: $TESTS_PASSED"
log_info "Tests failed: $TESTS_FAILED"

if [[ "$TESTS_FAILED" == "0" ]]; then
    log_success "All tests passed! 🎉"
    exit 0
else
    log_error "Some tests failed. Please review the output above."
    exit 1
fi