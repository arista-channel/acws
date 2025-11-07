# 🚀 Campus Workshop Deployment Guide

## 🚨 **EMERGENCY RECOVERY COMPLETED**

✅ **Orlando 2025.1.ORL content has been successfully restored** from backup branch `backup-gh-pages-20250914-162844`

## 📋 **Quick Reference**

### **Branch Navigation**
```bash
# Switch to main branch (source files - markdown, scripts, config)
./scripts/switch-branch.sh main

# Switch to gh-pages branch (built HTML files - Mike versions)
./scripts/switch-branch.sh gh-pages

# Show current branch status and file structure
./scripts/switch-branch.sh status
```

### **For Minimal Updates (Recommended)**
```bash
# Quick deployment to GitHub Pages only
./scripts/quick-deploy.sh github

# Quick deployment to nginx server only (includes SSH validation)
./scripts/quick-deploy.sh nginx

# Deploy to both platforms (validates SSH before nginx deployment)
./scripts/quick-deploy.sh both
```

### **For Content Updates**
```bash
# 1. Switch to main branch (if not already there)
./scripts/switch-branch.sh main

# 2. Make your changes to docs/ or data/
# 3. Commit to main branch
git add .
git commit -m "📝 Update content"
git push origin main

# 4. Deploy using quick script
./scripts/quick-deploy.sh both
```

### **Using Convenient Aliases (Optional)**
```bash
# Load helpful aliases (run once per terminal session)
source scripts/branch-aliases.sh

# Then use short commands:
to-main              # Switch to main branch
edit-docs            # Switch to main and ready for editing
to-gh-pages          # Switch to gh-pages branch
view-site            # Switch to gh-pages to view built site
branch-status        # Show current branch status
quick-deploy         # Deploy to both platforms
```

## 🔧 **New CI/CD Pipeline**

### **GitHub Actions Workflow**
- **File**: `.github/workflows/deploy.yml`
- **Triggers**: Push to main branch (docs/, data/, mkdocs.yml changes)
- **Manual Trigger**: Workflow dispatch with deployment target selection

### **Deployment Targets**
1. **github-pages**: Deploy to GitHub Pages only
2. **nginx-server**: Deploy to nginx server only  
3. **both**: Deploy to both platforms

### **Required Secrets** (for nginx deployment)
```
NGINX_HOST=acws.duckdns.org
NGINX_USER=ubuntu
SSH_PRIVATE_KEY=<your-private-key-content>
```

**Note**: For this deployment, use the keypair `/Users/miguelbalagot/Documents/MyKeyPairs/mb-partner-kp.pem`

## 🛡️ **Orlando Version Protection**

### **Protection Script**
```bash
# Verify Orlando version integrity
./scripts/protect-orlando.sh verify

# Create backup of Orlando version
./scripts/protect-orlando.sh backup

# Restore Orlando from backup branch
./scripts/protect-orlando.sh restore
```

### **Automatic Protection**
- Orlando 2025.1.ORL is automatically protected during deployments
- Backup branch: `backup-gh-pages-20250914-162844`
- Emergency restoration available

## 📁 **Branch Structure**

### **Main Branch (Source Files)**
```
campus-workshop/ (main branch)
├── .github/workflows/
│   └── deploy.yml              # GitHub Actions CI/CD
├── scripts/
│   ├── quick-deploy.sh         # Fast deployment script
│   ├── protect-orlando.sh      # Orlando protection
│   ├── switch-branch.sh        # Branch switching utility
│   └── branch-aliases.sh       # Convenient aliases
├── docs/                       # 📝 Markdown content
│   ├── index.md               # Homepage
│   ├── a_wired/               # Wired lab exercises
│   ├── b_wireless/            # Wireless lab exercises
│   ├── c_security/            # Security lab exercises
│   └── references/            # Reference documentation
├── data/                       # 📊 Lab assignment data
│   ├── lab_assignment.csv     # Main lab data
│   └── atlanta_lab_assignment.csv
└── mkdocs.yml                 # 🔧 MkDocs configuration
```

