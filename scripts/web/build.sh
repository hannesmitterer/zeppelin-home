#!/bin/bash

#
# Zeppelin Home - Jekyll Build Script
# 
# This script handles building the Jekyll site with proper configuration
# for both development and production environments.
#
# Usage:
#   ./build.sh [development|production]
#
# Author: Zeppelin Home Team
# Version: 1.0.0
#

set -euo pipefail

# Configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
BUILD_ENV="${1:-production}"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

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

log_info "Starting Jekyll build process..."
log_info "Environment: $BUILD_ENV"
log_info "Project root: $PROJECT_ROOT"

# Check if Gemfile exists
if [[ ! -f "Gemfile" ]]; then
    log_error "Gemfile not found! Please run this script from the project root."
    exit 1
fi

# Install dependencies if needed
if [[ ! -d "vendor/bundle" ]] || [[ ! -f "Gemfile.lock" ]]; then
    log_info "Installing Ruby dependencies..."
    bundle install --path vendor/bundle
fi

# Set environment variables
export JEKYLL_ENV="$BUILD_ENV"

# Build the site based on environment
if [[ "$BUILD_ENV" == "development" ]]; then
    log_info "Building site for development..."
    bundle exec jekyll build --drafts --incremental
else
    log_info "Building site for production..."
    bundle exec jekyll build
fi

# Verify build was successful
if [[ -d "_site" ]]; then
    log_success "Jekyll build completed successfully!"
    log_info "Site built in: $PROJECT_ROOT/_site"
    
    # Show build statistics
    TOTAL_FILES=$(find _site -type f | wc -l)
    SITE_SIZE=$(du -sh _site | cut -f1)
    log_info "Total files: $TOTAL_FILES"
    log_info "Total size: $SITE_SIZE"
else
    log_error "Build failed - _site directory not created"
    exit 1
fi

log_success "Build process completed!"