#!/bin/bash

#
# Zeppelin Home - Cleanup Script
# 
# This script cleans up temporary files, build artifacts, and other
# generated content that shouldn't be committed to the repository.
#
# Usage:
#   ./cleanup.sh [--all] [--build] [--temp] [--deps]
#
# Options:
#   --all    Clean everything (build artifacts, temp files, dependencies)
#   --build  Clean only build artifacts
#   --temp   Clean only temporary files
#   --deps   Clean dependency cache
#
# Author: Zeppelin Home Team
# Version: 1.0.0
#

set -euo pipefail

# Configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
CLEAN_ALL=false
CLEAN_BUILD=false
CLEAN_TEMP=false
CLEAN_DEPS=false

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --all)
            CLEAN_ALL=true
            shift
            ;;
        --build)
            CLEAN_BUILD=true
            shift
            ;;
        --temp)
            CLEAN_TEMP=true
            shift
            ;;
        --deps)
            CLEAN_DEPS=true
            shift
            ;;
        *)
            echo "Unknown option: $1"
            echo "Usage: $0 [--all] [--build] [--temp] [--deps]"
            exit 1
            ;;
    esac
done

# Set all cleanup types if --all is specified
if [[ "$CLEAN_ALL" == "true" ]]; then
    CLEAN_BUILD=true
    CLEAN_TEMP=true
    CLEAN_DEPS=true
fi

# If no specific cleanup is selected, default to build and temp
if [[ "$CLEAN_BUILD" == "false" && "$CLEAN_TEMP" == "false" && "$CLEAN_DEPS" == "false" ]]; then
    CLEAN_BUILD=true
    CLEAN_TEMP=true
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

# Safe remove function with confirmation for large directories
safe_remove() {
    local path="$1"
    local description="$2"
    
    if [[ -e "$path" ]]; then
        local size=""
        if [[ -d "$path" ]]; then
            size=$(du -sh "$path" 2>/dev/null | cut -f1 || echo "unknown")
            log_info "Removing $description directory: $path (size: $size)"
        else
            log_info "Removing $description: $path"
        fi
        
        rm -rf "$path"
        log_success "Removed $description"
    else
        log_info "$description not found: $path (skipping)"
    fi
}

# Change to project root
cd "$PROJECT_ROOT"

log_info "Starting Zeppelin Home cleanup process..."
log_info "Build artifacts: $CLEAN_BUILD"
log_info "Temporary files: $CLEAN_TEMP"
log_info "Dependencies: $CLEAN_DEPS"

# Clean build artifacts
if [[ "$CLEAN_BUILD" == "true" ]]; then
    log_info "Cleaning build artifacts..."
    
    # Jekyll build output
    safe_remove "_site" "Jekyll build output"
    
    # Jekyll metadata
    safe_remove ".jekyll-metadata" "Jekyll metadata"
    safe_remove ".jekyll-cache" "Jekyll cache"
    
    # Sass cache
    safe_remove ".sass-cache" "Sass cache"
    
    log_success "Build artifacts cleanup completed!"
fi

# Clean temporary files
if [[ "$CLEAN_TEMP" == "true" ]]; then
    log_info "Cleaning temporary files..."
    
    # Temporary directories
    safe_remove "tmp" "temporary files directory"
    safe_remove "temp" "temp directory"
    
    # Log files
    find . -name "*.log" -type f -delete 2>/dev/null || true
    log_info "Removed log files"
    
    # Backup files
    find . -name "*~" -type f -delete 2>/dev/null || true
    find . -name "*.bak" -type f -delete 2>/dev/null || true
    log_info "Removed backup files"
    
    # macOS specific files
    find . -name ".DS_Store" -type f -delete 2>/dev/null || true
    log_info "Removed .DS_Store files"
    
    # Vim swap files
    find . -name "*.swp" -type f -delete 2>/dev/null || true
    find . -name "*.swo" -type f -delete 2>/dev/null || true
    log_info "Removed editor swap files"
    
    # System thumbnail cache
    safe_remove "Thumbs.db" "Windows thumbnail cache"
    
    log_success "Temporary files cleanup completed!"
fi

# Clean dependencies
if [[ "$CLEAN_DEPS" == "true" ]]; then
    log_info "Cleaning dependency caches..."
    
    # Ruby/Bundle dependencies
    safe_remove "vendor" "Ruby vendor directory"
    safe_remove ".bundle" "Bundle configuration"
    
    # Remove Gemfile.lock to force fresh dependency resolution
    if [[ -f "Gemfile.lock" ]]; then
        log_warning "Removing Gemfile.lock (will require bundle install)"
        safe_remove "Gemfile.lock" "Gemfile lock"
    fi
    
    # Node.js dependencies (if they exist)
    safe_remove "node_modules" "Node.js modules"
    safe_remove "package-lock.json" "Node.js package lock"
    
    log_success "Dependencies cleanup completed!"
    log_warning "You will need to run 'bundle install' before building the site again"
fi

# Show disk space saved
log_info "Cleanup process completed successfully!"

# Provide next steps
if [[ "$CLEAN_DEPS" == "true" ]]; then
    log_info "Next steps:"
    log_info "1. Run: scripts/development/install-deps.sh"
    log_info "2. Or run: bundle install"
    log_info "3. Then build with: scripts/web/build.sh"
fi

log_success "All cleanup operations completed! 🧹"