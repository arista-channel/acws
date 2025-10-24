# GitHub Actions Setup Guide

## 🔐 Required GitHub Repository Secrets

To enable automatic deployment to your nginx server, you need to configure the following secret in your GitHub repository:

### 1. SSH Key Secret Setup

**Secret Name:** `NGINX_SERVER_SSH_KEY`

**Secret Value:** The contents of your private SSH key file

#### Steps to Configure:

1. **Get your SSH private key content:**
   ```bash
   cat /Users/miguelbalagot/Documents/MyKeyPairs/mb-partner-kp.pem
   ```

2. **Copy the entire output** (including `-----BEGIN RSA PRIVATE KEY-----` and `-----END RSA PRIVATE KEY-----`)

3. **Add to GitHub Repository:**
   - Go to your repository: https://github.com/mbalagot12/campus-workshop
   - Click **Settings** → **Secrets and variables** → **Actions**
   - Click **New repository secret**
   - Name: `NGINX_SERVER_SSH_KEY`
   - Value: Paste the entire SSH key content
   - Click **Add secret**

### 2. Workflow Configuration

The workflows are now configured to:

- **deploy-docs.yml**: Deploy to GitHub Pages when you push to `main` branch
- **deploy-nginx.yml**: Automatically deploy to nginx server when GitHub Pages is updated

### 3. How the CI/CD Pipeline Works

```mermaid
graph LR
    A[Push to main] --> B[deploy-docs.yml]
    B --> C[Build & Deploy to GitHub Pages]
    C --> D[Push to gh-pages branch]
    D --> E[deploy-nginx.yml triggers]
    E --> F[Deploy to nginx server]
    F --> G[acws.duckdns.org updated]
```

### 4. Testing the Pipeline

After setting up the secret, test the pipeline:

1. **Make a small change** to any file in the `docs/` folder
2. **Commit and push** to main branch:
   ```bash
   git add .
   git commit -m "Test CI/CD pipeline"
   git push origin main
   ```
3. **Monitor the workflows** at: https://github.com/mbalagot12/campus-workshop/actions

### 5. Manual Deployment Options

You can also trigger deployments manually:

- **GitHub Pages**: Go to Actions → "Deploy Campus Workshop Documentation" → "Run workflow"
- **nginx Server**: Go to Actions → "Deploy to Nginx Server" → "Run workflow"

### 6. Version Management

- **Default version**: Atlanta 2025.4.ATL (latest)
- **Protected version**: Orlando 2025.1.ORL (historical, never overwritten)
- **New versions**: Will be created automatically or manually as needed

## 🛡️ Safety Features

- Orlando 2025.1.ORL is protected and will never be overwritten
- Automatic backups are created before each deployment
- Dry run options available for testing
- Rollback capabilities through Mike versioning

## 🌐 URLs After Setup

- **GitHub Pages**: https://mbalagot12.github.io/campus-workshop/
- **nginx Server**: acws.duckdns.org
- **Local Development**: http://localhost:8081/2025.4.ATL/
