# How to Submit the Pull Request

## Prerequisites

Ensure you have:
- ✅ Tested the application locally
- ✅ All changes committed to `new-app-version` branch
- ✅ `R CMD check` passes with no issues
- ✅ GitHub repository access with push permissions

## Steps to Submit PR

### 1. Push Your Branch to GitHub

```bash
# Make sure you're on the new-app-version branch
git checkout new-app-version

# Push the branch to GitHub
git push origin new-app-version
```

### 2. Create Pull Request on GitHub

1. Go to your repository on GitHub: https://github.com/rweekly/rweekly-highlights
2. You should see a yellow banner saying "new-app-version had recent pushes" with a **Compare & pull request** button
3. Click the **Compare & pull request** button

Alternatively:
1. Click the **Pull requests** tab
2. Click **New pull request**
3. Set base branch to `main` (or `master`)
4. Set compare branch to `new-app-version`
5. Click **Create pull request**

### 3. Fill in PR Details

**Title:**
```
Convert to golem framework with bslib UI and split output
```

**Description:**
Copy the content from `docs/PULL_REQUEST_TEMPLATE.md` into the PR description field.

### 4. Review and Submit

1. Review the **Files changed** tab to ensure all changes are correct
2. Check that no unintended files are included
3. Verify the commit history looks clean (17 commits)
4. Click **Create pull request**

### 5. Post-Submission

After creating the PR:
- Add appropriate labels (e.g., `enhancement`, `refactor`)
- Assign reviewers if needed
- Link any related issues
- Monitor for CI/CD checks if configured

## Important Files to Highlight in PR Review

Key files reviewers should focus on:
- `R/app_ui.R` - New bslib-based UI
- `R/app_server.R` - Main server logic with split output
- `R/mod_highlights.R` - New modular structure
- `R/run_app.R` - Updated launcher with improved duplicate checking
- `DESCRIPTION` - Updated dependencies
- `NEWS.md` - Comprehensive changelog

## Branch Information

- **Source Branch**: `new-app-version`
- **Target Branch**: `main` (or `master` - check your repository)
- **Total Commits**: 17
- **Files Changed**: ~20+

## Testing Instructions for Reviewers

Include these testing instructions in your PR:

```r
# Install from the PR branch
# remotes::install_github("rweekly/rweekly-highlights@new-app-version")

# Or clone and test locally
library(devtools)
load_all()

# Run the app
run_app()

# Run checks
check()
```

## Expected Outcome

Once merged:
- Application will use golem framework
- UI will be modernized with bslib
- Poll output will be split into two sections
- Package will be at version 0.1.0.0000
- All quality checks will pass

---

**Ready to Submit!** 🚀
