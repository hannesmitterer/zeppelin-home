#!/bin/bash

#
# Zeppelin Home - Initial Setup Script
# 
# This script performs initial setup for the Zeppelin Home project,
# including dependency installation, configuration, and permissions.
#
# Usage:
#   ./setup.sh [--dev] [--full]
#
# Options:
#   --dev     Setup for development environment
#   --full    Perform full setup including optional components
#
# Author: Zeppelin Home Team
# Version: 1.0.0
#

set -euo pipefail

# Configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
DEV_MODE=false
FULL_SETUP=false

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --dev)
            DEV_MODE=true
            shift
            ;;
        --full)
            FULL_SETUP=true
            shift
            ;;
        *)
            echo "Unknown option: $1"
            echo "Usage: $0 [--dev] [--full]"
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

# Check system requirements
check_requirements() {
    log_info "Checking system requirements..."
    
    # Check for Ruby
    if ! command -v ruby &> /dev/null; then
        log_error "Ruby is required but not installed. Please install Ruby 2.7+ first."
        exit 1
    fi
    
    # Check Ruby version
    RUBY_VERSION=$(ruby -v | grep -oE '[0-9]+\.[0-9]+' | head -1)
    log_info "Found Ruby version: $RUBY_VERSION"
    
    # Check for Bundler
    if ! command -v bundle &> /dev/null; then
        log_info "Installing Bundler..."
        gem install bundler
    fi
    
    # Check for Git
    if ! command -v git &> /dev/null; then
        log_error "Git is required but not installed."
        exit 1
    fi
    
    log_success "System requirements check passed!"
}

# Install project dependencies
install_dependencies() {
    log_info "Installing project dependencies..."
    
    cd "$PROJECT_ROOT"
    
    # Install Ruby gems
    if [[ "$DEV_MODE" == "true" ]]; then
        bundle install --with development
    else
        bundle install --without development
    fi
    
    log_success "Dependencies installed successfully!"
}

# Set up directory structure
setup_directories() {
    log_info "Setting up directory structure..."
    
    # Create necessary directories
    mkdir -p "$PROJECT_ROOT"/{_site,vendor,tmp}
    
    # Create media directories if they don't exist
    mkdir -p "$PROJECT_ROOT"/media/{logos,screenshots,banners}
    
    log_success "Directory structure created!"
}

# Set proper permissions on scripts
setup_permissions() {
    log_info "Setting up script permissions..."
    
    # Make all shell scripts executable
    find "$PROJECT_ROOT/scripts" -name "*.sh" -exec chmod +x {} \;
    
    # Set appropriate permissions on directories
    chmod 755 "$PROJECT_ROOT/scripts"
    chmod 755 "$PROJECT_ROOT/scripts"/*
    
    # Secure sensitive scripts (deployment)
    chmod 700 "$PROJECT_ROOT/scripts/deployment/"*.sh 2>/dev/null || true
    
    log_success "Permissions set correctly!"
}

# Initialize Git hooks (if in development mode)
setup_git_hooks() {
    if [[ "$DEV_MODE" == "true" ]]; then
        log_info "Setting up Git hooks for development..."
        
        # Create pre-commit hook
        cat > "$PROJECT_ROOT/.git/hooks/pre-commit" << 'EOF'
#!/bin/bash
# Pre-commit hook for Zeppelin Home

echo "Running pre-commit checks..."

# Check for large files
if git diff --cached --name-only | xargs -I {} find {} -size +1M 2>/dev/null | grep -q .; then
    echo "Error: Large files detected. Please use Git LFS or remove large files."
    exit 1
fi

# Basic Jekyll validation
if [[ -f "_config.yml" ]]; then
    bundle exec jekyll build --dry-run --quiet
    if [[ $? -ne 0 ]]; then
        echo "Error: Jekyll configuration validation failed."
        exit 1
    fi
fi

echo "Pre-commit checks passed!"
EOF
        
        chmod +x "$PROJECT_ROOT/.git/hooks/pre-commit"
        log_success "Git hooks installed!"
    fi
}

# Create configuration files
create_configs() {
    if [[ "$FULL_SETUP" == "true" ]]; then
        log_info "Creating additional configuration files..."
        
        # Create .gitignore additions if needed
        if ! grep -q "vendor/" "$PROJECT_ROOT/.gitignore" 2>/dev/null; then
            echo -e "\n# Ruby/Jekyll\nvendor/\n.bundle/\n_site/" >> "$PROJECT_ROOT/.gitignore"
        fi
        
        log_success "Configuration files updated!"
    fi
}

# Main setup function
main() {
    log_info "Starting Zeppelin Home setup..."
    log_info "Development mode: $DEV_MODE"
    log_info "Full setup: $FULL_SETUP"
    
    check_requirements
    setup_directories
    install_dependencies
    setup_permissions
    setup_git_hooks
    create_configs
    
    log_success "Setup completed successfully!"
    log_info "You can now run the development server with: scripts/development/dev-server.sh"
    log_info "Or build the site with: scripts/web/build.sh"
}

# Run main function
main "$@"