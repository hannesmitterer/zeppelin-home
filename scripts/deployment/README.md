# Deployment Scripts

This directory contains scripts and configurations related to deploying the Zeppelin Home website.

## Scripts

### `github-pages.yml`
GitHub Actions workflow configuration for automated deployment to GitHub Pages.

**Location**: Copied from `.github/workflows/gh-pages.yml`
**Purpose**: Automated deployment on push to main branch
**Permissions**: Read contents, write pages, write id-token

### `deploy.sh`
Manual deployment script for GitHub Pages.

**Usage**: `./deploy.sh [--force] [--dry-run]`
**Purpose**: Build site and deploy to gh-pages branch
**Permissions**: `700` (owner execute only for security)

**Options**:
- `--force`: Force deployment even without changes
- `--dry-run`: Show what would be deployed without executing

### `setup.sh`
Initial project setup script.

**Usage**: `./setup.sh [--dev] [--full]`
**Purpose**: Install dependencies, set permissions, configure environment
**Permissions**: `755` (executable)

**Options**:
- `--dev`: Setup development environment with additional tools
- `--full`: Complete setup including optional components

## Security Considerations

- Deployment scripts have restrictive permissions (700) to prevent unauthorized access
- All scripts validate prerequisites before executing
- Deployment requires proper Git configuration and permissions
- Sensitive operations include confirmation prompts

## Usage Examples

```bash
# Initial setup (run once)
./setup.sh --dev --full

# Deploy to GitHub Pages (manual)
./deploy.sh

# Deploy with force (overrides safety checks)
./deploy.sh --force

# Test deployment (see what would happen)
./deploy.sh --dry-run
```

## Requirements

- Ruby 2.7+ with Bundler
- Git with proper remote configuration  
- GitHub repository with Pages enabled
- Write access to the repository

## Troubleshooting

- **Permission denied**: Run `scripts/utils/permissions.sh --fix`
- **Ruby errors**: Run `scripts/development/install-deps.sh --update`
- **Git errors**: Check repository configuration and credentials
- **Build failures**: Check Jekyll configuration and dependencies