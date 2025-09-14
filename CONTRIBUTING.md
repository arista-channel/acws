# Contributing to Arista Campus Workshop Documentation

Thank you for your interest in contributing to the Arista Campus Workshop documentation! This guide will help you get started with contributing to this project.

## 🏗️ Project Overview

This project uses modern Python tooling and documentation best practices:

- **Documentation**: MkDocs with Material theme
- **Package Management**: uv for fast, reliable dependency management
- **Version Control**: Git with GitHub hosting
- **Versioning**: Mike for documentation versioning
- **Deployment**: GitHub Pages with automated CI/CD
- **Code Quality**: Pre-commit hooks, Black, isort, flake8

## 🚀 Getting Started

### Prerequisites

- Python 3.9 or higher
- Git
- uv (recommended) or pip

### Setup Development Environment

1. **Clone the repository**:
   ```bash
   git clone https://github.com/mbalagot12/campus-workshop.git
   cd campus-workshop
   ```

2. **Install uv** (if not already installed):
   ```bash
   # macOS/Linux
   curl -LsSf https://astral.sh/uv/install.sh | sh
   
   # Windows PowerShell
   irm https://astral.sh/uv/install.ps1 | iex
   ```

3. **Set up the development environment**:
   ```bash
   # Create virtual environment and install dependencies
   uv sync
   
   # Activate virtual environment
   source .venv/bin/activate  # macOS/Linux
   # or
   .venv\Scripts\activate     # Windows
   ```

4. **Install pre-commit hooks**:
   ```bash
   pre-commit install
   ```

## 📝 Making Changes

### Development Workflow

1. **Create a feature branch**:
   ```bash
   git checkout -b feature/your-feature-name
   ```

2. **Make your changes** following the guidelines below

3. **Test your changes locally**:
   ```bash
   mkdocs serve
   ```

4. **Run quality checks**:
   ```bash
   # Format code
   black .
   isort .
   
   # Lint code
   flake8 .
   
   # Check YAML files
   yamllint mkdocs.yml
   ```

5. **Commit your changes**:
   ```bash
   git add .
   git commit -m "feat: add new lab guide for XYZ"
   ```

6. **Push and create a pull request**:
   ```bash
   git push origin feature/your-feature-name
   ```

### Content Guidelines

#### Lab Guides

- **File naming**: Use descriptive names like `a01_explore_eos.md`
- **Structure**: Follow the existing lab structure with clear sections
- **Code blocks**: Use syntax highlighting and line numbers
- **Screenshots**: Place in `docs/assets/images/` with descriptive names
- **Interactive elements**: Include admonitions for tips, warnings, and notes

#### Markdown Standards

- Use **admonitions** for important information:
  ```markdown
  !!! tip "Pro Tip"
      This is a helpful tip for users.
  
  !!! warning "Important"
      This is a warning about potential issues.
  ```

- Use **tabbed content** for multi-step procedures:
  ```markdown
  === "Step 1"
      First step content
  
  === "Step 2"
      Second step content
  ```

- Use **code blocks** with syntax highlighting:
  ```markdown
  ```yaml
  show version
  ```
  ```

#### Images and Assets

- **Optimization**: Compress images before adding
- **Naming**: Use descriptive names like `a01_show_version_output.png`
- **Alt text**: Always include descriptive alt text
- **Size**: Keep images under 500KB when possible

### Version Management

This project uses Mike for documentation versioning:

```bash
# Deploy a new version
mike deploy 2025.3.ATL latest --update-aliases

# Set default version
mike set-default latest

# List all versions
mike list
```

## 🧪 Testing

### Local Testing

```bash
# Serve documentation locally
mkdocs serve

# Build documentation
mkdocs build

# Test all versions
mike serve
```

### Quality Checks

The project uses several tools to maintain code quality:

- **Black**: Code formatting
- **isort**: Import sorting
- **flake8**: Linting
- **yamllint**: YAML file validation
- **pre-commit**: Automated checks on commit

## 📋 Pull Request Process

1. **Ensure your PR**:
   - Has a clear, descriptive title
   - Includes a detailed description of changes
   - References any related issues
   - Passes all quality checks
   - Includes screenshots for UI changes

2. **PR Review Process**:
   - All PRs require review from a maintainer
   - Address any feedback promptly
   - Ensure CI/CD checks pass
   - Squash commits if requested

3. **After Approval**:
   - PRs will be merged by maintainers
   - Documentation will be automatically deployed

## 🎯 Types of Contributions

### Lab Content
- New lab guides
- Updates to existing labs
- Interactive elements and automation
- Troubleshooting guides

### Documentation
- README improvements
- Contributing guidelines
- Reference materials
- API documentation

### Technical Improvements
- Build system enhancements
- CI/CD improvements
- Performance optimizations
- Accessibility improvements

### Bug Fixes
- Content corrections
- Broken links
- Image issues
- Formatting problems

## 📞 Getting Help

- **Issues**: Create a GitHub issue for bugs or feature requests
- **Discussions**: Use GitHub Discussions for questions
- **Email**: Contact maintainers directly for sensitive issues

## 📄 License

By contributing to this project, you agree that your contributions will be licensed under the same license as the project (Proprietary - Arista Networks).

## 🙏 Recognition

Contributors will be recognized in:
- The project README
- Release notes
- Documentation credits

Thank you for helping make the Arista Campus Workshop documentation better! 🚀
