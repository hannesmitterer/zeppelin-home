# Utility Scripts

This directory contains utility scripts for maintenance, permissions, and housekeeping tasks.

## Scripts

### `permissions.sh`
Permission management and security configuration.

**Usage**: `./permissions.sh [--fix] [--check] [--secure]`
**Purpose**: Manage file and directory permissions across the project

**Options**:
- `--check`: Check current permissions without making changes
- `--fix`: Apply correct permissions to all files
- `--secure`: Apply more restrictive permissions for security

**Permission Scheme**:
- **Executable scripts**: `755` (rwxr-xr-x) or `700` (rwx------) in secure mode
- **Configuration files**: `644` (rw-r--r--) or `600` (rw-------) in secure mode
- **Documentation files**: `644` (rw-r--r--)
- **Directories**: `755` (rwxr-xr-x)

**Security Features**:
- Deployment scripts get restrictive permissions in secure mode
- Validates permissions against expected values
- Provides detailed reporting of permission issues

### `cleanup.sh`
Project cleanup and maintenance.

**Usage**: `./cleanup.sh [--all] [--build] [--temp] [--deps]`
**Purpose**: Remove temporary files, build artifacts, and cached data

**Cleanup Types**:
- `--build`: Remove Jekyll build outputs (`_site`, `.jekyll-cache`, etc.)
- `--temp`: Remove temporary files, logs, backups, system files
- `--deps`: Remove dependency caches (`vendor`, `.bundle`, `Gemfile.lock`)
- `--all`: Perform complete cleanup (all of the above)

**What Gets Cleaned**:
- Jekyll build artifacts
- Sass/CSS caches  
- Log files and backups
- Editor swap files
- System files (.DS_Store, Thumbs.db)
- Ruby/Bundle caches
- Node.js modules (if present)

## Usage Examples

### Permission Management
```bash
# Check all permissions
./permissions.sh --check

# Fix permissions with standard settings
./permissions.sh --fix

# Apply secure permissions (more restrictive)
./permissions.sh --secure
```

### Cleanup Operations
```bash
# Clean build artifacts only
./cleanup.sh --build

# Clean everything for fresh start
./cleanup.sh --all

# Clean temporary files but keep dependencies
./cleanup.sh --temp
```

## Maintenance Workflows

### Regular Maintenance
```bash
# Weekly cleanup
./cleanup.sh --build --temp

# Check permissions monthly
./permissions.sh --check
```

### Troubleshooting
```bash
# Clean everything if build issues occur
./cleanup.sh --all

# Fix permissions if access errors occur  
./permissions.sh --fix
```

### Security Hardening
```bash
# Apply secure permissions
./permissions.sh --secure

# This makes deployment scripts owner-only (700)
# Use with caution in shared environments
```

## Security Considerations

### Standard Permissions
- Scripts are executable by owner, group, and others
- Configuration files are readable by all
- Suitable for most development environments

### Secure Permissions  
- Scripts executable only by owner
- Configuration files readable only by owner
- Recommended for production environments
- May cause issues in shared development setups

### Deployment Security
- Deployment scripts always get restrictive permissions
- Contains sensitive operations and credentials
- Owner-only access prevents unauthorized deployment

## Integration

### With Git Hooks
These utilities can be integrated with Git hooks:
- Pre-commit: Check permissions
- Post-merge: Clean temporary files
- Pre-push: Full cleanup and validation

### With CI/CD
- Use in pipeline for consistent environments
- Clean before builds
- Validate permissions for security compliance

## Troubleshooting

- **Permission denied**: Check file ownership and parent directory permissions
- **Files not found**: Run from project root directory
- **Clean up failed**: Check file locks and running processes
- **Secure mode issues**: Consider reverting to standard permissions for development