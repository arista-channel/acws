# Arista Campus Workshop Documentation

[![GitHub Pages](https://img.shields.io/badge/GitHub%20Pages-Live-brightgreen)](https://mbalagot12.github.io/campus-workshop/)
[![MkDocs](https://img.shields.io/badge/MkDocs-Material-blue)](https://squidfunk.github.io/mkdocs-material/)
[![Python](https://img.shields.io/badge/Python-3.9+-blue)](https://www.python.org/)
[![uv](https://img.shields.io/badge/uv-package%20manager-orange)](https://github.com/astral-sh/uv)

Comprehensive documentation for the Arista Campus Workshop, featuring hands-on labs for wired, wireless, and security solutions. Built with MkDocs Material and deployed with versioning support via Mike.

## 🏗️ Project Architecture

- **Documentation Engine**: [MkDocs](https://www.mkdocs.org/) with [Material Theme](https://squidfunk.github.io/mkdocs-material/)
- **Version Control**: Git with GitHub hosting
- **Versioning**: [Mike](https://github.com/jimporter/mike) for documentation versioning
- **Package Management**: [uv](https://github.com/astral-sh/uv) for fast Python dependency management
- **Deployment**: GitHub Pages with automated CI/CD
- **Interactive Features**: Embedded AI lab automation agents

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

```
campus-workshop/
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
├── mkdocs.yml                     # MkDocs configuration
├── pyproject.toml                 # Python project configuration
├── requirements.txt               # Python dependencies
├── uv.lock                        # uv lockfile for reproducible builds
└── mkdocs-version-control.sh      # Version deployment script
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

### Version Management

This project uses **Mike** for documentation versioning:

```bash
# Deploy new version for a specific workshop
mike deploy 2025.3.ATL latest --update-aliases --push

# Deploy historical version
mike deploy 2025.1.ORL --push

# Set default version
mike set-default latest --push
```

### AI Lab Automation

The project includes embedded AI agents for lab automation:

- **Interactive Learning**: Agents pause between commands for discussion
- **Realistic Outputs**: Mock command outputs for demonstration
- **Progress Tracking**: Visual feedback throughout labs
- **Mobile Responsive**: Works on all devices

## 🚀 Deployment

### GitHub Pages (Automatic)

The site automatically deploys to GitHub Pages on push to `main` branch:
- **Live Site**: https://mbalagot12.github.io/campus-workshop/
- **Versioned Docs**: Multiple workshop versions available via dropdown

### Manual Deployment

```bash
# Build and deploy specific version
./mkdocs-version-control.sh

# Or deploy manually
mike deploy 2025.3.ATL latest --update-aliases --push
mike set-default latest --push
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

## 📚 Resources

- **[MkDocs Documentation](https://www.mkdocs.org/)** - Core documentation engine
- **[Material Theme](https://squidfunk.github.io/mkdocs-material/)** - Theme and components
- **[Mike Documentation](https://github.com/jimporter/mike)** - Version management
- **[uv Documentation](https://github.com/astral-sh/uv)** - Package management
- **[GitHub Pages](https://pages.github.com/)** - Hosting platform

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
