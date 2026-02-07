# Plan: Convert rweekly.highlights to golem Framework

## Project Overview
Convert the existing rweekly.highlights Shiny application to use the golem framework while maintaining core functionality and updating the UI to use bslib instead of shinythemes. The key change is splitting the poll text output into two sections (first 5 selections and second 5 selections).

## Current Application Analysis

### Existing Structure
- **Package**: Standard R package structure with DESCRIPTION, NAMESPACE, R/ directory
- **Main function**: `run_app()` in `R/run_app.R`
- **UI**: Uses `shinythemes::shinytheme("simplex")` with `navbarPage`
- **Server logic**: 
  - Fetches draft.md from local file or GitHub
  - Parses markdown to extract highlight links
  - Displays checkbox interface for 10 selections
  - Outputs single Slack poll text with all 10 selections
- **Utilities**: `R/dup.R` for duplicate link detection, `R/utils-pipe.R` for pipe operator
- **Dependencies**: magrittr, shinythemes, stringr, httr, clipr, shiny, xml2, commonmark, fs, purrr

### Key Features to Preserve
1. Checkbox interface for selecting highlights
2. Parsing of draft.md (local or remote)
3. Duplicate link detection (`get_dups()` function)
4. Notification system for selection count (< 10, == 10, > 10)
5. Issue number extraction from draft.md

## Planned Changes

### 1. Framework Migration: Standard Package → golem
- **Initialize golem structure** using `golem::create_golem()` approach
- **Reorganize files** according to golem conventions:
  - `R/app_config.R` - Application configuration
  - `R/app_server.R` - Server logic
  - `R/app_ui.R` - UI definition
  - `R/run_app.R` - Application launcher (modified)
  - `R/mod_highlights.R` - Highlights selection module
  - `dev/` directory for development scripts (optional, may skip for simplicity)

### 2. UI Framework: shinythemes → bslib
- Replace `shinythemes::shinytheme("simplex")` with `bslib::bs_theme()`
- Replace `navbarPage` with `bslib::page_navbar()` or similar bslib layout
- Use `bslib::card()` or `bslib::card_body()` for content containers
- Maintain left-right column layout (checkbox list | output sections)
- Apply modern bslib styling consistent with simplex theme aesthetics

### 3. Output Splitting: Single Output → Two Sections
**Current behavior**: 
- One `htmlOutput("vote")` displays all 10 selections in single Slack poll text

**New behavior**:
- Split selections into two groups:
  - **Section 1**: First 5 selections (items 1-5)
  - **Section 2**: Second 5 selections (items 6-10)
- Each section gets its own Slack poll format text
- Update UI to display two separate output areas
- Each output should show poll command with 5 items

### 4. File Structure Changes

#### New/Modified Files
```
R/
├── app_config.R          [NEW] - golem configuration
├── app_server.R          [NEW] - main server function
├── app_ui.R              [NEW] - main UI function
├── mod_highlights.R      [NEW] - highlights selection module (UI + server)
├── run_app.R             [MODIFY] - adapt for golem
├── dup.R                 [KEEP] - duplicate detection utilities
├── utils-pipe.R          [KEEP] - pipe operator
└── fct_*.R               [NEW if needed] - business logic functions

inst/
├── app/www/              [NEW] - static resources (if needed)
└── example_draft/        [KEEP] - example draft.md
    └── draft.md

golem-config.yml          [NEW] - golem configuration file
```

### 5. Detailed Implementation Steps

#### Step 1: Setup golem infrastructure
1. Create `golem-config.yml` configuration file
2. Create `R/app_config.R` with golem configuration functions
3. Create `inst/app/www/` directory for static resources

#### Step 2: Modularize UI
1. Create `R/app_ui.R`:
   - Define main UI using bslib components
   - Replace navbarPage with bslib::page_navbar()
   - Use bslib::card() for content sections
   - Create two output areas for split poll text
   - Apply custom bslib theme similar to simplex

2. Create `R/mod_highlights.R`:
   - UI function: `mod_highlights_ui()`
     - Checkbox group input for highlight selection
   - Server function: `mod_highlights_server()`
     - Draft fetching and parsing logic
     - Selection validation (notifications)
     - Return reactive values for selected highlights

#### Step 3: Modularize Server
1. Create `R/app_server.R`:
   - Main server function
   - Call highlight module
   - Handle split output generation:
     - `output$vote_section1` - first 5 items
     - `output$vote_section2` - second 5 items
   - Format Slack poll text for each section

#### Step 4: Update run_app()
1. Modify `R/run_app.R`:
   - Integrate golem's app structure
   - Use `golem::with_golem_options()`
   - Keep `check_dups` parameter functionality
   - Call dup checking before app launch
   - Launch app with `shiny::shinyApp(ui = app_ui, server = app_server)`

