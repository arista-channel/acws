# 🚀 Campus Workshop Deployment Guide

## Overview

This document describes the **error-free, fully automated deployment system** for the Campus Workshop documentation. The system handles everything from committing changes to updating the nginx web server with comprehensive error handling and Orlando protection.

## 🎯 Deployment Methods

### 1. **Automated GitHub Actions** (Recommended)
Fully automated deployment triggered by commits to main branch.

### 2. **Manual Script Deployment**
Local script for testing and manual deployments.

### 3. **Emergency Manual Deployment**
Step-by-step manual process for emergency situations.

---

## 🤖 Method 1: Automated GitHub Actions

### **Trigger Conditions**
The automated deployment runs when:
- **Push to main branch** with changes to:
  - `docs/**` (documentation files)
  - `data/**` (CSV data files)
  - `mkdocs.yml` (configuration)
  - `requirements.txt` (dependencies)

### **Manual Trigger**
You can also trigger deployment manually:

1. Go to **Actions** tab in GitHub repository
2. Select **"🚀 Automated Campus Workshop Update"**
3. Click **"Run workflow"**
4. Configure options:
   - **Force deployment**: Deploy even if no changes detected
   - **Skip Orlando protection**: ⚠️ DANGEROUS - only use if Orlando is corrupted
   - **Dry run**: Test without actual deployment

### **What It Does**

#### **Phase 1: Build & Deploy to GitHub Pages**
1. ✅ **Environment Setup**: Python 3.11 + UV package manager
2. ✅ **ATD Token CSV Fixes**: Automatically fixes common CSV formatting issues
3. ✅ **Mike Documentation Build**: Creates versioned documentation structure
4. ✅ **ATD Token Verification**: Ensures enumerated ATD Lab labels render correctly
5. ✅ **GitHub Pages Deployment**: Updates GitHub Pages with latest content

#### **Phase 2: Deploy to Nginx Server**
1. ✅ **Pre-deployment Validation**: Verifies package integrity
2. ✅ **Optimized Package Creation**: Creates compressed deployment archive
3. ✅ **Secure Server Connection**: Enhanced SSH with retry logic
4. ✅ **Orlando Protection**: Automatically backs up and restores Orlando 2025.1.ORL
5. ✅ **Atomic Deployment**: Zero-downtime deployment with rollback capability
6. ✅ **Post-deployment Verification**: Confirms successful deployment
7. ✅ **Automatic Cleanup**: Removes temporary files and schedules backup cleanup

### **Orlando Protection System**
- 🛡️ **Automatic Backup**: Orlando 2025.1.ORL is backed up before deployment
- 🛡️ **Preservation**: Orlando content is never overwritten
- 🛡️ **Restoration**: Orlando is restored after new content deployment
- 🛡️ **Verification**: System confirms Orlando protection worked

### **Error Handling**
- 🔄 **Retry Logic**: Connection and transfer failures are automatically retried
- 🔍 **Comprehensive Validation**: Pre and post-deployment checks
- 💾 **Automatic Backups**: Full site backup before any changes
- ⚡ **Atomic Operations**: All-or-nothing deployment prevents partial updates
- 📊 **Detailed Logging**: Complete audit trail of all operations

---

## 🖥️ Method 2: Manual Script Deployment

### **Prerequisites**
- UV package manager installed
- SSH access to nginx server
- SSH key configured in `~/.ssh/` or environment

### **Usage**

```bash
# Normal deployment
./scripts/deploy.sh

# Test deployment (no changes made)
./scripts/deploy.sh --dry-run

# Force deployment even if no changes detected
./scripts/deploy.sh --force

# Build locally only (no server deployment)
./scripts/deploy.sh --local-only

# Skip Orlando protection (DANGEROUS)
./scripts/deploy.sh --skip-orlando

# Show help
./scripts/deploy.sh --help
```

### **What the Script Does**
1. ✅ **Environment Setup**: Creates UV virtual environment and installs dependencies
2. ✅ **Pre-deployment Validation**: Checks required files and CSV format
3. ✅ **ATD Token Fixes**: Applies comprehensive CSV formatting fixes
4. ✅ **Mike Build**: Builds versioned documentation with Mike
5. ✅ **ATD Token Verification**: Confirms proper rendering of enumerated labels
6. ✅ **Server Deployment**: Transfers and deploys to nginx server with Orlando protection
7. ✅ **Verification**: Confirms successful deployment

---

## 🆘 Method 3: Emergency Manual Deployment

### **When to Use**
- GitHub Actions is down
- Deployment script fails
- Emergency fixes needed
- Server access issues

### **Step-by-Step Process**

#### **Step 1: Prepare Environment**
```bash
# Activate virtual environment
source .venv/bin/activate

# Install dependencies
uv pip install -r requirements.txt
```

