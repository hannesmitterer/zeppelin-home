# Custom Domain Setup for GitHub Pages

If you want to use a custom domain (like `zeppelinhome.com`) instead of the default GitHub Pages URL, follow these steps:

## 1. Add CNAME File
Create a file named `CNAME` in the repository root with just your domain name:
```
zeppelinhome.com
```

## 2. Configure DNS Settings
At your domain registrar, add one of these DNS records:

**For apex domain (example.com):**
- Add A records pointing to GitHub Pages IP addresses:
  - 185.199.108.153
  - 185.199.109.153  
  - 185.199.110.153
  - 185.199.111.153

**For subdomain (www.example.com):**
- Add CNAME record: `www CNAME hannesmitterer.github.io`

## 3. Enable in GitHub Settings
1. Go to repository **Settings → Pages**
2. Under **Custom domain**, enter your domain name
3. Check **Enforce HTTPS** (recommended)

## 4. Wait for DNS Propagation
DNS changes can take up to 24 hours to propagate worldwide.

## Current Configuration
Currently using GitHub Pages default URL: https://hannesmitterer.github.io/zeppelin-home/