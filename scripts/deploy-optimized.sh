#!/bin/bash

# Zeppelin Home - Optimized Deployment and Development Script
# Consolidated script for all development, build, and deployment tasks

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
NC='\033[0m' # No Color

# Configuration
BUNDLE_PATH="vendor/bundle"
SITE_DIR="_site"

# Functions
print_header() {
    echo -e "${BLUE}🚀 Zeppelin Home - Optimized Deploy Script${NC}"
    echo "============================================="
}

print_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

print_info() {
    echo -e "${PURPLE}📋 $1${NC}"
}

# Enhanced environment check
check_environment() {
    if [[ ! -f "_config.yml" || ! -f "Gemfile" ]]; then
        print_error "This script must be run from the repository root!"
        exit 1
    fi
    
    print_success "Environment check passed"
    
    # Check for required tools
    if ! command -v bundle &> /dev/null; then
        print_error "Bundler is not installed. Please install with: gem install bundler"
        exit 1
    fi
    
    # Set bundle path configuration for faster subsequent installs
    bundle config set --local path "${BUNDLE_PATH}" 2>/dev/null || true
}

# Optimized dependency installation
install_deps() {
    echo -e "${BLUE}📦 Installing Jekyll dependencies...${NC}"
    
    # Use parallel jobs for faster installation
    bundle install --jobs 4 --retry 3
    print_success "Dependencies installed"
}

# Optimized build with caching
build_site() {
    echo -e "${BLUE}🔨 Building Jekyll site (optimized)...${NC}"
    
    # Clean previous build artifacts for fresh build
    bundle exec jekyll clean
    
    # Build with optimizations
    bundle exec jekyll build --verbose --profile
    print_success "Site built successfully"
    
    # Show build statistics
    if [[ -d "${SITE_DIR}" ]]; then
        site_size=$(du -sh "${SITE_DIR}" | cut -f1)
        file_count=$(find "${SITE_DIR}" -type f | wc -l)
        print_info "Built site: ${site_size}, ${file_count} files"
    fi
}

# Development server with enhanced features
serve_site() {
    echo -e "${BLUE}🌐 Starting optimized development server...${NC}"
    echo "Site will be available at: http://localhost:4000"
    echo "Press Ctrl+C to stop the server"
    
    # Serve with optimizations and better error handling
    bundle exec jekyll serve \
        --livereload \
        --open-url \
        --incremental \
        --profile \
        --trace
}

# Enhanced clean function
clean() {
    echo -e "${BLUE}🧹 Cleaning all build artifacts...${NC}"
    
    # Remove Jekyll build artifacts
    bundle exec jekyll clean 2>/dev/null || true
    
    # Remove additional cache files
    rm -rf .sass-cache .jekyll-cache .jekyll-metadata .bundle
    
    # Remove any temporary files
    find . -name "*.tmp" -type f -delete 2>/dev/null || true
    find . -name "*.bak" -type f -delete 2>/dev/null || true
    
    print_success "Clean completed"
}

# Comprehensive test build with validation
test_build() {
    echo -e "${BLUE}🧪 Running comprehensive build test...${NC}"
    
    # Build with strict mode
    bundle exec jekyll build --verbose --strict_front_matter --profile
    
    # Validate critical files
    critical_files=(
        "_site/index.html"
        "_site/docs/index.html"
        "_site/feed.xml"
        "_site/sitemap.xml"
        "_site/assets/main.css"
    )
    
    for file in "${critical_files[@]}"; do
        if [[ ! -f "$file" ]]; then
            print_error "Critical file missing: $file"
            exit 1
        fi
    done
    
    # Validate media assets
    media_files=(
        "_site/media/zeppelin-logo.png"
        "_site/media/dashboard-preview.png"
        "_site/media/community-banner.png"
    )
    
    for file in "${media_files[@]}"; do
        if [[ ! -f "$file" ]]; then
            print_warning "Media file missing: $file"
        fi
    done
    
    print_success "All critical files generated successfully"
    
    # Show performance statistics
    if command -v wc &> /dev/null; then
        html_files=$(find _site -name "*.html" | wc -l)
        css_files=$(find _site -name "*.css" | wc -l)
        print_info "Generated: ${html_files} HTML files, ${css_files} CSS files"
    fi
}

# Git integration for content management
git_status() {
    echo -e "${BLUE}📊 Git repository status...${NC}"
    
    if ! git rev-parse --git-dir > /dev/null 2>&1; then
        print_error "Not in a git repository!"
        exit 1
    fi
    
    current_branch=$(git branch --show-current)
    print_success "Current branch: $current_branch"
    
    if git diff-index --quiet HEAD --; then
        print_success "Working directory is clean"
    else
        print_warning "You have uncommitted changes:"
        git status --short
    fi
}

# Quick deployment workflow
quick_deploy() {
    local message="${1:-Update site content}"
    
    echo -e "${BLUE}⚡ Quick deployment workflow...${NC}"
    
    # Test build first
    test_build
    
    # Stage changes
    git add .
    
    if git diff-index --quiet --cached HEAD --; then
        print_warning "No changes to commit"
        return 0
    fi
    
    # Commit and push
    git commit -m "$message"
    current_branch=$(git branch --show-current)
    git push origin "$current_branch"
    
    print_success "Changes deployed successfully!"
    print_info "GitHub Actions will build and deploy to GitHub Pages"
}

# Main script logic
print_header

case "${1:-help}" in
    "install")
        check_environment
        install_deps
        ;;
    "build")
        check_environment
        build_site
        ;;
    "serve")
        check_environment
        install_deps
        serve_site
        ;;
    "test")
        check_environment
        install_deps
        test_build
        ;;
    "clean")
        check_environment
        clean
        ;;
    "status")
        git_status
        ;;
    "deploy")
        check_environment
        quick_deploy "$2"
        ;;
    "help"|*)
        echo "Usage: $0 {install|build|serve|test|clean|status|deploy|help}"
        echo ""
        echo "Commands:"
        echo "  install       - Install Jekyll dependencies with optimizations"
        echo "  build         - Build the Jekyll site with performance profiling"
        echo "  serve         - Start local development server with live reload"
        echo "  test          - Comprehensive build test and validation"
        echo "  clean         - Clean all build artifacts and cache files"
        echo "  status        - Check git repository status"
        echo "  deploy [MSG]  - Quick test, commit, and push workflow"
        echo "  help          - Show this help message"
        echo ""
        echo "Examples:"
        echo "  $0 serve                    # Start development server"
        echo "  $0 test                     # Test build for CI"
        echo "  $0 deploy 'Update content'  # Quick deployment"
        ;;
esac