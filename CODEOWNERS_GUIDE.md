# CODEOWNERS Guide

## Overview

The CODEOWNERS file automatically assigns reviewers to pull requests based on the files being changed. This ensures that the right people review changes to specific parts of the repository.

## 🔒 Branch Protection Status

The `main` branch is now protected with the following rules:

✅ **Pull Request Reviews Required**
- At least 1 approval required before merging
- Code owner reviews are **required**
- Stale reviews are dismissed when new commits are pushed
- All conversations must be resolved before merging

✅ **Direct Push Prevention**
- No direct pushes to `main` allowed
- All changes must go through pull requests
- No force pushes allowed
- No branch deletion allowed

## 👥 Code Ownership Structure

### Default Owners
All files default to: **@mbalagot12** and **@RyanM-Arista**

### Documentation Content

| Directory | Owners | Purpose |
|-----------|--------|---------|
| `/docs/a_wired/` | @mbalagot12 @drew-arista | Wired Solutions Lab Guides |
| `/docs/b_wireless/` | @mbalagot12 @brandonmainock | Wireless Edge Lab Guides |
| `/docs/c_security/` | @mbalagot12 @RyanM-Arista | Security Lab Guides |
| `/docs/d_sdwan/` | @mbalagot12 @RyanM-Arista | SD-WAN Lab Guides |
| `/docs/e_vantage/` | @mbalagot12 @Arista-Laban | Vantage Professional Services |
| `/docs/assets/` | @mbalagot12 | Images, videos, and other assets |
| `/docs/index.md` | @mbalagot12 @RyanM-Arista | Landing page |

### Configuration & Infrastructure

| File/Directory | Owners | Purpose |
|----------------|--------|---------|
| `mkdocs.yml` | @mbalagot12 @RyanM-Arista | MkDocs configuration |
| `/.github/workflows/` | @mbalagot12 @RyanM-Arista | GitHub Actions CI/CD |
| `/scripts/` | @mbalagot12 | Deployment and automation scripts |
| `/automation/` | @mbalagot12 | Lab automation scripts |
| `/data/` | @mbalagot12 | Lab assignment data |
| `requirements.txt` | @mbalagot12 | Python dependencies |
| `CONTRIBUTING.md` | @mbalagot12 @RyanM-Arista | Contributing guidelines |

## 🔄 Workflow for Making Changes

### 1. Create a Feature Branch

```bash
git checkout -b feature/your-feature-name
```

### 2. Make Your Changes

Edit files, add content, update documentation, etc.

### 3. Commit Your Changes

```bash
git add .
git commit -m "feat: description of your changes"
```

### 4. Push to GitHub

```bash
git push origin feature/your-feature-name
```

### 5. Create a Pull Request

```bash
gh pr create --title "Your PR Title" --body "Description of changes"
```

**OR** visit: https://github.com/arista-channel/acws/compare

### 6. Automatic Reviewer Assignment

GitHub will automatically:
- ✅ Assign reviewers based on CODEOWNERS file
- ✅ Request reviews from appropriate code owners
- ✅ Notify assigned reviewers

### 7. Review Process

- Wait for code owner approval
- Address any feedback or requested changes
- Resolve all conversations
- Ensure all checks pass

### 8. Merge

Once approved by a code owner:
- Click "Merge pull request" on GitHub
- Or use: `gh pr merge <PR-number> --squash`

## 📝 Example Scenarios

### Scenario 1: Updating Wireless Lab Guide

**Files changed**: `/docs/b_wireless/b01_lab.md`

**Automatic reviewers**: @mbalagot12 @brandonmainock

### Scenario 2: Updating GitHub Actions Workflow

**Files changed**: `/.github/workflows/deploy.yml`

**Automatic reviewers**: @mbalagot12 @RyanM-Arista

### Scenario 3: Adding Vantage Lab Content

**Files changed**: `/docs/e_vantage/e02_lab.md`

**Automatic reviewers**: @mbalagot12 @Arista-Laban

### Scenario 4: Updating Multiple Sections

**Files changed**:
- `/docs/a_wired/a01_lab.md`
- `/docs/b_wireless/b01_lab.md`
- `mkdocs.yml`

**Automatic reviewers**: 
- @mbalagot12 (all files)
- @drew-arista (wired)
- @brandonmainock (wireless)
- @RyanM-Arista (mkdocs.yml)

## 🛠️ Modifying CODEOWNERS

To update code ownership:

1. Edit `.github/CODEOWNERS`
2. Follow the syntax: `<file-pattern> <owner1> <owner2>`
3. Create a pull request with the changes
4. Get approval from @mbalagot12 (owner of CODEOWNERS file)

## 🚨 Emergency Changes

If you need to make urgent changes:

1. **Repository admins** can bypass branch protection (currently disabled)
2. Contact @mbalagot12 or @RyanM-Arista for emergency merges
3. Create a hotfix branch and expedite the review process

## 📚 Additional Resources

- [GitHub CODEOWNERS Documentation](https://docs.github.com/en/repositories/managing-your-repositorys-settings-and-features/customizing-your-repository/about-code-owners)
- [Branch Protection Rules](https://github.com/arista-channel/acws/settings/branches)
- [Pull Request Best Practices](CONTRIBUTING.md)

## ✅ Benefits

✅ **Automatic reviewer assignment** - No manual assignment needed
✅ **Expertise-based reviews** - Right people review relevant changes
✅ **Quality assurance** - Ensures proper oversight of all changes
✅ **Prevents inadvertent updates** - Main branch is protected
✅ **Clear ownership** - Everyone knows who owns what
✅ **Faster reviews** - Reviewers are notified immediately

---

**Questions?** Contact @mbalagot12 or @RyanM-Arista