### **GH-Pages Branch (Built HTML)**
```
campus-workshop/ (gh-pages branch)
├── 2025.4.ATL/                # 🌐 Atlanta version (latest)
├── 2025.1.ORL/                # 🌐 Orlando version (historical)
├── latest/                    # 🔗 Symlink to current version
├── versions.json              # 📊 Mike version configuration
└── index.html                 # 🏠 Site entry point
```

## 🌐 **Access URLs**

- **GitHub Pages**: https://mbalagot12.github.io/campus-workshop/
- **nginx Server**: https://acws.duckdns.org/
- **Local Development**: `mike serve -a 0.0.0.0:8081`

## ⚡ **Performance Improvements**

### **Before (Old Method)**
- ❌ Manual Mike commands
- ❌ No Orlando protection
- ❌ Complex deployment process
- ❌ Risk of overwriting historical content
- ❌ Long deployment times

### **After (New Method)**
- ✅ Automated CI/CD pipeline
- ✅ Orlando version protection
- ✅ Simple one-command deployment
- ✅ Backup and recovery system
- ✅ Fast, targeted deployments
- ✅ SSH connection validation
- ✅ Automatic permission fixing

## 🔄 **Deployment Workflow**

### **For Regular Updates**
1. **Edit Content**: Modify files in `docs/` or `data/`
2. **Commit Changes**: `git add . && git commit -m "Update content"`
3. **Push to Main**: `git push origin main`
4. **Auto Deploy**: GitHub Actions automatically deploys
5. **Manual Deploy**: Use `./scripts/quick-deploy.sh both` if needed

### **For Emergency Recovery**
1. **Check Orlando**: `./scripts/protect-orlando.sh verify`
2. **Restore if Needed**: `./scripts/protect-orlando.sh restore`
3. **Deploy**: `./scripts/quick-deploy.sh both`

## 🚨 **Troubleshooting**

### **Orlando Version Missing**
```bash
# Restore from backup
./scripts/protect-orlando.sh restore

# Verify restoration
./scripts/protect-orlando.sh verify

# Deploy restored content
./scripts/quick-deploy.sh both
```

### **Deployment Failures**
```bash
# Check prerequisites
source .venv/bin/activate
pip install mkdocs-material mkdocs-glightbox mike

# Test SSH connection manually
ssh -i /Users/miguelbalagot/Documents/MyKeyPairs/mb-partner-kp.pem ubuntu@acws.duckdns.org "echo 'Connection test'"

# Use manual deployment
./scripts/deploy.sh
```

### **SSH Connection Issues**
```bash
# Check SSH key permissions
ls -la /Users/miguelbalagot/Documents/MyKeyPairs/mb-partner-kp.pem

# Fix permissions if needed
chmod 600 /Users/miguelbalagot/Documents/MyKeyPairs/mb-partner-kp.pem

# Test connection manually
ssh -i /Users/miguelbalagot/Documents/MyKeyPairs/mb-partner-kp.pem ubuntu@acws.duckdns.org "whoami"
```

### **Large File Issues**
```bash
# Clean up large files
rm -f *.tar.gz mike-deployment.tar.gz

# Use /tmp for deployment packages
tar -czf /tmp/deployment.tar.gz --exclude='.git' .
```

## 📊 **Version Management**

### **Current Versions**
- **Atlanta 2025.4.ATL** (latest) - Active workshop content
- **Orlando 2025.1.ORL** (historical) - Protected legacy content

### **Version Protection**
- Orlando version is automatically backed up before deployments
- Restoration available from `backup-gh-pages-20250914-162844`
- Verification checks ensure content integrity

---

## 🎊 **Summary**

The new deployment system provides:
- **⚡ Fast deployments** with simple commands
- **🛡️ Orlando protection** with automatic backup/restore
- **🔄 CI/CD automation** with GitHub Actions
- **📋 Simple workflows** for content updates
- **🚨 Emergency recovery** capabilities

**For most updates, simply run**: `./scripts/quick-deploy.sh both`
