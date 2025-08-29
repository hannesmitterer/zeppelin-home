#!/bin/bash

#
# Zeppelin Home - Deployment Script
# 
# This script handles manual deployment of the Zeppelin Home site to GitHub Pages.
# It builds the site and pushes it to the gh-pages branch with full permissions.
#
# Usage:
#   ./deploy.sh [--force] [--dry-run]
#
# Options:
#   --force    Force push even if there are no changes
#   --dry-run  Show what would be deployed without actually doing it
#
# Author: Zeppelin Home Team
# Version: 1.0.0
#

set -euo pipefail

# Configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
DEPLOY_BRANCH="gh-pages"
FORCE_DEPLOY=false
DRY_RUN=false

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --force)
            FORCE_DEPLOY=true
            shift
            ;;
        --dry-run)
            DRY_RUN=true
            shift
            ;;
        *)
            echo "Unknown option: $1"
            echo "Usage: $0 [--force] [--dry-run]"
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

log_info "Starting deployment process..."

if [[ "$DRY_RUN" == "true" ]]; then
    log_warning "DRY RUN MODE - No actual deployment will occur"
fi

# Check if we're in a git repository
if [[ ! -d ".git" ]]; then
    log_error "Not in a git repository! Please run from the project root."
    exit 1
fi

# Check for uncommitted changes
if [[ -n "$(git status --porcelain)" ]]; then
    log_warning "You have uncommitted changes. Consider committing them first."
    if [[ "$FORCE_DEPLOY" != "true" ]]; then
        read -p "Continue with deployment? (y/N): " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            log_info "Deployment cancelled."
            exit 0
        fi
    fi
fi

# Build the site
log_info "Building site for production..."
if [[ "$DRY_RUN" != "true" ]]; then
    "$SCRIPT_DIR/../web/build.sh" production
else
    log_info "[DRY RUN] Would build site for production"
fi

# Prepare deployment directory
TEMP_DEPLOY_DIR=$(mktemp -d)
log_info "Using temporary directory: $TEMP_DEPLOY_DIR"

if [[ "$DRY_RUN" != "true" ]]; then
    # Copy built site to temp directory
    cp -r _site/* "$TEMP_DEPLOY_DIR/"
    
    # Add .nojekyll file to prevent GitHub from processing with Jekyll
    touch "$TEMP_DEPLOY_DIR/.nojekyll"
    
    # Add CNAME file if it exists in the root
    if [[ -f "CNAME" ]]; then
        cp CNAME "$TEMP_DEPLOY_DIR/"
    fi
    
    # Initialize git repository in temp directory
    cd "$TEMP_DEPLOY_DIR"
    git init
    git config user.name "Zeppelin Home Deploy Bot"
    git config user.email "deploy@zeppelinhome.com"
    
    # Add all files and commit
    git add .
    git commit -m "Deploy site - $(date '+%Y-%m-%d %H:%M:%S')"
    
    # Add remote and force push to gh-pages branch
    git remote add origin "$(cd "$PROJECT_ROOT" && git remote get-url origin)"
    
    log_info "Pushing to $DEPLOY_BRANCH branch..."
    git push --force origin main:$DEPLOY_BRANCH
    
    # Cleanup
    cd "$PROJECT_ROOT"
    rm -rf "$TEMP_DEPLOY_DIR"
    
    log_success "Deployment completed successfully!"
    log_info "Site should be available at: https://$(basename "$(git remote get-url origin)" .git).github.io/"
else
    log_info "[DRY RUN] Would copy _site contents to deployment directory"
    log_info "[DRY RUN] Would create git commit and push to $DEPLOY_BRANCH"
    rm -rf "$TEMP_DEPLOY_DIR"
fi

log_success "Deployment process finished!"