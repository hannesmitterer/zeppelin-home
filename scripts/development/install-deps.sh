#!/bin/bash

#
# Zeppelin Home - Dependency Installation Script
# 
# This script installs and manages dependencies for the Zeppelin Home project.
#
# Usage:
#   ./install-deps.sh [--update] [--clean] [--dev]
#
# Options:
#   --update  Update existing dependencies to latest versions
#   --clean   Clean install (remove existing dependencies first)
#   --dev     Install development dependencies
#
# Author: Zeppelin Home Team
# Version: 1.0.0
#

set -euo pipefail

# Configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
UPDATE_DEPS=false
CLEAN_INSTALL=false
DEV_DEPS=false

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --update)
            UPDATE_DEPS=true
            shift
            ;;
        --clean)
            CLEAN_INSTALL=true
            shift
            ;;
        --dev)
            DEV_DEPS=true
            shift
            ;;
        *)
            echo "Unknown option: $1"
            echo "Usage: $0 [--update] [--clean] [--dev]"
            exit 1
            ;;
    esac
done

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

# Change to project root
cd "$PROJECT_ROOT"

log_info "Starting dependency installation..."
log_info "Update mode: $UPDATE_DEPS"
log_info "Clean install: $CLEAN_INSTALL"
log_info "Development dependencies: $DEV_DEPS"

# Check for required tools
if ! command -v ruby &> /dev/null; then
    log_error "Ruby is required but not installed."
    exit 1
fi

if ! command -v bundle &> /dev/null; then
    log_info "Installing Bundler..."
    gem install bundler
fi

# Clean installation if requested
if [[ "$CLEAN_INSTALL" == "true" ]]; then
    log_info "Performing clean installation..."
    
    # Remove existing installations
    rm -rf vendor/bundle
    rm -f Gemfile.lock
    
    log_info "Cleaned existing dependencies"
fi

# Build bundle command
BUNDLE_CMD="bundle install --path vendor/bundle"

if [[ "$DEV_DEPS" == "true" ]]; then
    BUNDLE_CMD="$BUNDLE_CMD --with development"
else
    BUNDLE_CMD="$BUNDLE_CMD --without development"
fi

if [[ "$UPDATE_DEPS" == "true" ]]; then
    log_info "Updating dependencies..."
    bundle update
else
    log_info "Installing dependencies..."
fi

# Execute bundle install
eval $BUNDLE_CMD

# Verify installation
if [[ -d "vendor/bundle" ]] && [[ -f "Gemfile.lock" ]]; then
    log_success "Dependencies installed successfully!"
    
    # Show installed gems
    log_info "Installed gems:"
    bundle list --paths=false | head -10
    
    TOTAL_GEMS=$(bundle list --paths=false | wc -l)
    log_info "Total gems installed: $TOTAL_GEMS"
else
    log_error "Dependency installation failed!"
    exit 1
fi

log_success "Dependency installation completed!"