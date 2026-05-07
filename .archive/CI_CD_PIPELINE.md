# Campus Workshop CI/CD Pipeline

## 🚀 Overview

This CI/CD pipeline is specifically designed for the Campus Workshop documentation system with **Mike versioning** and **Orlando 2025.1.ORL protection**. It automatically deploys to both GitHub Pages and the mb-acws1 nginx server.

## 🛡️ Orlando Protection

**CRITICAL**: The Orlando 2025.1.ORL version is **historically protected** and cannot be overwritten:

- ❌ **Cannot deploy** to version `2025.1.ORL`
- ✅ **Always preserved** during updates
- 🔒 **Backup created** before any server updates
- 🛡️ **Integrity verified** after each deployment

## 📋 Workflows

### 1. Deploy Documentation (`deploy-docs.yml`)

**Triggers:**
- Push to `main` branch (docs/, data/, mkdocs.yml, requirements.txt changes)
- Manual trigger with version input
- Release tags

**Features:**
- 🔍 **Change detection** - Only deploys when relevant files change
- 🛡️ **Orlando protection** - Prevents overwriting 2025.1.ORL
- 🧪 **Dry run mode** - Test deployments without pushing
- 📊 **Mike versioning** - Proper version management
- 🌐 **GitHub Pages** - Automatic deployment

**Manual Usage:**
```bash
# Go to Actions → Deploy Campus Workshop Documentation → Run workflow
# Set version: 2025.2.NAS, 2025.3.TOR, etc. (NOT 2025.1.ORL)
# Set description: "Nashville Workshop Update"
# Check "Set as default" if needed
# Check "Dry run" to test first
```

### 2. Deploy to Nginx Server (`deploy-nginx.yml`)

**Triggers:**
- Automatic after successful GitHub Pages deployment
- Manual trigger for server updates

**Features:**
- 🔗 **SSH deployment** to ec2-3-148-13-216.us-east-2.compute.amazonaws.com server
- 💾 **Automatic backups** before updates
- 🛡️ **Orlando protection** - Selective updates excluding 2025.1.ORL
- 🔧 **Nginx management** - Configuration validation and reload
- 🧪 **Dry run support** - Test server operations

**Server Path:** `/var/www/campus-workshop`

### 3. Test Documentation (`test-docs.yml`)

**Triggers:**
- Pull requests to main
- Manual trigger

**Features:**
- 🔨 **Build testing** - Validates MkDocs configuration
- 📊 **Mike testing** - Verifies versioning system
- 🛡️ **Protection testing** - Ensures Orlando cannot be overwritten
- 📋 **Data validation** - Checks CSV files and images
- 🏗️ **Structure validation** - Verifies site structure

### 4. Maintenance (`maintenance.yml`)

**Triggers:**
- Weekly schedule (Sundays 2 AM UTC)
- Manual trigger

**Features:**
- 🧹 **Backup cleanup** - Keeps 5 most recent backups
- 🗑️ **Temp file cleanup** - Removes old temporary files
- 📋 **Log rotation** - Manages nginx logs
- 🛡️ **Orlando verification** - Ensures protection integrity
- 🏥 **Health checks** - System status monitoring

## 🔧 Setup Requirements

### GitHub Secrets

Add these secrets to your repository:

```bash
# Required for nginx deployment
NGINX_SERVER_SSH_KEY    # Private key for mb-acws1 server access

# Optional for enhanced GitHub Pages deployment
CAMPUS_WORKSHOP_TOKEN   # Personal Access Token with repo permissions
```

### Server Requirements (ec2-3-148-13-216.us-east-2.compute.amazonaws.com)

```bash
# SSH key setup (using mb-partner-kp.pem)
ssh -i ~/Documents/MyKeyPairs/mb-partner-kp.pem ubuntu@ec2-3-148-13-216.us-east-2.compute.amazonaws.com

# Nginx configuration
sudo apt update
sudo apt install nginx git
sudo systemctl enable nginx

# Site directory
sudo mkdir -p /var/www/campus-workshop
sudo chown -R www-data:www-data /var/www/campus-workshop
```

## 📊 Version Management

### Current Versions

```bash
# Check versions locally
source .venv/bin/activate
mike list

# Expected output:
"Bay Area 2025.5" (2025.5.BAY)
"Atlanta 2025.4" (2025.4.ATL)
"Toronto 2025.3" (2025.3.TOR)
"Nashville 2025.2" (2025.2.NAS) [latest]
"Orlando 2025.1 - Historical" (2025.1.ORL)  # PROTECTED
```

### Safe Version Deployment

