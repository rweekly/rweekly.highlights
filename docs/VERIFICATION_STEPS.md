# Verification Steps

## Quick Test Commands

To verify the application works correctly, run these commands in R:

```r
# 1. Load the package
library(rweekly.highlights)

# 2. Make sure you have a draft.md file in your working directory
# (The example draft is in inst/example_draft/draft.md)
setwd("/mnt/nvme2/r_projects/rweekly.highlights")

# 3. Launch the app (no duplicate checking in dev mode)
run_app()
```

## What to Test in the App

### 1. UI Layout
- ✅ Left sidebar with checkboxes for highlights
- ✅ Right panel with two output sections (Section 1 and Section 2)
- ✅ Modern bslib theme (Simplex)
- ✅ Card-based layout with proper styling

### 2. Functionality
- ✅ Select various numbers of highlights (0, 5, 10, 15)
- ✅ Verify notification colors:
  - **Red warning**: Less than 10 items selected
  - **Green success**: Exactly 10 items selected
  - **Orange warning**: More than 10 items selected
- ✅ Check Section 1 displays first 5 selected items
- ✅ Check Section 2 displays second 5 selected items
- ✅ Copy buttons work for both sections

### 3. Edge Cases
- Select fewer than 5 items (Section 2 should be empty or show fewer items)
- Select exactly 5 items (Section 2 should be empty)
- Select between 5-10 items (Section 1 full, Section 2 partial)
- Select more than 10 items (both sections full, plus extras)

## Expected Output Format

When 10 items are selected, you should see:

**Section 1 Output:**
```
/poll "Which of the following items in R Weekly 2026-W06 should be highlighted? (Part 1)" 
"Item 1 Title
URL1" "Item 2 Title
URL2" ... (5 items)
```

**Section 2 Output:**
```
/poll "Which of the following items in R Weekly 2026-W06 should be highlighted? (Part 2)" 
"Item 6 Title
URL6" "Item 7 Title
URL7" ... (5 items)
```

## Development vs Production Mode

### Development Mode (Current)
- Run from package directory
- No duplicate checking by default
- Uses local draft.md if available
- Falls back to remote draft from GitHub

### Production Mode (rweekly.org repo)
- Run from rweekly.org repository
- Can enable duplicate checking with `run_app(check_dups = TRUE)`
- Requires _posts directory to be present
- Checks for duplicate links across recent issues

## Troubleshooting

### Issue: App doesn't show any highlights
- **Solution**: Ensure draft.md exists in working directory or app has internet access to fetch remote draft

### Issue: Duplicate checking fails
- **Solution**: This is expected in dev mode. Only works when running from rweekly.org repository with _posts directory

### Issue: Can't see changes after editing code
- **Solution**: Run `devtools::load_all()` to reload the package
