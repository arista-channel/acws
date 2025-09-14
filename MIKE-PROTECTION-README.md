# 🛡️ Mike Version Protection System

## Overview

This protection system prevents accidental overwrites of Mike documentation versions while maintaining operational flexibility. It provides multi-layered protection, automated backups, audit logging, and safe deployment workflows.

## 🚀 Quick Start

### 1. Basic Usage

```bash
# List versions with protection status
./mike-safe-operations.sh list

# Deploy a version safely
./mike-safe-operations.sh deploy 2025.3.TOR

# Create a backup
./mike-safe-operations.sh backup 2025.2.NAS

# Check system status
./mike-safe-operations.sh status
```

### 2. Protected Deployment

```bash
# Use the enhanced version control script
./mkdocs-version-control-protected.sh
```

## 📋 Protection Levels

### 🔒 **PROTECTED** (Historical/Critical)
- **Versions**: `2025.1.ORL` (Orlando historical)
- **Behavior**: 
  - Blocks deployment by default
  - Requires `--force-protected` flag
  - Creates mandatory backups
  - Requires explicit confirmation
  - Cannot be deleted

### ⚠️ **RESTRICTED** (Active/Current)
- **Versions**: `2025.2.NAS` (Nashville current)
- **Behavior**:
  - Requires user confirmation
  - Creates automatic backups
  - Logs all operations
  - Can be deployed with warnings

### ✅ **FLEXIBLE** (Development/Future)
- **Versions**: `2025.3.TOR` (Toronto placeholder)
- **Behavior**:
  - Standard deployment process
  - Optional backups
  - Basic logging

## 🛠️ Available Scripts

### 1. `mkdocs-version-control-protected.sh`
Enhanced version control script with comprehensive protection.

**Features:**
- Multi-level version protection
- Automated backup creation
- User confirmation prompts
- Comprehensive audit logging
- Safe deployment workflows

**Usage:**
```bash
./mkdocs-version-control-protected.sh
```

### 2. `mike-safe-operations.sh`
Safe wrapper for common Mike operations.

**Commands:**
```bash
# List versions with protection status
./mike-safe-operations.sh list

# Deploy version with protection checks
./mike-safe-operations.sh deploy <version> [--force]

# Safely delete version (with backup)
./mike-safe-operations.sh delete <version>

# Create manual backup
./mike-safe-operations.sh backup <version>

# Show system status
./mike-safe-operations.sh status

# View audit log
./mike-safe-operations.sh audit

# Show help
./mike-safe-operations.sh help
```

## ⚙️ Configuration

### Protection Configuration (`mike-protection.conf`)

```bash
# Protected versions (highest protection)
PROTECTED_VERSIONS=(2025.1.ORL)

# Restricted versions (requires confirmation)
RESTRICTED_VERSIONS=(2025.2.NAS)

# Flexible versions (standard deployment)
FLEXIBLE_VERSIONS=(2025.3.TOR)

# Settings
REQUIRE_CONFIRMATION=true
CREATE_BACKUPS=true
ENABLE_AUDIT_LOG=true
MAX_BACKUPS=10
```

## 💾 Backup System

### Automatic Backups
- Created before any deployment to existing versions
- Stored in `.mike-backups/` directory
- Include metadata and timestamps
- Automatic cleanup (keeps last 10 backups per version)

### Backup Structure
```
.mike-backups/
├── 2025.1.ORL_20250914_143022/
│   ├── backup_metadata.json
│   └── [version content]
├── 2025.2.NAS_20250914_143045/
│   ├── backup_metadata.json
│   └── [version content]
└── ...
```

### Manual Backups
```bash
# Create backup of specific version
./mike-safe-operations.sh backup 2025.2.NAS
```

## 📊 Audit Logging

All operations are logged to `mike-audit.log`:

```
2025-09-14 14:30:22 - SYSTEM_INIT: Protection system initialized
2025-09-14 14:30:25 - DEPLOYMENT_START: 2025.2.NAS (protection: RESTRICTED, exists: true)
2025-09-14 14:30:30 - BACKUP_CREATED: 2025.2.NAS -> .mike-backups/2025.2.NAS_20250914_143030
2025-09-14 14:30:35 - DEPLOYMENT_SUCCESS: 2025.2.NAS as latest
```

### View Audit Log
```bash
./mike-safe-operations.sh audit
```

## 🚨 Emergency Procedures

### 1. Accidental Overwrite Recovery
```bash
# 1. Check available backups
ls -la .mike-backups/

# 2. Identify the correct backup
cat .mike-backups/2025.1.ORL_20250914_143022/backup_metadata.json

# 3. Restore from backup (manual process)
# Copy backup content to appropriate location
# Redeploy using mike
```

### 2. Force Deploy Protected Version
```bash
# Only in extreme circumstances
./mike-safe-operations.sh deploy 2025.1.ORL --force
# Will require typing: "I UNDERSTAND THE RISKS"
```

### 3. System Status Check
```bash
./mike-safe-operations.sh status
```

## 📈 Best Practices

### 1. Regular Operations
- Always use `mike-safe-operations.sh` for version management
- Check protection status before deployments
- Review audit logs regularly
- Maintain backup retention policy

### 2. Protected Version Handling
- Never force deploy protected versions unless absolutely necessary
- Always create backups before any changes
- Document reasons for protected version modifications
- Test recovery procedures regularly

### 3. Configuration Management
- Review protection levels quarterly
- Update configuration as versions change status
- Maintain documentation of protection decisions
- Train team members on protection system

## 🔧 Troubleshooting

### Common Issues

1. **"Version is PROTECTED" Error**
   - This is intentional protection
   - Use `--force` only if absolutely necessary
   - Consider if the operation is really needed

2. **Backup Creation Failed**
   - Check disk space
   - Verify git repository status
   - Check permissions on backup directory

3. **Audit Log Not Working**
   - Verify `ENABLE_AUDIT_LOG=true` in config
   - Check write permissions
   - Ensure audit log file exists

### Getting Help
```bash
./mike-safe-operations.sh help
```

## 🎯 Migration from Old System

### 1. Backup Current State
```bash
# Create backups of all existing versions
for version in $(mike list | grep -E '^[0-9]' | awk '{print $1}'); do
    ./mike-safe-operations.sh backup "$version"
done
```

### 2. Update Scripts
Replace usage of:
- `mkdocs-version-control.sh` → `mkdocs-version-control-protected.sh`
- Direct `mike` commands → `mike-safe-operations.sh`

### 3. Configure Protection
Edit `mike-protection.conf` to match your protection requirements.

## 📞 Support

For issues or questions about the protection system:
1. Check the audit log for recent operations
2. Review the configuration file
3. Test with `--dry-run` flag (when available)
4. Create an issue with detailed logs

---

**Remember**: This protection system is designed to prevent accidents, not to make operations impossible. When in doubt, create a backup first!
