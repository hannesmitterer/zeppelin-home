# Web Scripts

This directory contains scripts for web-related functionality and site building.

## Scripts

### `redirect.js`
JavaScript module for handling page redirections.

**Purpose**: Provides robust redirect functionality for the main site
**Usage**: Automatically loaded by `index.html`
**Features**:
- Fallback redirect mechanisms
- Loop prevention
- Configurable delays
- Error handling

**Configuration**:
```javascript
const REDIRECT_CONFIG = {
    targetPath: './docs/',
    delay: 0,
    fallbackDelay: 3000
};
```

### `build.sh`
Jekyll site build script.

**Usage**: `./build.sh [development|production]`
**Purpose**: Build the Jekyll site with appropriate configuration
**Permissions**: `755` (executable)

**Features**:
- Environment-specific builds
- Dependency checking
- Build validation
- Statistics reporting

## Build Environments

### Development
```bash
./build.sh development
```
- Includes draft posts
- Enables incremental builds
- Shows detailed output
- Faster build times

### Production
```bash
./build.sh production
```
- Optimized output
- Minified assets
- SEO optimization
- Full site rebuild

## Build Output

Successful builds create:
- `_site/` directory with static files
- Optimized HTML, CSS, and JavaScript
- Sitemap and RSS feed
- Proper URL structure

## Integration

### With GitHub Actions
The `build.sh` script is used by the GitHub Actions workflow for automated deployment.

### With Development Server
The development server uses the build script for initial site generation.

## Troubleshooting

- **Build failures**: Check Jekyll configuration and dependencies
- **Missing files**: Verify all referenced resources exist
- **Permission errors**: Run `scripts/utils/permissions.sh --fix`
- **Ruby errors**: Update dependencies with `scripts/development/install-deps.sh`

## Customization

### Adding New Scripts
1. Create script in this directory
2. Set executable permissions
3. Follow naming conventions
4. Add documentation
5. Test thoroughly

### Modifying Build Process
- Edit `build.sh` for additional build steps
- Update GitHub Actions workflow if needed
- Test both development and production builds
- Document changes