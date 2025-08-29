#!/bin/bash

#
# Zeppelin Home - Permissions Setup Script
# 
# This script sets appropriate permissions on all scripts and files
# in the Zeppelin Home project to ensure maximum security and functionality.
#
# Usage:
#   ./permissions.sh [--fix] [--check] [--secure]
#
# Options:
#   --fix     Fix permissions on all files
#   --check   Check current permissions without changing
#   --secure  Apply secure permissions (more restrictive)
#
# Author: Zeppelin Home Team
# Version: 1.0.0
#

set -euo pipefail

# Configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
FIX_PERMISSIONS=false
CHECK_ONLY=false
SECURE_MODE=false

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --fix)
            FIX_PERMISSIONS=true
            shift
            ;;
        --check)
            CHECK_ONLY=true
            shift
            ;;
        --secure)
            SECURE_MODE=true
            FIX_PERMISSIONS=true
            shift
            ;;
        *)
            echo "Unknown option: $1"
            echo "Usage: $0 [--fix] [--check] [--secure]"
            exit 1
            ;;
    esac
done

# Default to check if no options specified
if [[ "$FIX_PERMISSIONS" == "false" && "$CHECK_ONLY" == "false" ]]; then
    CHECK_ONLY=true
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

# Check permissions on a file
check_permissions() {
    local file="$1"
    local expected="$2"
    local current
    
    if [[ -f "$file" ]]; then
        current=$(stat -c "%a" "$file" 2>/dev/null || stat -f "%A" "$file" 2>/dev/null)
        if [[ "$current" == "$expected" ]]; then
            log_success "✓ $file ($current)"
        else
            log_warning "✗ $file (current: $current, expected: $expected)"
            return 1
        fi
    else
        log_error "File not found: $file"
        return 1
    fi
    return 0
}

# Set permissions on a file
set_permissions() {
    local file="$1"
    local perms="$2"
    local description="$3"
    
    if [[ -f "$file" ]]; then
        chmod "$perms" "$file"
        log_info "Set $description permissions on: $file ($perms)"
    fi
}

# Change to project root
cd "$PROJECT_ROOT"

log_info "Zeppelin Home Permissions Management"
log_info "Mode: $([ "$CHECK_ONLY" == "true" ] && echo "CHECK" || echo "FIX")"
log_info "Secure mode: $SECURE_MODE"

PERMISSION_ERRORS=0

# Define permission sets based on mode
if [[ "$SECURE_MODE" == "true" ]]; then
    SCRIPT_PERMS="700"  # rwx------
    CONFIG_PERMS="600"  # rw-------
    DOC_PERMS="644"     # rw-r--r--
else
    SCRIPT_PERMS="755"  # rwxr-xr-x
    CONFIG_PERMS="644"  # rw-r--r--
    DOC_PERMS="644"     # rw-r--r--
fi

# Check/fix script files
log_info "Processing shell scripts..."
find scripts -name "*.sh" -type f | while read -r script; do
    if [[ "$CHECK_ONLY" == "true" ]]; then
        check_permissions "$script" "$SCRIPT_PERMS" || ((PERMISSION_ERRORS++))
    else
        set_permissions "$script" "$SCRIPT_PERMS" "executable"
    fi
done

# Check/fix JavaScript files
log_info "Processing JavaScript files..."
find scripts -name "*.js" -type f | while read -r jsfile; do
    if [[ "$CHECK_ONLY" == "true" ]]; then
        check_permissions "$jsfile" "$CONFIG_PERMS" || ((PERMISSION_ERRORS++))
    else
        set_permissions "$jsfile" "$CONFIG_PERMS" "readable"
    fi
done

# Check/fix configuration files
log_info "Processing configuration files..."
for config_file in Gemfile _config.yml .gitignore; do
    if [[ -f "$config_file" ]]; then
        if [[ "$CHECK_ONLY" == "true" ]]; then
            check_permissions "$config_file" "$CONFIG_PERMS" || ((PERMISSION_ERRORS++))
        else
            set_permissions "$config_file" "$CONFIG_PERMS" "configuration"
        fi
    fi
done

# Check/fix workflow files  
log_info "Processing workflow files..."
find .github -name "*.yml" -type f 2>/dev/null | while read -r workflow; do
    if [[ "$CHECK_ONLY" == "true" ]]; then
        check_permissions "$workflow" "$CONFIG_PERMS" || ((PERMISSION_ERRORS++))
    else
        set_permissions "$workflow" "$CONFIG_PERMS" "workflow"
    fi
done

# Check/fix documentation files
log_info "Processing documentation files..."
find . -maxdepth 2 -name "*.md" -type f | while read -r doc; do
    if [[ "$CHECK_ONLY" == "true" ]]; then
        check_permissions "$doc" "$DOC_PERMS" || ((PERMISSION_ERRORS++))
    else
        set_permissions "$doc" "$DOC_PERMS" "documentation"
    fi
done

# Directory permissions
log_info "Processing directory permissions..."
DIRECTORIES=("scripts" "scripts/deployment" "scripts/web" "scripts/development" "scripts/utils" ".github" ".github/workflows")

for dir in "${DIRECTORIES[@]}"; do
    if [[ -d "$dir" ]]; then
        if [[ "$CHECK_ONLY" == "true" ]]; then
            current=$(stat -c "%a" "$dir" 2>/dev/null || stat -f "%A" "$dir" 2>/dev/null)
            if [[ "$current" == "755" ]]; then
                log_success "✓ Directory $dir (755)"
            else
                log_warning "✗ Directory $dir (current: $current, expected: 755)"
                ((PERMISSION_ERRORS++))
            fi
        else
            chmod 755 "$dir"
            log_info "Set directory permissions on: $dir (755)"
        fi
    fi
done

# Special handling for deployment scripts in secure mode
if [[ "$SECURE_MODE" == "true" && "$FIX_PERMISSIONS" == "true" ]]; then
    log_info "Applying secure permissions to deployment scripts..."
    find scripts/deployment -name "*.sh" -exec chmod 700 {} \;
    log_warning "Deployment scripts set to owner-only access (700)"
fi

# Summary
if [[ "$CHECK_ONLY" == "true" ]]; then
    if [[ "$PERMISSION_ERRORS" == "0" ]]; then
        log_success "All permissions are correctly set!"
    else
        log_error "Found $PERMISSION_ERRORS permission issues. Run with --fix to resolve."
        exit 1
    fi
else
    log_success "Permissions have been updated successfully!"
    log_info "Script permissions: $SCRIPT_PERMS"
    log_info "Configuration permissions: $CONFIG_PERMS"
    log_info "Documentation permissions: $DOC_PERMS"
fi

log_success "Permission management completed!"