# Development Scripts

This directory contains scripts for local development, testing, and dependency management.

## Scripts

### `dev-server.sh`
Local Jekyll development server.

**Usage**: `./dev-server.sh [--port PORT] [--host HOST] [--watch]`
**Purpose**: Start local server for development and testing
**Default**: http://localhost:4000

**Options**:
- `--port PORT`: Specify custom port (default: 4000)
- `--host HOST`: Specify custom host (default: localhost)
- `--watch`: Enable file watching and auto-regeneration

**Features**:
- Live reload on file changes
- Draft post preview
- Development-optimized builds
- Graceful shutdown handling

### `install-deps.sh`
Dependency installation and management.

**Usage**: `./install-deps.sh [--update] [--clean] [--dev]`
**Purpose**: Install and manage Ruby gems and dependencies

**Options**:
- `--update`: Update existing dependencies to latest versions
- `--clean`: Remove existing dependencies and reinstall
- `--dev`: Include development-only dependencies

**Features**:
- Automatic Bundler installation
- Dependency verification
- Installation statistics
- Error handling

### `test.sh`
Test suite for validation and quality assurance.

**Usage**: `./test.sh [--build] [--links] [--html] [--all]`
**Purpose**: Run various tests and validations

**Test Types**:
- `--build`: Test Jekyll build process
- `--links`: Check for broken internal links
- `--html`: Validate HTML markup structure
- `--all`: Run complete test suite

**Features**:
- Automated testing
- Detailed reporting
- Exit codes for CI/CD
- Incremental testing

## Development Workflow

### Initial Setup
```bash
# Install dependencies
./install-deps.sh --dev

# Start development server
./dev-server.sh --watch
```

### Daily Development
```bash
# Start server with file watching
./dev-server.sh --watch --port 4000

# Run tests before committing
./test.sh --all
```

### Dependency Updates
```bash
# Update all dependencies
./install-deps.sh --update

# Clean install if issues occur
./install-deps.sh --clean --dev
```

## Testing

### Build Tests
- Verify Jekyll configuration
- Check for build errors
- Validate output structure

### Link Tests
- Find broken internal references
- Check image paths
- Validate navigation

### HTML Tests
- Basic markup validation
- Required tag presence
- Structure verification

## Port Configuration

Default development server runs on port 4000. If port is in use:

```bash
# Use alternative port
./dev-server.sh --port 4001

# Use different host
./dev-server.sh --host 0.0.0.0 --port 8080
```

## Integration with Editors

### VS Code
- Install Jekyll extension
- Configure LiveShare for collaboration
- Set up integrated terminal

### Other Editors
- Configure syntax highlighting for Jekyll
- Set up file watchers if needed
- Configure build tasks

## Troubleshooting

- **Server won't start**: Check port availability, install dependencies
- **Live reload not working**: Verify watch flag, check file permissions  
- **Tests failing**: Review error output, check dependencies
- **Performance issues**: Use incremental builds, check system resources