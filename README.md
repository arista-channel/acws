# Arista Campus Workshop Documentation

[![GitHub Pages](https://img.shields.io/badge/GitHub%20Pages-Live-brightgreen)](https://mbalagot12.github.io/campus-workshop/)
[![Operational Site](https://img.shields.io/badge/Operational%20Site-Live-success)](http://acws.duckdns.org/)
[![MkDocs](https://img.shields.io/badge/MkDocs-Material-blue)](https://squidfunk.github.io/mkdocs-material/)
[![Python](https://img.shields.io/badge/Python-3.9+-blue)](https://www.python.org/)
[![uv](https://img.shields.io/badge/uv-package%20manager-orange)](https://github.com/astral-sh/uv)
[![CI/CD](https://img.shields.io/badge/CI%2FCD-Safe%20Pipeline-green)](./CI_CD_README.md)

Comprehensive documentation for the Arista Campus Workshop, featuring hands-on labs for wired, wireless, and security solutions. Built with MkDocs Material with **safe CI/CD pipeline** and **Mike versioning** for multiple workshop deployments.

## 🏗️ Project Architecture

- **Documentation Engine**: [MkDocs](https://www.mkdocs.org/) with [Material Theme](https://squidfunk.github.io/mkdocs-material/)
- **Version Control**: Git with GitHub hosting
- **Versioning**: [Mike](https://github.com/jimporter/mike) for documentation versioning with **Orlando 2025.1.ORL protection**
- **Package Management**: [uv](https://github.com/astral-sh/uv) for fast Python dependency management
- **CI/CD Pipeline**: **Safe automated deployment** to operational site (`acws.duckdns.org`) and GitHub Pages
- **Deployment Protection**: Non-destructive updates with backup creation and dry-run testing
- **Interactive Features**: Embedded AI lab automation agents

## 🌐 **Live Sites**

- **🚀 Operational Site**: [acws.duckdns.org](http://acws.duckdns.org/) - Production workshop site
- **📖 GitHub Pages**: [mbalagot12.github.io/campus-workshop](https://mbalagot12.github.io/campus-workshop/) - Backup/testing site
- **🛡️ Protected Orlando**: [acws.duckdns.org/2025.1.ORL](http://acws.duckdns.org/2025.1.ORL/) - Historical content (never updated)

## 🚀 Quick Start for Contributors

### Prerequisites

- **Python 3.9+** (check with `python3 --version`)
- **Git** for version control
- **uv** for package management (recommended)

### 1. Clone and Setup

```bash
# Clone the repository
git clone https://github.com/mbalagot12/campus-workshop.git
cd campus-workshop

# Install uv (if not already installed)
curl -LsSf https://astral.sh/uv/install.sh | sh  # macOS/Linux
# or
irm https://astral.sh/uv/install.ps1 | iex       # Windows PowerShell
```

### 2. Environment Setup with uv

```bash
# Create virtual environment and install dependencies
uv sync

# Activate the virtual environment
source .venv/bin/activate  # macOS/Linux
# or
.venv\Scripts\activate     # Windows
```

### 3. Development Workflow

```bash
# Serve documentation locally with live reload
mkdocs serve

# Open browser to http://127.0.0.1:8000

# Build static site
mkdocs build
```

### 4. Version Management

```bash
# Deploy a new version (example: 2025.3.ATL)
mike deploy 2025.3.ATL latest --update-aliases

# Set default version
mike set-default latest

# List all versions
mike list

# Serve all versions locally
mike serve
```

## 📁 Project Structure

```text
campus-workshop/
├── .github/workflows/             # CI/CD pipeline workflows
│   ├── deploy-docs.yml            # GitHub Pages deployment
│   ├── deploy-nginx.yml           # Operational site deployment
│   ├── test-docs.yml              # Testing and validation
│   └── maintenance.yml            # Automated maintenance
├── docs/                          # Documentation source files
│   ├── a_wired/                   # Wired lab guides (A01-A04)
│   ├── b_wireless/                # Wireless lab guides (B01-B04)
│   ├── c_security/                # Security lab guides (C01-C03)
│   ├── d_sdwan/                   # SD-WAN lab guides (D01-D03)
│   ├── lab/                       # Lab access and setup
│   ├── references/                # Reference materials and tools
│   ├── assets/                    # Images, diagrams, and media
│   ├── snippets/                  # Reusable content snippets
│   └── index.md                   # Homepage with embedded AI features
├── data/                          # Lab assignment data (CSV files)
├── automation/                    # AI lab automation agents
├── includes/                      # MkDocs includes (abbreviations, etc.)
├── CI_CD_*.md                     # CI/CD pipeline documentation
├── setup-*.sh                     # Pipeline setup scripts
├── mkdocs.yml                     # MkDocs configuration
├── pyproject.toml                 # Python project configuration
├── requirements.txt               # Python dependencies
└── uv.lock                        # uv lockfile for reproducible builds
```

## 🔧 Development Guidelines

### Adding New Content

1. **Lab Guides**: Place in appropriate directory (`a_wired/`, `b_wireless/`, etc.)
2. **Images**: Store in `docs/assets/images/` with descriptive names
3. **References**: Add to `docs/references/` and update navigation in `mkdocs.yml`
4. **Data Files**: Place CSV files in `data/` directory

### Markdown Standards

- Use **admonitions** for tips, warnings, and notes
- Include **code blocks** with syntax highlighting
- Add **line numbers** and **highlighting** for important lines
- Use **tabbed content** for multi-step procedures
- Include **interactive elements** where appropriate

### Version Management & CI/CD Pipeline

This project uses **Mike** for documentation versioning with **safe CI/CD automation**:

#### **🛡️ Safe Version Updates**

```bash
# Update Nashville version (example)
mike deploy 2025.2.NAS --title "Nashville 2025.2" --update-aliases
git add . && git commit -m "Update Nashville content" && git push

# ✅ Automated CI/CD will safely deploy to:
# - GitHub Pages: https://mbalagot12.github.io/campus-workshop/2025.2.NAS/
# - Operational Site: http://acws.duckdns.org/2025.2.NAS/
# - Orlando 2025.1.ORL remains protected (never updated)
```

#### **🔒 Orlando Protection**

```bash
# ❌ PROTECTED - Orlando version is never updated by CI/CD
# ✅ Historical content preserved at: http://acws.duckdns.org/2025.1.ORL/
```

#### **📋 CI/CD Pipeline Features**

- **🛡️ Operational Site Protection** - Never overwrites existing Mike site
- **🔒 Orlando 2025.1.ORL Protection** - Triple-layer protection for historical content
- **💾 Automatic Backups** - Created before any deployment
- **🧪 Dry Run Testing** - Verify deployments before going live
- **📊 Selective Updates** - Only updates specified version directories

For detailed CI/CD documentation, see: **[CI_CD_README.md](./CI_CD_README.md)**

### AI Lab Automation

The project includes embedded AI agents for lab automation:

- **Interactive Learning**: Agents pause between commands for discussion
- **Realistic Outputs**: Mock command outputs for demonstration
- **Progress Tracking**: Visual feedback throughout labs
- **Mobile Responsive**: Works on all devices

## 🚀 Deployment

### **Automated CI/CD Pipeline** ⭐

The project features a **safe CI/CD pipeline** that automatically deploys to both sites:

**Triggers:**
- Push to `main` branch
- Manual GitHub Actions workflow dispatch

**Deployment Targets:**

- **GitHub Pages**: [mbalagot12.github.io/campus-workshop](https://mbalagot12.github.io/campus-workshop/)
- **Operational Site**: [acws.duckdns.org](http://acws.duckdns.org/)

**Safety Features:**

- ✅ **Non-destructive updates** - Never overwrites operational site
- ✅ **Orlando protection** - 2025.1.ORL version never touched
- ✅ **Automatic backups** - Created before any changes
- ✅ **Dry run testing** - Test deployments before going live

### Manual Deployment (Advanced)

```bash
# Deploy specific version locally
mike deploy 2025.2.NAS --title "Nashville 2025.2" --update-aliases

# Push to trigger CI/CD
git add . && git commit -m "Update content" && git push
```

## 🛠️ Troubleshooting

### Common Issues

- **uv not found**: Install uv using the installation script above
- **Permission errors**: Ensure proper Git credentials for GitHub
- **Build failures**: Check `mkdocs.yml` syntax and file paths
- **Version conflicts**: Use `uv sync` to resolve dependencies

### Development Tips

- Use `mkdocs serve` for live reload during development
- Test all versions with `mike serve` before deployment
- Validate markdown with the built-in linting tools
- Check responsive design on mobile devices

## 🔧 **CI/CD Pipeline for Collaborators**

### **Safe Version Updates**

When updating workshop content, the CI/CD pipeline ensures safe deployment:

1. **Make Changes**: Edit content in appropriate version directories
2. **Deploy Locally**: `mike deploy 2025.X.XXX --title "Workshop Name"`
3. **Commit & Push**: `git add . && git commit -m "Update content" && git push`
4. **Automated Deployment**: Pipeline safely updates both sites

### **Protection Guarantees**

- **🛡️ Orlando 2025.1.ORL**: Historical content never modified
- **🏠 Operational Site**: `acws.duckdns.org` never overwritten
- **💾 Backups**: Automatic backup creation before changes
- **🧪 Testing**: Dry run capability for safe testing

### **For Detailed CI/CD Documentation**

See: **[CI_CD_README.md](./CI_CD_README.md)** for complete pipeline documentation.

## 📚 Resources

- **[MkDocs Documentation](https://www.mkdocs.org/)** - Core documentation engine
- **[Material Theme](https://squidfunk.github.io/mkdocs-material/)** - Theme and components
- **[Mike Documentation](https://github.com/jimporter/mike)** - Version management
- **[uv Documentation](https://github.com/astral-sh/uv)** - Package management
- **[GitHub Pages](https://pages.github.com/)** - Hosting platform
- **[GitHub Actions](https://docs.github.com/en/actions)** - CI/CD automation

## 👥 Contributors

### Original Maintainers
- **Kyle Bush** ([kbush@arista.com](mailto:kbush@arista.com)) - Original content creator
- **Larry Gomez** ([larry@arista.com](mailto:larry@arista.com)) - Technical reviewer

### Channel Partner Edition
- **Miguel Balagot** ([mbalagot@arista.com](mailto:mbalagot@arista.com)) - Channel partner adaptation, AI automation, modern tooling

## 📄 License

This project is maintained by Arista Networks for educational purposes. All content is proprietary to Arista Networks and intended for authorized workshop participants.

---

**Ready to contribute? Fork the repo, make your changes, and submit a pull request! 🚀**
