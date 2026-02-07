# Convert to golem framework with bslib UI and split output

## Summary

This PR converts the rweekly.highlights Shiny application to use the **golem framework** for better maintainability and production readiness, replaces the UI with **bslib** for modern Bootstrap 5 components, and implements a **split output feature** that divides the poll text into two sections.

## Changes

### Major Features

- **Golem Framework Integration**: Converted the application to use golem's production-grade structure with proper configuration, modularization, and best practices
- **bslib UI**: Replaced `shinythemes` with `bslib` for modern, themeable Bootstrap 5 components
- **Split Output**: Poll text is now divided into two sections (Part 1 and Part 2), each displaying 5 selections instead of all 10 in one output
- **Improved Duplicate Checking**: Now works gracefully in both development mode (without `_posts/` directory) and production mode

### Technical Improvements

- **Modular Architecture**: Extracted UI and server logic into separate files (`app_ui.R`, `app_server.R`)
- **Shiny Modules**: Created reusable `mod_highlights` module for the highlights selection interface
- **Business Logic Separation**: Moved parsing and formatting logic to dedicated `fct_*.R` files
- **Configuration**: Added `inst/golem-config.yml` for environment-specific settings
- **Code Quality**: Package now passes `R CMD check` with 0 errors, 0 warnings, 0 notes ✅

### UI Changes

- Modern card-based layout using `bslib::card()`
- Two separate output sections with individual copy buttons
- Consistent Simplex theme (preserved from original)
- Responsive sidebar layout maintained

### File Structure

```
R/
├── app_config.R          # golem configuration helpers
├── app_server.R          # Main server logic
├── app_ui.R              # Main UI with bslib
├── mod_highlights.R      # Highlights selection module
├── fct_parse_draft.R     # Draft parsing functions
├── fct_slack_format.R    # Slack formatting functions
├── run_app.R             # Updated app launcher
└── dup.R                 # Duplicate checking (unchanged)

inst/
├── golem-config.yml      # App configuration
└── example_draft/        # Example draft for testing
    └── draft.md
```

## Breaking Changes

**None** - The application maintains backward compatibility:
- Same command to run: `run_app()`
- Same duplicate checking functionality (improved handling)
- Same UI layout and workflow
- Same output format (now split into two parts)

## Testing

- ✅ Package loads successfully with `devtools::load_all()`
- ✅ All core functions tested and working
- ✅ Application launches without errors
- ✅ Draft parsing working correctly (60 highlights from example)
- ✅ Both output sections generate valid Slack poll commands
- ✅ `R CMD check` passes with 0 errors, 0 warnings, 0 notes
- ✅ Duplicate checking works in both dev and production modes

## Screenshots

The application now features:
- Left sidebar with checkbox interface (preserved from original)
- Two output sections in the main panel
- Modern bslib card components
- Individual copy buttons for each section

## Documentation

Updated documentation includes:
- `README.md` - Updated with new features and usage
- `NEWS.md` - Comprehensive changelog for version 0.1.0.0000
- `docs/` directory - Contains detailed conversion documentation
  - `CONVERSION_SUMMARY.md` - Complete project overview
  - `R_CMD_CHECK_FIXES.md` - Documentation of quality checks
  - `FINAL_SUMMARY.md` - Comprehensive summary

## Dependencies

**Added:**
- `golem` - Framework for production-grade Shiny apps
- `bslib` - Modern UI components and theming
- `config` - Configuration management

**Moved to Suggests:**
- `shinythemes` - No longer required but kept for reference

## Version

- Previous: 0.0.0.9001
- New: **0.1.0.0000**

## Checklist

- [x] Code follows the project's style guidelines
- [x] All tests pass locally
- [x] `R CMD check` passes with no errors, warnings, or notes
- [x] Documentation has been updated
- [x] NEWS.md has been updated with changes
- [x] Git history is clean and well-organized (17 commits)
- [x] No breaking changes to public API

## Additional Notes

This conversion maintains all existing functionality while providing a more maintainable and extensible codebase. The golem framework will make future enhancements easier and the modular structure improves code organization significantly.

The split output feature addresses the need to divide selections into two parts, making it easier to manage and share the poll results in Slack.

---

**Ready for Review** ✅
