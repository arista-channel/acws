# 🚀 CI/CD Pipeline Documentation

This directory contains comprehensive CI/CD pipeline documentation for the Campus Workshop project.

## 📋 **Documentation Files**

### **Main Guides**
- **`CI_CD_PIPELINE.md`** - Complete pipeline documentation and usage guide
- **`SAFE_DEPLOYMENT_SUMMARY.md`** - Safety mechanisms and operational site protection
- **`PIPELINE_QUICK_REFERENCE.md`** - Quick commands and troubleshooting guide
- **`PIPELINE_DEPLOYMENT_SUMMARY.md`** - Component overview and deployment summary

### **Setup Tools**
- **`setup-pipeline.sh`** - Automated pipeline setup script
- **`setup-ssh-key.sh`** - SSH key configuration for server deployment

## 🛡️ **Key Features**

- **Operational Site Protection** - Never overwrites existing Mike site at `acws.duckdns.org`
- **Orlando 2025.1.ORL Protection** - Triple-layer protection for historical content
- **Safe Updates** - Selective version updates without destructive operations
- **Automated Backups** - Created before any deployment
- **Dry Run Testing** - Verify deployments before going live

## 🎯 **Quick Start**

1. **Setup SSH Key**: Run `./setup-ssh-key.sh`
2. **Add to GitHub Secrets**: Copy SSH key to repository secrets
3. **Test Pipeline**: Use dry run mode first
4. **Deploy Safely**: Updates go to correct Mike versions

## 🌐 **Deployment Targets**

- **GitHub Pages**: https://mbalagot12.github.io/campus-workshop/
- **Operational Site**: http://acws.duckdns.org/
- **Protected Orlando**: http://acws.duckdns.org/2025.1.ORL/ (never updated)

For detailed instructions, see the individual documentation files above.
