# Script Organization and Deployment Documentation

## Overview

This document outlines the comprehensive script organization and deployment setup implemented for the Zeppelin Home project. All executable scripts, deployment configurations, and automation tools have been consolidated into a structured `scripts/` directory with appropriate permissions and documentation.

## Directory Structure

The following directory structure has been created to organize all scripts:

```
scripts/
├── README.md                    # Main scripts documentation
├── deployment/                  # Deployment scripts and configurations
│   ├── README.md               # Deployment documentation
│   ├── github-pages.yml        # GitHub Pages deployment workflow
│   ├── deploy.sh              # Manual deployment script (permissions: 700)
│   └── setup.sh               # Initial setup script (permissions: 755)
├── web/                        # Web-related scripts
│   ├── README.md              # Web scripts documentation  
│   ├── redirect.js            # JavaScript redirect functionality
│   └── build.sh              # Jekyll build script (permissions: 755)
├── development/                # Development utilities
│   ├── README.md              # Development documentation
│   ├── dev-server.sh         # Local development server (permissions: 755)
│   ├── install-deps.sh       # Dependency management (permissions: 755)
│   └── test.sh               # Testing and validation (permissions: 755)
└── utils/                     # Utility scripts
    ├── README.md              # Utilities documentation
    ├── permissions.sh         # Permission management (permissions: 755)
    └── cleanup.sh            # Cleanup and maintenance (permissions: 755)
```

## Scripts Inventory

### Deployment Scripts (`scripts/deployment/`)

#### 1. `github-pages.yml`
- **Purpose**: Enhanced GitHub Actions workflow for automated deployment
- **Source**: Moved from `.github/workflows/gh-pages.yml` (original preserved)
- **Features**:
  - Automated script permission setting
  - Test execution before deployment
  - Build verification and statistics
  - Deployment notifications
  - Manual trigger support with options
  - Build manifest generation

#### 2. `deploy.sh`
- **Purpose**: Manual deployment to GitHub Pages
- **Permissions**: `700` (owner-only for security)
- **Features**:
  - Force deployment option
  - Dry-run mode for testing
  - Automatic site building
  - Git repository validation
  - Temporary directory management
  - Error handling and rollback

#### 3. `setup.sh`
- **Purpose**: Initial project setup and configuration
- **Permissions**: `755`
- **Features**:
  - System requirements checking
  - Dependency installation
  - Directory structure creation
  - Permission setup
  - Git hooks configuration (dev mode)
  - Development vs. production setup

### Web Scripts (`scripts/web/`)

#### 1. `redirect.js`
- **Purpose**: Enhanced JavaScript redirect functionality
- **Source**: Extracted from `index.html`
- **Features**:
  - Configurable redirect targets and delays
  - Fallback redirect mechanisms
  - Loop prevention
  - Error handling
  - Debug logging
  - External configuration access

#### 2. `build.sh`
- **Purpose**: Jekyll site building
- **Permissions**: `755`
- **Features**:
  - Environment-specific builds (development/production)
  - Dependency checking and installation
  - Build validation
  - Statistics reporting
  - Error handling

### Development Scripts (`scripts/development/`)

#### 1. `dev-server.sh`
- **Purpose**: Local Jekyll development server
- **Permissions**: `755`
- **Features**:
  - Configurable host and port
  - File watching and auto-regeneration
  - Development-optimized builds
  - Graceful shutdown handling
  - Dependency validation

#### 2. `install-deps.sh`
- **Purpose**: Dependency installation and management
- **Permissions**: `755`
- **Features**:
  - Clean installation option
  - Dependency updates
  - Development vs. production dependencies
  - Installation verification
  - Statistics reporting

#### 3. `test.sh`
- **Purpose**: Comprehensive testing suite
- **Permissions**: `755`
- **Features**:
  - Jekyll build testing
  - Link validation
  - HTML markup validation
  - Test result tracking
  - CI/CD integration

### Utility Scripts (`scripts/utils/`)

#### 1. `permissions.sh`
- **Purpose**: Permission management and security
- **Permissions**: `755`
- **Features**:
  - Permission checking and fixing
  - Secure mode (restrictive permissions)
  - Directory permission management
  - Validation reporting
  - Security best practices

#### 2. `cleanup.sh`
- **Purpose**: Project cleanup and maintenance
- **Permissions**: `755`
- **Features**:
  - Build artifact cleanup
  - Temporary file removal
  - Dependency cache clearing
  - Selective cleanup options
  - Size reporting

