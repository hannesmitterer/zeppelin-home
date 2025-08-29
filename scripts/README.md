# Scripts Directory

This directory contains all executable scripts, deployment configurations, and automation tools for the Zeppelin Home project.

## Directory Structure

```
scripts/
├── README.md                 # This file
├── deployment/              # Deployment scripts and configurations
│   ├── github-pages.yml     # GitHub Pages deployment workflow
│   ├── deploy.sh           # Local deployment script
│   └── setup.sh            # Initial setup script
├── web/                    # Web-related scripts
│   ├── redirect.js         # Page redirect functionality
│   └── build.sh           # Jekyll build script
├── development/            # Development utilities
│   ├── dev-server.sh      # Local development server
│   ├── install-deps.sh    # Install dependencies
│   └── test.sh           # Run tests
└── utils/                 # Utility scripts
    ├── permissions.sh     # Set proper permissions
    └── cleanup.sh        # Cleanup temporary files
```

## Script Categories

### Deployment Scripts
- **GitHub Actions Workflows**: Automated deployment to GitHub Pages
- **Manual Deployment**: Scripts for manual deployment processes
- **Environment Setup**: Configuration and initialization scripts

### Web Scripts
- **Frontend JavaScript**: Client-side functionality
- **Build Tools**: Jekyll and site generation scripts
- **Asset Management**: Media and resource handling

### Development Tools
- **Development Server**: Local testing and development
- **Dependency Management**: Install and update dependencies  
- **Testing Scripts**: Validation and testing utilities

### Utilities
- **Permission Management**: Set execution permissions
- **Cleanup Tools**: Remove temporary files and artifacts
- **Maintenance Scripts**: Regular maintenance tasks

## Security and Permissions

All scripts are configured with appropriate permissions:
- **Executable scripts**: `755` (rwxr-xr-x)
- **Configuration files**: `644` (rw-r--r--)
- **Sensitive scripts**: `700` (rwx------) where applicable

## Usage

Each subdirectory contains its own README with specific usage instructions. Always review scripts before execution and ensure you understand their purpose and effects.

## Contributing

When adding new scripts:
1. Place them in the appropriate subdirectory
2. Set proper permissions using `scripts/utils/permissions.sh`
3. Document the script's purpose and usage
4. Test thoroughly before committing
5. Update this README if adding new categories