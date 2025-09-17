# Campus Workshop CI/CD Pipeline - Quick Reference

## 🚀 Quick Start

### 1. Setup (One-time)
```bash
# Run setup script
./setup-pipeline.sh

# Add SSH key to GitHub secrets
# Go to: Settings → Secrets and variables → Actions
# Add: NGINX_SERVER_SSH_KEY (your mb-acws1 private key)
```

### 2. Deploy New Version
```bash
# Method 1: Automatic (push to main)
git add docs/
git commit -m "Update Nashville content"
git push origin main
# → Automatically deploys to 2025.2.NAS

# Method 2: Manual
# Go to GitHub Actions → Deploy Campus Workshop Documentation
# Set version: 2025.2.NAS, 2025.3.TOR, etc.
# Run workflow
```

## 🛡️ Orlando Protection Rules

### ❌ NEVER DO THIS:
- Deploy to version `2025.1.ORL`
- Modify Orlando historical content
- Override Orlando protection

### ✅ ALWAYS DO THIS:
- Deploy to `2025.2.NAS`, `2025.3.TOR`, `2025.4.ATL`, `2025.5.BAY`
- Test with dry run first
- Verify Orlando remains intact

## 📋 Common Commands

### Local Testing
```bash
# Activate environment
source .venv/bin/activate

# Check versions
mike list

# Test build
mkdocs build --strict

# Test version deployment (local only)
mike deploy 2025.2.NAS "Test build"
mike list
mike delete 2025.2.NAS  # cleanup
```

### Pipeline Operations
```bash
# Dry run test
# GitHub Actions → Deploy Campus Workshop Documentation
# ✅ Check "Dry run"
# Set version: 2025.2.NAS
# Run workflow

# Live deployment
# Same as above but uncheck "Dry run"

# Manual nginx deployment
# GitHub Actions → Deploy to Nginx Server
# Set server: mb-acws1
# Run workflow
```

## 🌐 URLs

| Environment | Base URL | Orlando URL |
|-------------|----------|-------------|
| **GitHub Pages** | https://mbalagot12.github.io/campus-workshop/ | https://mbalagot12.github.io/campus-workshop/2025.1.ORL/ |
| **Nginx Server** | http://ec2-3-148-13-216.us-east-2.compute.amazonaws.com/ | http://ec2-3-148-13-216.us-east-2.compute.amazonaws.com/2025.1.ORL/ |
| **Local Dev** | http://localhost:8000/ | http://localhost:8000/2025.1.ORL/ |

## 🔧 Troubleshooting

### Pipeline Fails
1. Check GitHub Actions logs
2. Run dry run to test
3. Verify secrets are configured
4. Check SSH connectivity

### Orlando Missing
```bash
# Check server backups
ssh -i ~/Documents/MyKeyPairs/mb-partner-kp.pem ubuntu@ec2-3-148-13-216.us-east-2.compute.amazonaws.com
sudo find /var/www/ -name "campus-workshop.backup.*" -type d

# Restore from backup
sudo cp -r /var/www/campus-workshop.backup.LATEST/2025.1.ORL /var/www/campus-workshop/
```

### Site Not Accessible
```bash
# Check nginx status
ssh -i ~/Documents/MyKeyPairs/mb-partner-kp.pem ubuntu@ec2-3-148-13-216.us-east-2.compute.amazonaws.com
sudo systemctl status nginx
sudo nginx -t

# Check site directory
ls -la /var/www/campus-workshop/
```

## 📊 Version Management

### Current Versions
```
"Bay Area 2025.5" (2025.5.BAY)
"Atlanta 2025.4" (2025.4.ATL)
"Toronto 2025.3" (2025.3.TOR)
"Nashville 2025.2" (2025.2.NAS) [latest]
"Orlando 2025.1 - Historical" (2025.1.ORL) [PROTECTED]
```

### Version Content Mapping
| Version | Workshop | Data File | Topology | Banner |
|---------|----------|-----------|----------|---------|
| 2025.1.ORL | Orlando July 14-15, 2025 | orlando_lab_assignment.csv | atd_student-light_orlando.png | Simple |
| 2025.2.NAS | Nashville Oct. 28-29, 2025 | lab_assignment.csv | atd_student-light.png | Interactive |
| 2025.3.TOR | Toronto Future | lab_assignment.csv | atd_student-light.png | Interactive |
| 2025.4.ATL | Atlanta Future | lab_assignment.csv | atd_student-light.png | Interactive |
| 2025.5.BAY | Bay Area Future | lab_assignment.csv | atd_student-light.png | Interactive |

## 🚨 Emergency Procedures

### 1. Pipeline Completely Broken
```bash
# Manual deployment
source .venv/bin/activate
mike deploy 2025.2.NAS "Emergency fix" --push
```

### 2. Orlando Accidentally Overwritten
```bash
# Restore from server backup
ssh ubuntu@mb-acws1
sudo cp -r /var/www/campus-workshop.backup.LATEST/2025.1.ORL /var/www/campus-workshop/

# Or restore from git history
git log --oneline --follow data/orlando_lab_assignment.csv
git checkout COMMIT_HASH -- data/orlando_lab_assignment.csv
git checkout COMMIT_HASH -- docs/assets/images/topology/atd_student-light_orlando.png
```

### 3. Server Completely Down
```bash
# Check server status
ssh ubuntu@mb-acws1
sudo systemctl status nginx
sudo systemctl restart nginx

# Redeploy if needed
# GitHub Actions → Deploy to Nginx Server → Run workflow
```

## 📈 Monitoring Checklist

### Daily
- [ ] Check GitHub Actions for failures
- [ ] Verify site accessibility
- [ ] Confirm Orlando protection intact

### Weekly (Automated)
- [ ] Maintenance workflow runs
- [ ] Backup cleanup
- [ ] Log rotation
- [ ] Health checks

### Monthly
- [ ] Review backup retention
- [ ] Check disk usage
- [ ] Update dependencies
- [ ] Security review

## 🎯 Best Practices

### Development
1. **Always test locally first**
2. **Use dry run for new deployments**
3. **Never deploy to 2025.1.ORL**
4. **Commit frequently with clear messages**

### Deployment
1. **Test with dry run**
2. **Deploy during low-traffic times**
3. **Monitor for 15 minutes after deployment**
4. **Keep deployment messages descriptive**

### Maintenance
1. **Run maintenance monthly**
2. **Keep 5 recent backups**
3. **Monitor disk usage**
4. **Update documentation**

## 📞 Support

### GitHub Issues
- Pipeline failures
- Feature requests
- Bug reports

### Server Issues
- SSH connectivity: Check network/VPN
- Nginx problems: Check server logs
- Disk space: Run maintenance workflow

### Orlando Protection
- **CRITICAL**: Never override protection
- **BACKUP**: Always verify backups exist
- **RESTORE**: Use server backups first, git history second

---

**Remember: Orlando 2025.1.ORL is historically protected and must never be overwritten!** 🛡️
