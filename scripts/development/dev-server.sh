#!/bin/bash

#
# Zeppelin Home - Development Server Script
# 
# This script starts a local development server with Jekyll for testing
# and development purposes.
#
# Usage:
#   ./dev-server.sh [--port PORT] [--host HOST] [--watch]
#
# Options:
#   --port PORT    Specify port (default: 4000)
#   --host HOST    Specify host (default: localhost)
#   --watch        Enable file watching and auto-regeneration
#
# Author: Zeppelin Home Team
# Version: 1.0.0
#

set -euo pipefail

# Configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
SERVER_PORT=4000
SERVER_HOST="localhost"
ENABLE_WATCH=false

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --port)
            SERVER_PORT="$2"
            shift 2
            ;;
        --host)
            SERVER_HOST="$2"
            shift 2
            ;;
        --watch)
            ENABLE_WATCH=true
            shift
            ;;
        *)
            echo "Unknown option: $1"
            echo "Usage: $0 [--port PORT] [--host HOST] [--watch]"
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

# Cleanup function for graceful shutdown
cleanup() {
    log_info "Shutting down development server..."
    exit 0
}

# Set up signal handlers
trap cleanup SIGINT SIGTERM

# Change to project root
cd "$PROJECT_ROOT"

log_info "Starting Zeppelin Home development server..."
log_info "Host: $SERVER_HOST"
log_info "Port: $SERVER_PORT"
log_info "Watch mode: $ENABLE_WATCH"

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

# Set environment for development
export JEKYLL_ENV=development

# Build Jekyll serve command
JEKYLL_CMD="bundle exec jekyll serve --host $SERVER_HOST --port $SERVER_PORT"

if [[ "$ENABLE_WATCH" == "true" ]]; then
    JEKYLL_CMD="$JEKYLL_CMD --watch --incremental"
fi

# Add development-specific options
JEKYLL_CMD="$JEKYLL_CMD --drafts --future --unpublished"

log_info "Starting Jekyll server..."
log_success "Development server will be available at: http://$SERVER_HOST:$SERVER_PORT"
log_info "Press Ctrl+C to stop the server"
log_info "Command: $JEKYLL_CMD"

# Start the server
exec $JEKYLL_CMD