✅ **Safe versions to deploy:**
- `2025.2.NAS` - Nashville Workshop
- `2025.3.TOR` - Toronto Workshop
- `2025.4.ATL` - Atlanta Workshop
- `2025.5.BAY` - Bay Area Workshop
- `2025.X.XXX` - Future workshops

❌ **Protected version (DO NOT DEPLOY):**
- `2025.1.ORL` - Orlando Historical (Protected)

### Version-Specific Content

| Version | Header | Data Source | Topology | Banner |
|---------|--------|-------------|----------|---------|
| **2025.1.ORL** | Orlando Lab Assignment - July 14-15, 2025 | orlando_lab_assignment.csv + CV-CUE ATN | atd_student-light_orlando.png | Simple |
| **2025.2.NAS** | Nashville Lab Assignment - Oct. 28-29, 2025 | lab_assignment.csv + ATD Token | atd_student-light.png | Interactive |
| **2025.3.TOR** | Toronto Lab Assignment - Future Workshop | lab_assignment.csv + ATD Token | atd_student-light.png | Interactive |
| **2025.4.ATL** | Atlanta Lab Assignment - Future Workshop | lab_assignment.csv + ATD Token | atd_student-light.png | Interactive |
| **2025.5.BAY** | Bay Area Lab Assignment - Future Workshop | lab_assignment.csv + ATD Token | atd_student-light.png | Interactive |

## 🌐 URLs

### GitHub Pages
- **Main Site**: https://mbalagot12.github.io/campus-workshop/
- **Orlando (Protected)**: https://mbalagot12.github.io/campus-workshop/2025.1.ORL/
- **Nashville**: https://mbalagot12.github.io/campus-workshop/2025.2.NAS/
- **Toronto**: https://mbalagot12.github.io/campus-workshop/2025.3.TOR/
- **Atlanta**: https://mbalagot12.github.io/campus-workshop/2025.4.ATL/
- **Bay Area**: https://mbalagot12.github.io/campus-workshop/2025.5.BAY/

### Nginx Server (mb-acws1)
- **Main Site**: http://mb-acws1/
- **Orlando (Protected)**: http://mb-acws1/2025.1.ORL/
- **Nashville**: http://mb-acws1/2025.2.NAS/
- **Other versions**: http://mb-acws1/[VERSION]/

## 🚨 Emergency Procedures

### Orlando Recovery

If Orlando 2025.1.ORL is accidentally damaged:

```bash
# 1. Check server backups
ssh ubuntu@mb-acws1
sudo find /var/www/ -name "campus-workshop.backup.*" -type d | sort

# 2. Restore from most recent backup
sudo cp -r /var/www/campus-workshop.backup.YYYYMMDD_HHMMSS/2025.1.ORL /var/www/campus-workshop/

# 3. Verify restoration
curl -s http://localhost/2025.1.ORL/ | grep "Orlando"
```

### Pipeline Failure Recovery

```bash
# 1. Check workflow logs in GitHub Actions
# 2. Run dry run to test fixes
# 3. Manual deployment if needed:

source .venv/bin/activate
mike deploy 2025.2.NAS "Emergency deployment" --push
```

## 📈 Monitoring

### Health Checks

The maintenance workflow performs weekly health checks:

- ✅ **Disk usage** monitoring
- ✅ **Memory usage** tracking
- ✅ **Nginx status** verification
- ✅ **Site accessibility** testing
- ✅ **Orlando protection** integrity
- ✅ **Backup management** (keep 5 most recent)

### Alerts

Monitor these indicators:

- 🔴 **Pipeline failures** in GitHub Actions
- 🔴 **Orlando protection violations**
- 🔴 **Server connectivity issues**
- 🔴 **Site accessibility problems**
- 🟡 **Disk space warnings**
- 🟡 **Large log files**

## 🔄 Workflow Examples

### Deploy New Nashville Version

```bash
# 1. Update content in docs/
# 2. Commit and push to main
# 3. Pipeline automatically deploys to 2025.2.NAS
# 4. Nginx server updates automatically
# 5. Orlando 2025.1.ORL remains protected
```

### Manual Toronto Deployment

```bash
# 1. Go to GitHub Actions
# 2. Select "Deploy Campus Workshop Documentation"
# 3. Click "Run workflow"
# 4. Set version: 2025.3.TOR
# 5. Set description: "Toronto Workshop Content"
# 6. Check "Set as default" if needed
# 7. Run workflow
```

### Test Before Deployment

```bash
# 1. Create pull request with changes
# 2. Test workflow runs automatically
# 3. Review test results
# 4. Merge PR to trigger deployment
```

This pipeline ensures reliable, automated deployments while maintaining the historical integrity of the Orlando 2025.1.ORL version! 🚀✨🛡️
