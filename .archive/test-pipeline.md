# CI/CD Pipeline Test

This file is created to test the automated CI/CD pipeline.

## Test Information

- **Created**: October 24, 2025
- **Purpose**: Verify GitHub Actions workflow
- **Expected Result**: Automatic deployment to both GitHub Pages and nginx server

## Pipeline Flow

1. **Commit to main branch** → Triggers `deploy-docs.yml`
2. **Build and deploy to GitHub Pages** → Updates `gh-pages` branch
3. **gh-pages update** → Triggers `deploy-nginx.yml`
4. **Deploy to nginx server** → Updates `acws.duckdns.org`

## Success Criteria

- ✅ GitHub Pages shows updated content
- ✅ nginx server shows updated content
- ✅ Orlando 2025.1.ORL remains protected
- ✅ Atlanta 2025.4.ATL shows as latest version

---

**Note**: This file can be deleted after successful pipeline testing.