#### Step 5: Extract business logic (if needed)
1. Create `R/fct_parse_draft.R`:
   - `parse_draft_highlights()` - extract highlights from markdown
   - `extract_issue_number()` - extract issue number
2. Create `R/fct_slack_format.R`:
   - `format_slack_poll()` - generate Slack poll text
   - Split into two variants if needed

#### Step 6: Update DESCRIPTION
1. Add golem to Imports
2. Add bslib to Imports
3. Remove shinythemes from Imports (or move to Suggests)
4. Update version number to indicate major refactor
5. Update RoxygenNote if needed

#### Step 7: Testing & Validation
1. Test with example draft.md in `inst/example_draft/`
2. Verify duplicate detection still works
3. Confirm split output displays correctly
4. Test selection validation (< 10, == 10, > 10 notifications)
5. Verify both local and remote draft.md fetching

#### Step 8: Git commits
1. Commit golem infrastructure setup
2. Commit UI migration to bslib
3. Commit module creation
4. Commit output splitting logic
5. Commit DESCRIPTION updates
6. Final commit with updated documentation

## Technical Specifications

### Output Format Specification
**Current format** (single output):
```
/poll "Which of the following items in R Weekly 2026-W06 should be highlighted?" 
"Item 1 Title
URL 1" "Item 2 Title
URL 2" ... "Item 10 Title
URL 10"
```

**New format** (two outputs):

**Section 1 (items 1-5)**:
```
/poll "Which of the following items in R Weekly 2026-W06 should be highlighted? (Part 1)" 
"Item 1 Title
URL 1" "Item 2 Title
URL 2" ... "Item 5 Title
URL 5"
```

**Section 2 (items 6-10)**:
```
/poll "Which of the following items in R Weekly 2026-W06 should be highlighted? (Part 2)" 
"Item 6 Title
URL 6" "Item 7 Title
URL 7" ... "Item 10 Title
URL 10"
```

### UI Layout Structure
```
Page (bslib::page_navbar)
├── Navigation: "Rweekly Highlights"
└── Tab: "Topics"
    ├── Row
    │   ├── Column (6) - Left side
    │   │   └── Card: Checkbox interface (up to 10 selections)
    │   └── Column (6) - Right side
    │       ├── Instructions header
    │       ├── Card: Section 1 output (first 5 items)
    │       └── Card: Section 2 output (second 5 items)
```

### Module Communication
- **Input**: User checkbox selections (1-10 items)
- **Processing**: 
  - Parse draft.md
  - Extract highlights
  - Track selections
  - Validate count
- **Output**: 
  - Two reactive values for split poll text
  - Selection count notification

## Dependencies Management

### Packages to Add
- golem (already in default.nix)
- bslib (already in default.nix)

### Packages to Keep
- shiny, stringr, httr, xml2, commonmark, fs, purrr, magrittr, clipr

### Packages to Remove/Deprecate
- shinythemes (replaced by bslib)

## Risk Mitigation

### Potential Issues
1. **golem complexity**: Keep structure simple, avoid over-engineering
2. **bslib layout differences**: Test thoroughly to ensure similar UX
3. **Output splitting logic**: Carefully handle edge cases (< 10 selections)
4. **Backwards compatibility**: run_app() signature should remain similar

### Testing Checklist
- [ ] App launches successfully
- [ ] Draft.md parsing works (local and remote)
- [ ] Duplicate detection functions correctly
- [ ] Checkbox interface displays all highlights
- [ ] Selection count notifications work (< 10, == 10, > 10)
- [ ] Output splits correctly into two sections
- [ ] Slack poll format is correct for both sections
- [ ] UI is responsive and visually appealing
- [ ] Package can be loaded and `run_app()` called

## Success Criteria
1. Application runs using golem framework
2. UI uses bslib instead of shinythemes
3. Similar visual appearance to original
4. Checkbox interface on left side (preserved)
5. Two separate output sections on right side (new feature)
6. Each section shows proper Slack poll format
7. All existing functionality preserved (dup detection, notifications, etc.)
8. All changes committed to Git
9. Package passes R CMD check (optional but recommended)
10. Documentation updated to reflect new structure

## Timeline Estimate
- Setup golem infrastructure: 15 minutes
- Create UI with bslib: 20 minutes  
- Create module: 25 minutes
- Implement output splitting: 20 minutes
- Update run_app(): 10 minutes
- Testing and debugging: 30 minutes
- Documentation and Git commits: 15 minutes
- **Total**: ~2.5 hours

## Notes
- Nix environment already configured with all required packages
- No additional package installation needed
- Focus on clean, maintainable code following golem best practices
- Keep module structure simple but extensible
- Maintain backward compatibility where possible
