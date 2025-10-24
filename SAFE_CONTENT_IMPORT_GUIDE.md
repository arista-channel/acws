# 🛡️ Safe Content Import Guide

## Overview

The `safe-content-import.sh` script allows you to safely import content from another identical project into a specific Mike version **without affecting any other versions**.

## 🔒 Safety Features

- **🛡️ Orlando Protection** - Cannot modify 2025.1.ORL (hard-coded protection)
- **📋 Interactive Prompts** - You approve every file before copying
- **👀 Preview Mode** - See file differences before copying
- **💾 Automatic Backup** - Creates backup before any changes
- **🎯 Version Isolation** - Only affects the specified Mike version
- **✅ Confirmation Steps** - Multiple confirmation prompts

## 🚀 Usage

### Step 1: Run the Import Script
```bash
./safe-content-import.sh
```

### Step 2: Follow Interactive Prompts

#### **Source Project Path**
```
📁 Enter the path to your source project:
/path/to/your/other/campus-workshop-project
```

#### **Target Version Selection**
```
🎯 Enter the Mike version to update (e.g., 2025.1.SDW):
2025.4.ATL
```

#### **File-by-File Review**
For each file found, you'll be prompted:
```
📄 File: docs/references/lab_assignment.md
❓ Show preview of this file? (y/n): y

[Shows file differences or preview]

❓ Copy this file? (y/n): y
✅ Copied: docs/references/lab_assignment.md
```

#### **Final Deployment**
```
⚠️  About to deploy to Mike version: 2025.4.ATL
ℹ️  Orlando 2025.1.ORL will remain protected
ℹ️  Other versions will remain unchanged
❓ Deploy to 2025.4.ATL now? (y/n): y
```

## 📋 Common Files Detected

The script automatically looks for these common files:
- `docs/index.md` - Main homepage
- `docs/references/lab_assignment.md` - Lab assignment details
- `docs/lab/access.md` - Lab access information
- `data/lab_assignment.csv` - Lab assignment data

## 🛡️ Protection Mechanisms

### **Orlando Protection**
```bash
if [ "$TARGET_VERSION" = "2025.1.ORL" ]; then
    print_error "PROTECTION: Cannot modify Orlando 2025.1.ORL version!"
    exit 1
fi
```

### **Automatic Backup**
```bash
BACKUP_DIR="backup-$(date +%Y%m%d-%H%M%S)"
cp -r docs/ "$BACKUP_DIR"
```

### **Version Isolation**
- Only deploys to the specified Mike version
- Other versions remain completely untouched
- Uses `mike deploy $TARGET_VERSION` for precise targeting

## 📊 Example Session

```bash
$ ./safe-content-import.sh

🎯 SAFE CONTENT IMPORT FOR CAMPUS WORKSHOP
========================================

✅ Virtual environment activated

📁 Enter the path to your source project:
/Users/miguel/other-campus-workshop

✅ Source project found: /Users/miguel/other-campus-workshop

🎯 CURRENT MIKE VERSIONS
=====================
"Bay Area 2025.5" (2025.5.BAY)
"Atlanta 2025.4" (2025.4.ATL)
"Toronto 2025.3" (2025.3.TOR)
"Nashville 2025.2" (2025.2.NAS) [latest]
"Orlando 2025.1 - Historical" (2025.1.ORL)

🎯 Enter the Mike version to update (e.g., 2025.1.SDW):
2025.4.ATL

✅ Target version: 2025.4.ATL

🎯 CREATING BACKUP
===============
✅ Backup created: backup-20250917-194500

🎯 ANALYZING SOURCE CONTENT
========================
ℹ️  Found 4 common files to potentially copy

🎯 CONTENT IMPORT PREVIEW
======================

📄 File: docs/references/lab_assignment.md
❓ Show preview of this file? (y/n): y
📄 File exists, showing differences:
[Shows diff]
❓ Copy this file? (y/n): y
✅ Copied: docs/references/lab_assignment.md

🎯 FINAL CONFIRMATION
==================
⚠️  About to deploy to Mike version: 2025.4.ATL
ℹ️  Orlando 2025.1.ORL will remain protected
ℹ️  Other versions will remain unchanged
❓ Deploy to 2025.4.ATL now? (y/n): y
✅ Deployment complete!

🎯 TESTING
=======
ℹ️  Test locally: mike serve
ℹ️  Then visit: http://127.0.0.1:8000/2025.4.ATL/
❓ Start local test server now? (y/n): y
```

## 🔧 Advanced Usage

### Custom File Selection
If you need to copy specific files not in the common list, you can modify the `COMMON_FILES` array in the script:

```bash
COMMON_FILES=(
    "docs/index.md"
    "docs/references/lab_assignment.md"
    "docs/lab/access.md"
    "docs/custom/my_file.md"        # Add custom files
    "data/lab_assignment.csv"
)
```

### Recovery from Backup
If something goes wrong, restore from backup:
```bash
# List available backups
ls -la backup-*

# Restore from backup
rm -rf docs/
cp -r backup-20250917-194500/ docs/
```

## ✅ Safety Checklist

Before running the import:
- [ ] Source project path is correct
- [ ] Target version is NOT 2025.1.ORL
- [ ] You have reviewed what files will be copied
- [ ] You understand only the target version will be affected

After running the import:
- [ ] Test the target version: `mike serve`
- [ ] Verify other versions are unchanged
- [ ] Commit changes: `git add . && git commit -m "Import content to [VERSION]"`
- [ ] Push to trigger CI/CD: `git push origin main`

## 🌐 Post-Import Testing

```bash
# Test locally
mike serve

# Visit your updated version
# http://127.0.0.1:8000/[YOUR_VERSION]/

# Verify other versions unchanged
# http://127.0.0.1:8000/2025.1.ORL/  (should be unchanged)
# http://127.0.0.1:8000/2025.2.NAS/  (should be unchanged)
```

## 🚨 Emergency Recovery

If anything goes wrong:
```bash
# Stop any running processes
Ctrl+C

# Restore from backup
rm -rf docs/
cp -r backup-[TIMESTAMP]/ docs/

# Reset Mike version if needed
git checkout HEAD -- docs/
mike deploy [VERSION] --title "[VERSION] Workshop"
```

**The script ensures maximum safety while giving you complete control over what gets imported!** 🛡️✅