## Permission Scheme

### Standard Permissions
- **Executable scripts**: `755` (rwxr-xr-x)
- **Configuration files**: `644` (rw-r--r--)
- **Documentation files**: `644` (rw-r--r--)
- **Directories**: `755` (rwxr-xr-x)

### Secure Permissions (where applicable)
- **Deployment scripts**: `700` (rwx------) - owner-only access
- **Sensitive configurations**: `600` (rw-------) - owner-only read/write

## Security Features

### Deployment Security
- Deployment scripts have restrictive permissions (700)
- All scripts validate prerequisites before execution
- Git repository validation prevents unauthorized deployments
- Confirmation prompts for sensitive operations

### Script Validation
- All scripts include error handling and validation
- Prerequisites checking before execution
- Safe file operations with confirmation
- Logging and audit trails

### Permission Management
- Automated permission setting and validation
- Security mode for production environments
- Regular permission auditing capability
- Documentation of permission rationale

## Usage Examples

### Initial Setup
```bash
# Complete project setup
./scripts/deployment/setup.sh --dev --full

# Set proper permissions
./scripts/utils/permissions.sh --fix
```

### Development Workflow
```bash
# Install/update dependencies
./scripts/development/install-deps.sh --dev

# Start development server
./scripts/development/dev-server.sh --watch

# Run tests
./scripts/development/test.sh --all

# Clean temporary files
./scripts/utils/cleanup.sh --temp
```

### Deployment Workflow
```bash
# Test deployment
./scripts/deployment/deploy.sh --dry-run

# Deploy to GitHub Pages
./scripts/deployment/deploy.sh

# Force deployment (if needed)
./scripts/deployment/deploy.sh --force
```

### Maintenance
```bash
# Clean all artifacts
./scripts/utils/cleanup.sh --all

# Check permissions
./scripts/utils/permissions.sh --check

# Apply secure permissions
./scripts/utils/permissions.sh --secure
```

## Integration with Existing Systems

### GitHub Actions
- Enhanced workflow uses organized scripts
- Automatic permission setting
- Test execution before deployment
- Build verification and statistics

### Jekyll Configuration
- Scripts integrate with existing Jekyll setup
- Preserve all existing functionality
- Environment-specific configurations
- Compatible with GitHub Pages

### Development Tools
- Compatible with existing development workflow
- Enhances local development capabilities
- Integrates with Git hooks
- Supports multiple development environments

## Deployment Process

### Automated Deployment (GitHub Actions)
1. Code push triggers workflow
2. Script permissions are validated and set
3. Dependencies are installed
4. Tests are executed
5. Site is built with production settings
6. Build is verified and statistics collected
7. Site is deployed to GitHub Pages
8. Deployment notification is sent

### Manual Deployment
1. Run setup script if needed
2. Use deploy script with appropriate options
3. Script validates prerequisites
4. Site is built automatically
5. Deployment to gh-pages branch
6. Success confirmation

## Maintenance and Updates

### Regular Maintenance
- Run cleanup scripts weekly
- Check permissions monthly
- Update dependencies as needed
- Test deployment process regularly

### Troubleshooting
- Use test scripts to identify issues
- Review script logs for errors
- Use dry-run modes to test changes
- Refer to individual script documentation

## Security Considerations

### File Permissions
- Deployment scripts have restricted access
- Regular permission audits recommended
- Secure mode available for production

### Script Content
- All scripts include input validation
- Error handling prevents partial operations
- Logging provides audit trails
- No hardcoded credentials or secrets

### Access Control
- Scripts validate environment prerequisites
- Git repository validation prevents unauthorized access
- Deployment requires proper credentials
- Manual confirmation for sensitive operations

## Future Enhancements

### Planned Features
- Additional testing capabilities
- Enhanced monitoring and reporting
- Integration with more deployment targets
- Advanced security features

### Extensibility
- Modular script design allows easy additions
- Clear documentation standards
- Consistent error handling patterns
- Well-defined interfaces between scripts

## Support and Documentation

Each script directory contains comprehensive README documentation with:
- Detailed usage instructions
- Command-line options and examples
- Troubleshooting guides
- Integration information
- Security considerations

For specific script help, refer to the README files in each subdirectory or run scripts with invalid options to see usage information.