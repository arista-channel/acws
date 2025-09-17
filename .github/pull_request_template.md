# Campus Workshop Documentation Update

## 📋 Summary
<!-- Brief description of the changes -->

## 🎯 Workshop Version
<!-- Which workshop version does this affect? -->
- [ ] 2025.2.NAS - Nashville Workshop
- [ ] 2025.3.TOR - Toronto Workshop
- [ ] 2025.4.ATL - Atlanta Workshop
- [ ] 2025.5.BAY - Bay Area Workshop
- [ ] Other: _______________

## 📝 Changes Made
<!-- Check all that apply -->
- [ ] Documentation content updates
- [ ] Lab assignment data changes
- [ ] Configuration file updates
- [ ] Asset/image updates
- [ ] Navigation/structure changes
- [ ] Bug fixes
- [ ] Other: _______________

## 🛡️ Orlando Protection Check
<!-- CRITICAL: Verify Orlando protection -->
- [ ] ✅ I confirm this PR does NOT modify Orlando 2025.1.ORL content
- [ ] ✅ I confirm this PR does NOT affect `data/orlando_lab_assignment.csv`
- [ ] ✅ I confirm this PR does NOT affect `docs/assets/images/topology/atd_student-light_orlando.png`
- [ ] ✅ I understand Orlando 2025.1.ORL is historically protected

## 🧪 Testing Checklist
<!-- Verify before submitting -->
- [ ] Local MkDocs build successful (`mkdocs build --strict`)
- [ ] Local Mike versioning tested (`mike deploy test-version "Test"`)
- [ ] No broken links or missing images
- [ ] CSV data format validated (if applicable)
- [ ] Interactive banner working (for non-Orlando versions)

## 📊 Data Changes
<!-- If you modified data files -->
- [ ] No data changes
- [ ] Updated `data/lab_assignment.csv` (Nashville/Toronto/Atlanta/Bay Area)
- [ ] Added new participant data
- [ ] Updated workshop dates/details
- [ ] Other data changes: _______________

## 🖼️ Asset Changes
<!-- If you modified images or other assets -->
- [ ] No asset changes
- [ ] Updated topology images
- [ ] Updated banner/logo images
- [ ] Added new screenshots
- [ ] Other asset changes: _______________

## 🌐 Deployment Plan
<!-- How should this be deployed? -->
- [ ] Automatic deployment on merge (recommended)
- [ ] Manual deployment required
- [ ] Deploy to specific version: _______________
- [ ] Set as default version after deployment

## 🔍 Review Notes
<!-- Additional context for reviewers -->

### Files Changed
<!-- List key files modified -->
-
-
-

### Testing Notes
<!-- How did you test these changes? -->
-
-
-

### Deployment Notes
<!-- Any special deployment considerations? -->
-
-
-

## 📋 Post-Merge Checklist
<!-- For reviewer/merger -->
- [ ] CI/CD pipeline passes
- [ ] GitHub Pages deployment successful
- [ ] Nginx server deployment successful (if applicable)
- [ ] Orlando 2025.1.ORL protection verified intact
- [ ] Site accessibility confirmed
- [ ] Version-specific content verified

## 🚨 Emergency Rollback Plan
<!-- If something goes wrong -->
- [ ] Revert commit available
- [ ] Server backup location known
- [ ] Rollback procedure documented
- [ ] Contact information available

---

### 🛡️ Orlando Protection Reminder
**CRITICAL**: Orlando 2025.1.ORL is historically protected and must never be modified. This version contains the original July 14-15, 2025 Orlando workshop data and must remain intact for historical accuracy.

### 📖 Documentation
- [CI/CD Pipeline Guide](../CI_CD_PIPELINE.md)
- [Quick Reference](../PIPELINE_QUICK_REFERENCE.md)
- [Setup Instructions](../setup-pipeline.sh)

### 🌐 URLs to Test After Deployment
- **GitHub Pages**: https://mbalagot12.github.io/campus-workshop/
- **Orlando (Protected)**: https://mbalagot12.github.io/campus-workshop/2025.1.ORL/
- **Nginx Server**: http://mb-acws1/
- **Version-specific**: https://mbalagot12.github.io/campus-workshop/[VERSION]/