#### **Step 2: Fix ATD Tokens**
```bash
# Apply CSV fixes manually
python -c "
import re
with open('data/lab_assignment.csv', 'r') as f:
    content = f.read()
content = content.replace('\"\"_blank\"\"', '\"_blank\"')
content = re.sub(r'target=_blank(?!\")', 'target=\"_blank\"', content)
with open('data/lab_assignment.csv', 'w') as f:
    f.write(content)
print('✅ CSV fixes applied')
"
```

#### **Step 3: Build Documentation**
```bash
# Clean and build with Mike
rm -rf site/
mike deploy --push --update-aliases 2025.4.ATL latest
```

#### **Step 4: Deploy to Server**
```bash
# Create deployment package
tar -czf manual-deploy.tar.gz --exclude='.git' --exclude='.venv' .

# Transfer to server
scp manual-deploy.tar.gz ubuntu@acws.duckdns.org:/tmp/

# Deploy on server
ssh ubuntu@acws.duckdns.org '
# Backup Orlando
sudo cp -r /var/www/mkdocs/site/2025.1.ORL /tmp/orlando-backup

# Extract and deploy
cd /tmp
tar -xzf manual-deploy.tar.gz
sudo rm -rf /var/www/mkdocs/site/*
sudo cp -r . /var/www/mkdocs/site/

# Restore Orlando
sudo cp -r /tmp/orlando-backup /var/www/mkdocs/site/2025.1.ORL

# Set permissions and reload
sudo chown -R www-data:www-data /var/www/mkdocs/site
sudo chmod -R 755 /var/www/mkdocs/site
sudo systemctl reload nginx

# Cleanup
rm -rf /tmp/manual-deploy.tar.gz /tmp/orlando-backup
echo "✅ Manual deployment completed"
'
```

---

## 🔧 Configuration

### **Environment Variables**
- `SERVER_HOST`: nginx server hostname (default: acws.duckdns.org)
- `SERVER_USER`: SSH username (default: ubuntu)
- `SERVER_PATH`: nginx site path (default: /var/www/mkdocs/site)

### **GitHub Secrets Required**
- `NGINX_SERVER_SSH_KEY`: Private SSH key for server access

### **Server Requirements**
- Ubuntu/Debian Linux
- nginx web server
- SSH access with sudo privileges
- At least 2GB free disk space

---

## 📊 Monitoring & Verification

### **Deployment Status**
- **GitHub Actions**: Check Actions tab for deployment status
- **GitHub Pages**: https://mbalagot12.github.io/campus-workshop/
- **Nginx Server**: http://acws.duckdns.org/

### **Verification Checklist**
- [ ] Site loads at http://acws.duckdns.org/
- [ ] Redirects to http://acws.duckdns.org/2025.4.ATL/
- [ ] ATD lab page shows enumerated labels (🚀 ATD Lab 1-18)
- [ ] ATD Token links open in new tabs
- [ ] Orlando 2025.1.ORL remains accessible and unchanged
- [ ] Version selector shows both Atlanta and Orlando versions

### **Common Issues & Solutions**

#### **Issue: ATD Token links not rendering**
**Solution**: Check CSV formatting in `data/lab_assignment.csv`
```bash
# Verify target attributes
grep 'target=' data/lab_assignment.csv
```

#### **Issue: Orlando version missing**
**Solution**: Orlando protection may have failed
```bash
# Check if Orlando backup exists on server
ssh ubuntu@acws.duckdns.org "ls -la /tmp/orlando*"
```

#### **Issue: Site shows old content**
**Solution**: Clear browser cache or check deployment logs
```bash
# Force browser refresh: Ctrl+F5 (Windows) or Cmd+Shift+R (Mac)
```

---

## 🎯 Best Practices

### **Development Workflow**
1. Make changes to documentation or data files
2. Test locally with `./scripts/deploy.sh --local-only`
3. Commit and push to main branch
4. Monitor GitHub Actions for automated deployment
5. Verify deployment at http://acws.duckdns.org/

### **Emergency Procedures**
1. Use `--dry-run` to test changes before deployment
2. Keep Orlando protection enabled unless absolutely necessary
3. Monitor deployment logs for any issues
4. Have manual deployment steps ready as backup

### **Maintenance**
- Review deployment logs regularly
- Update dependencies in requirements.txt as needed
- Test deployment process in staging environment
- Keep SSH keys secure and rotated

---

## 🎉 Summary

This deployment system provides:

✅ **Fully Automated**: From commit to live site in minutes
✅ **Error-Free**: Comprehensive error handling and validation
✅ **Orlando Protection**: Guaranteed preservation of historical content
✅ **Zero Downtime**: Atomic deployments with rollback capability
✅ **Multiple Methods**: Automated, manual script, and emergency options
✅ **Complete Monitoring**: Full audit trail and verification
✅ **ATD Token Fixes**: Automatic handling of CSV formatting issues

**The system ensures your Campus Workshop documentation is always up-to-date, properly formatted, and accessible to students with their enumerated ATD Lab labels!** 🚀✨
