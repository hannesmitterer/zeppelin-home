# Zeppelin Home 

🏠 **Revolutionary Smart Home Automation Platform**

[![GitHub Pages](https://img.shields.io/badge/GitHub%20Pages-Live%20Site-brightgreen)](https://hannesmitterer.github.io/zeppelin-home/)
[![License: GPL v3](https://img.shields.io/badge/License-GPLv3-blue.svg)](LICENSE)
[![Community](https://img.shields.io/badge/Community-Join%20Discord-7289da)](https://discord.gg/zeppelinhome)

Welcome to Zeppelin Home - an open-source smart home automation platform that puts privacy and community first.

## 🌐 Visit Our Website

**[Visit the Zeppelin Home Website →](https://hannesmitterer.github.io/zeppelin-home/)**

Our GitHub Pages site showcases:
- Product overview and key features
- Press kit and media resources  
- Crowdfunding campaign information
- Community resources and support
- Privacy-focused approach to smart homes

## 🚀 Key Features

- **🔗 Smart Integration**: 500+ supported device types
- **🔒 Privacy First**: Your data stays in your home
- **🌍 Open Source**: Transparent, community-driven development  
- **📱 Cross-Platform**: Works everywhere you need it
- **💰 No Subscriptions**: Free forever

## 🤝 Get Involved

- **💬 [Join our Discord Community](https://discord.gg/zeppelinhome)**
- **💰 [Support our Crowdfunding Campaign](https://hannesmitterer.github.io/zeppelin-home/#support-our-mission)**
- **📰 [Media & Press Kit](https://hannesmitterer.github.io/zeppelin-home/#press-kit)**

## 🛠️ Development & Deployment

### Quick Start for Contributors

```bash
# Install dependencies and start development server
./scripts/deploy.sh serve

# Test the build process
./scripts/deploy.sh test

# Add new media files
./scripts/file-manager.sh add-media /path/to/image.png

# Quick content update and push
./scripts/file-manager.sh quick "Update campaign info"
```

### Management Scripts

The repository includes helpful scripts in the `scripts/` directory:

- **`deploy.sh`**: Development server, building, and testing
- **`file-manager.sh`**: Content updates and git operations
- **See [scripts/README.md](scripts/README.md) for detailed usage**

### 🌐 GitHub Pages Deployment

The Zeppelin Home website is automatically deployed to GitHub Pages using GitHub Actions.

#### Live Site
**🔗 https://hannesmitterer.github.io/zeppelin-home/**

#### How to Deploy
1. **Automatic Deployment**: Push changes to the `main` branch
2. **Manual Deployment**: Go to Actions tab → "Deploy to GitHub Pages" → "Run workflow"
3. **Build Status**: Check the Actions tab for deployment status
4. **Deployment Time**: Typically 2-5 minutes after push

#### Setup Instructions
To enable GitHub Pages for this repository:
1. Go to **Repository Settings → Pages**
2. Set **Source** to **"GitHub Actions"** (not "Deploy from a branch")
3. The workflow will automatically deploy when changes are pushed to main

#### Local Development
```bash
# Install dependencies
bundle install

# Start development server
bundle exec jekyll serve

# Site will be available at http://localhost:4000
```

#### Custom Domain (Optional)
To use a custom domain like `zeppelinhome.com`:
1. Add a `CNAME` file to the repository root containing your domain name
2. Configure DNS settings at your domain registrar:
   - Add a CNAME record pointing to `hannesmitterer.github.io`
   - Or use A records pointing to GitHub Pages IP addresses
3. Update the `url` setting in `_config.yml` to match your custom domain
4. GitHub Pages will automatically handle HTTPS certificates

#### Deployment Workflow
The site uses `.github/workflows/pages.yml` which:
- Triggers on push to `main` branch
- Builds the Jekyll site with GitHub Pages compatibility
- Deploys to the `gh-pages` branch automatically
- Serves the site at https://hannesmitterer.github.io/zeppelin-home/

## 📄 License

This project is licensed under the GNU General Public License v3.0 - see the [LICENSE](LICENSE) file for details.

---

*Built with ❤️ by the Zeppelin Home community*