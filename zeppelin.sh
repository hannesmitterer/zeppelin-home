#!/bin/bash

#
# Zeppelin Home - Master Control Script
# 
# This script provides a unified interface to all Zeppelin Home scripts
# and common workflows. It acts as a central command dispatcher.
#
# Usage:
#   ./zeppelin.sh <command> [options]
#
# Commands:
#   setup      - Initial project setup
#   dev        - Start development server
#   build      - Build the site
#   test       - Run tests
#   deploy     - Deploy to GitHub Pages
#   clean      - Clean temporary files
#   permissions - Manage file permissions
#   help       - Show this help message
#
# Author: Zeppelin Home Team
# Version: 1.0.0
#

set -euo pipefail

# Configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$SCRIPT_DIR"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Logging functions
log_info() {
    echo -e "${BLUE}[ZEPPELIN]${NC} $1"
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

log_header() {
    echo -e "${CYAN}[ZEPPELIN HOME]${NC} $1"
}

# Show banner
show_banner() {
    echo -e "${CYAN}"
    echo "╔══════════════════════════════════════════╗"
    echo "║           ZEPPELIN HOME                  ║"
    echo "║     Smart Home Automation Platform       ║"
    echo "║                                          ║"
    echo "║         Master Control Script           ║"
    echo "╚══════════════════════════════════════════╝"
    echo -e "${NC}"
}

# Show help
show_help() {
    show_banner
    echo
    echo "Usage: $0 <command> [options]"
    echo
    echo -e "${CYAN}Available Commands:${NC}"
    echo
    echo -e "  ${GREEN}setup${NC}       - Initial project setup and configuration"
    echo "                 Options: --dev, --full"
    echo -e "  ${GREEN}dev${NC}         - Start development server"
    echo "                 Options: --port PORT, --host HOST, --watch"
    echo -e "  ${GREEN}build${NC}       - Build the Jekyll site"
    echo "                 Options: development|production"
    echo -e "  ${GREEN}test${NC}        - Run comprehensive test suite"
    echo "                 Options: --build, --links, --html, --all"
    echo -e "  ${GREEN}deploy${NC}      - Deploy site to GitHub Pages"
    echo "                 Options: --force, --dry-run"
    echo -e "  ${GREEN}clean${NC}       - Clean temporary files and artifacts"
    echo "                 Options: --all, --build, --temp, --deps"
    echo -e "  ${GREEN}permissions${NC} - Manage file permissions"
    echo "                 Options: --fix, --check, --secure"
    echo -e "  ${GREEN}deps${NC}        - Manage dependencies"
    echo "                 Options: --update, --clean, --dev"
    echo -e "  ${GREEN}help${NC}        - Show this help message"
    echo
    echo -e "${CYAN}Examples:${NC}"
    echo "  $0 setup --dev           # Setup for development"
    echo "  $0 dev --watch           # Start dev server with file watching"
    echo "  $0 build production      # Build for production"
    echo "  $0 test --all           # Run all tests"
    echo "  $0 deploy --dry-run     # Test deployment without executing"
    echo "  $0 clean --all          # Clean everything"
    echo "  $0 permissions --fix    # Fix all permissions"
    echo
    echo -e "${CYAN}Project Structure:${NC}"
    echo "  scripts/deployment/     - Deployment scripts and workflows"
    echo "  scripts/web/           - Web building and frontend scripts"
    echo "  scripts/development/   - Development tools and testing"
    echo "  scripts/utils/         - Utility and maintenance scripts"
    echo
    echo -e "${CYAN}Documentation:${NC}"
    echo "  SCRIPT_DEPLOYMENT_DOCUMENTATION.md - Complete documentation"
    echo "  scripts/README.md                  - Scripts overview"
    echo "  scripts/*/README.md                - Category-specific docs"
    echo
}

# Check if scripts directory exists
check_environment() {
    if [[ ! -d "$PROJECT_ROOT/scripts" ]]; then
        log_error "Scripts directory not found! Please ensure you're running from the project root."
        exit 1
    fi
}

# Execute command
execute_command() {
    local command="$1"
    shift
    
    case "$command" in
        "setup")
            log_header "Running project setup..."
            exec "$PROJECT_ROOT/scripts/deployment/setup.sh" "$@"
            ;;
        "dev")
            log_header "Starting development server..."
            exec "$PROJECT_ROOT/scripts/development/dev-server.sh" "$@"
            ;;
        "build")
            log_header "Building Jekyll site..."
            exec "$PROJECT_ROOT/scripts/web/build.sh" "$@"
            ;;
        "test")
            log_header "Running test suite..."
            exec "$PROJECT_ROOT/scripts/development/test.sh" "$@"
            ;;
        "deploy")
            log_header "Deploying to GitHub Pages..."
            exec "$PROJECT_ROOT/scripts/deployment/deploy.sh" "$@"
            ;;
        "clean")
            log_header "Cleaning project files..."
            exec "$PROJECT_ROOT/scripts/utils/cleanup.sh" "$@"
            ;;
        "permissions")
            log_header "Managing file permissions..."
            exec "$PROJECT_ROOT/scripts/utils/permissions.sh" "$@"
            ;;
        "deps")
            log_header "Managing dependencies..."
            exec "$PROJECT_ROOT/scripts/development/install-deps.sh" "$@"
            ;;
        "help"|"--help"|"-h")
            show_help
            ;;
        *)
            log_error "Unknown command: $command"
            echo
            echo "Run '$0 help' for usage information."
            exit 1
            ;;
    esac
}

# Main execution
main() {
    # Change to project root
    cd "$PROJECT_ROOT"
    
    # Check environment
    check_environment
    
    # Handle no arguments
    if [[ $# -eq 0 ]]; then
        show_help
        exit 0
    fi
    
    # Execute command
    execute_command "$@"
}

# Run main function
main "$@"