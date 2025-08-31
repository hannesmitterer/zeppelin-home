# GitHub Pages Setup Instructions

## Enabling GitHub Pages

To complete the setup of the Zeppelin Home documentation website:

### 1. Enable GitHub Pages
1. Go to repository Settings → Pages (in left sidebar)
2. Under "Source", select "Deploy from a branch"
3. Choose "main" branch and "/ (root)" folder
4. Click "Save"

### 2. Custom Domain Configuration
The site includes a `CNAME` file for the custom domain `zeppelinhome.com`. GitHub Pages will automatically detect this and configure the custom domain. 

If you want to use the default GitHub Pages URL instead:
1. Delete the `CNAME` file from the repository root
2. The site will be available at `https://hannesmitterer.github.io/zeppelin-/`

If using the custom domain, ensure DNS is configured:
1. Point your domain's DNS A records to GitHub Pages IPs:
   - `185.199.108.153`
   - `185.199.109.153` 
   - `185.199.110.153`
   - `185.199.111.153`
2. Or use a CNAME record pointing to `hannesmitterer.github.io`

### 3. Automatic Deployment
The repository includes a GitHub Actions workflow (`.github/workflows/pages.yml`) that automatically:
- Builds the Jekyll site when changes are pushed to main branch
- Deploys to GitHub Pages
- Uses Ruby 3.2.2 for compatibility

### 4. Site Structure
- **Homepage**: `docs/index.md` (main documentation)
- **Configuration**: `_config.yml` (Jekyll/GitHub Pages config)
- **Media Assets**: `media/` directory (images and graphics)
- **Theme**: Using Jekyll's "minima" theme for clean presentation

### 5. Expected URL
Once enabled, the site will be available at:
- **Custom Domain**: `https://zeppelinhome.com` (configured via CNAME file)
- **GitHub Pages URL**: `https://hannesmitterer.github.io/zeppelin-/` (if CNAME file is removed)

### 6. Content Overview
The site includes:
- ✅ Project overview with visual appeal
- ✅ Enhanced press kit for media coverage
- ✅ Crowdfunding campaign details
- ✅ Community resources and contact info  
- ✅ Privacy-focused legal information
- ✅ Removed all developer/technical content

### 7. Placeholder Media
Media files in `/media/` are currently placeholders. Replace with actual assets:
- `zeppelin-logo.png` - Main logo/branding
- `dashboard-preview.png` - Product screenshot
- `community-stats.png` - Community growth graphics
- `press-kit-banner.png` - Press kit header
- `funding-progress.png` - Crowdfunding progress
- `community-banner.png` - Community section header

The site is ready to go live and provides an engaging, user-friendly experience focused on attracting users, press coverage, and crowdfunding support.