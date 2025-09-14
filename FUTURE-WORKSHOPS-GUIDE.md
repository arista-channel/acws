# Future Workshops Management Guide

## 🚀 Overview

This system allows you to easily create and manage unlimited future workshop versions while maintaining protection for historical versions and current active workshops.

## 📋 Current Version Structure

| Version | Status | City | Protection | Description |
|---------|--------|------|------------|-------------|
| **2025.1.ORL** | 🔒 Historical | Orlando | PROTECTED | Cannot be modified |
| **2025.2.NAS** | 📍 Current [latest] | Nashville | RESTRICTED | Warnings before changes |
| **2025.3.TOR** | ✅ Development | Toronto | FLEXIBLE | Open for changes |
| **2025.4.ATL** | 🏙️ Future | Atlanta | FLEXIBLE | Ready for development |
| **2025.5.BAY** | 🌉 Future | Bay Area | FLEXIBLE | Ready for development |

## ➕ Adding New Workshop Versions

### Quick Method
```bash
# Make script executable (first time only)
chmod +x add-workshop-version.sh

# Add new workshop version
./add-workshop-version.sh 2025.6.NYC "New York City" "NYC 2025.6"
./add-workshop-version.sh 2025.7.CHI "Chicago" "Chicago 2025.7"
./add-workshop-version.sh 2025.8.SEA "Seattle" "Seattle 2025.8"
```

### Manual Method
```bash
# Create new version
mike deploy 2025.6.NYC --title "NYC 2025.6"

# Add protection configuration
echo '2025_6_NYC_PROTECTION="FLEXIBLE"' >> mike-protection.conf
echo '2025_6_NYC_DESCRIPTION="New York City workshop - Future"' >> mike-protection.conf
```

## 🏙️ Developing Future Workshops

### Step 1: Switch to Future Version
```bash
# Set the version you want to develop
mike set-default 2025.4.ATL
```

### Step 2: Customize Content
- Edit `docs/` files for Atlanta-specific content
- Create `data/atlanta_lab_assignment.csv` if needed
- Update topology images in `docs/assets/images/topology/`
- Modify lab assignments and access information

### Step 3: Test Locally
```bash
# Serve locally to test
mike serve -a 0.0.0.0:8001

# Check your version at:
# http://localhost:8001/2025.4.ATL/
```

### Step 4: Deploy Updates
```bash
# Deploy your changes
mike deploy 2025.4.ATL --title "Atlanta 2025.4"
```

### Step 5: Make It Current (When Ready)
```bash
# Make Atlanta the latest version
mike deploy 2025.4.ATL --title "Atlanta 2025.4" --update-aliases
```

## 🛡️ Protection Levels

### FLEXIBLE (Default for new versions)
- Full development freedom
- No warnings or restrictions
- Perfect for development and future workshops

### RESTRICTED (For active workshops)
- Warnings before modifications
- Suitable for current/active workshops
- Prevents accidental changes

### PROTECTED (For historical versions)
- Cannot be modified
- Permanent preservation
- Used for completed workshops like Orlando

## 📝 Version Naming Convention

| Pattern | City | Example |
|---------|------|---------|
| 2025.4.ATL | Atlanta | Atlanta 2025.4 |
| 2025.5.BAY | Bay Area | Bay Area 2025.5 |
| 2025.6.NYC | New York City | NYC 2025.6 |
| 2025.7.CHI | Chicago | Chicago 2025.7 |
| 2025.8.SEA | Seattle | Seattle 2025.8 |
| 2025.9.DEN | Denver | Denver 2025.9 |
| 2025.10.PHX | Phoenix | Phoenix 2025.10 |

## 🔄 Workshop Lifecycle Management

### 1. Planning Phase
```bash
# Create future version
./add-workshop-version.sh 2025.6.NYC "New York City" "NYC 2025.6"
```

### 2. Development Phase
```bash
# Switch to development
mike set-default 2025.6.NYC

# Customize content for NYC
# - Edit docs/ files
# - Create NYC-specific CSV data
# - Update images and topology
```

### 3. Testing Phase
```bash
# Test locally
mike serve -a 0.0.0.0:8001
# Visit http://localhost:8001/2025.6.NYC/
```

### 4. Pre-Workshop Phase
```bash
# Make it current
mike deploy 2025.6.NYC --title "NYC 2025.6" --update-aliases

# Change protection to RESTRICTED
# Edit mike-protection.conf: 2025_6_NYC_PROTECTION="RESTRICTED"
```

### 5. Post-Workshop Phase
```bash
# Archive as historical
# Edit mike-protection.conf: 2025_6_NYC_PROTECTION="PROTECTED"

# Create next workshop
./add-workshop-version.sh 2025.7.CHI "Chicago" "Chicago 2025.7"
```

## 🌐 Access URLs

### Local Development
- Orlando Historical: http://localhost:8001/2025.1.ORL/
- Nashville Current: http://localhost:8001/2025.2.NAS/
- Toronto Development: http://localhost:8001/2025.3.TOR/
- Atlanta Future: http://localhost:8001/2025.4.ATL/
- Bay Area Future: http://localhost:8001/2025.5.BAY/

### GitHub Pages (After Push)
- Orlando Historical: https://mbalagot12.github.io/campus-workshop/2025.1.ORL/
- Nashville Current: https://mbalagot12.github.io/campus-workshop/2025.2.NAS/
- Default (Latest): https://mbalagot12.github.io/campus-workshop/

## 🚀 Deployment Commands

### Local Deployment
```bash
mike deploy 2025.4.ATL --title "Atlanta 2025.4"
```

### GitHub Pages Deployment
```bash
mike deploy 2025.4.ATL --title "Atlanta 2025.4" --push
```

### Make Version Latest
```bash
mike deploy 2025.4.ATL --title "Atlanta 2025.4" --update-aliases --push
```

## 📊 Useful Commands

### List All Versions
```bash
mike list
```

### Check Protection Status
```bash
./mike-safe-operations.sh status
```

### Serve Locally
```bash
mike serve -a 0.0.0.0:8001
```

### Delete Version (Use with caution)
```bash
mike delete 2025.X.XXX
```

## 🎯 Best Practices

1. **Always test locally** before pushing to GitHub Pages
2. **Use FLEXIBLE protection** for development versions
3. **Switch to RESTRICTED** when workshop becomes active
4. **Archive as PROTECTED** after workshop completion
5. **Follow naming convention** for consistency
6. **Create city-specific CSV data** when needed
7. **Update topology images** for each location
8. **Document changes** in version titles

## 🔧 System Files

- `add-workshop-version.sh` - Helper script for adding new versions
- `mike-protection.conf` - Protection configuration
- `mike-safe-operations.sh` - Safe operations with protection
- `mkdocs-version-control-protected.sh` - Protected deployment script
- `FUTURE-WORKSHOPS-GUIDE.md` - This guide

## 🎉 Ready for Unlimited Future Workshops!

The system is now configured to handle unlimited future workshop versions while maintaining complete protection for historical data and current workshops. You can easily add new cities and manage the entire workshop lifecycle with simple commands.
