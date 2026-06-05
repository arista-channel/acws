# 🔧 Tools Directory

This directory contains all scripts and utilities for the Arista Campus Workshop project.

## 📁 Directory Structure

```
tools/
├── deployment/         # Deployment automation scripts
├── testing/           # Testing and validation scripts  
├── legacy/            # Archived one-off/legacy scripts
└── README.md          # This file
```

---

## 🚀 Deployment Scripts (`deployment/`)

Scripts for deploying the workshop documentation to various environments.

### **Active Scripts:**

- **`manual-deploy.sh`** - Manual deployment to AWS EC2 nginx server
- **`setup-ssh-key.sh`** - SSH connection setup and validation
- **`safe-content-import.sh`** - Safe content import from backups
- **`setup-pipeline.sh`** - CI/CD pipeline setup

### **Usage:**
```bash
# Deploy to AWS EC2 nginx server
./tools/deployment/manual-deploy.sh

# Test SSH connection
./tools/deployment/setup-ssh-key.sh
```

**Note:** For GitHub Pages deployment, use `scripts/quick-deploy.sh` in the project root.

---

## 🧪 Testing Scripts (`testing/`)

Currently empty - reserved for future test automation scripts.

---

## 📦 Legacy Scripts (`legacy/`)

Archived scripts that were used for one-time tasks or are no longer actively maintained.

### **Contents:**

- **`generate_clickable_lab_assignment.py`** - Lab assignment generator (legacy)
- **`transport_lab_data.py`** - CSV data transport utility (legacy)
- **`convert_mp4_to_gif.sh`** - Video to GIF converter (one-off)
- **`enhance_gifs.sh`** - GIF enhancement script (one-off)
- **`refresh-github-actions.sh`** - Manual GitHub Actions trigger (legacy)
- **`quick-deploy-old.sh`** - Old deployment script (superseded by scripts/quick-deploy.sh)

**Note:** These scripts are kept for historical reference but are not actively maintained.

---

## 🔄 Active Scripts Location

**Primary deployment scripts** are in `scripts/` directory:
- `scripts/deploy.sh` - Main deployment script
- `scripts/quick-deploy.sh` - Quick deployment (GitHub Pages + nginx)
- `scripts/test-deployment.sh` - Deployment testing
- `scripts/protect-orlando.sh` - Version protection

---

## 📚 Related Documentation

For historical documentation and guides, see:
- **`.archive/`** - Legacy documentation files
- **`README.md`** - Main project documentation
- **`CONTRIBUTING.md`** - Contribution guidelines

---

## 💡 Best Practices

1. **Use scripts/ for active deployment** - The `scripts/` directory contains actively maintained deployment scripts
2. **Use tools/deployment/ for manual tasks** - One-off or manual deployment tasks
3. **Document new scripts** - Add descriptions here when adding new tools
4. **Archive obsolete scripts** - Move to `legacy/` when no longer needed

---

**Last Updated:** 2026-05-07  
**Maintained By:** Arista Channel Partner Team
