# rweekly.highlights

<!-- badges: start -->
[![Project Status: Active – The project has reached a stable, usable state and is being actively developed.](https://www.repostatus.org/badges/latest/active.svg)](https://www.repostatus.org/#active)
<!-- badges: end -->

The goal of rweekly.highlights is to create the Weekly Highlights Poll Slack Text for R Weekly editors.

## Version 0.1.0 - Major Update

This version represents a significant refactoring of the application:

- **golem framework**: The app now uses the [golem](https://thinkr-open.github.io/golem/) framework for production-grade Shiny applications
- **bslib UI**: Modern UI components using [bslib](https://rstudio.github.io/bslib/) instead of shinythemes
- **Split output**: Poll text is now split into two sections (5 items each) for easier management
- **Modular structure**: Code is organized into modules and functions following golem best practices

## Installation

You can install `rweekly.highlights` from GitHub with:

``` r
devtools::install_github("rweekly/rweekly.highlights",
                         dependencies = TRUE)
```

## Usage

### Basic Usage

The app started by `run_app()` lets you pick up to 10 links from the current R Weekly draft to be voted upon by R Weekly editors. 

```r
library(rweekly.highlights)
run_app()
```

The draft is fetched from:
1. A local `draft.md` file in your working directory (if present), or
2. The remote draft from the R Weekly GitHub repository

### Features

- **Checkbox interface**: Select up to 10 highlights from the current draft
- **Validation notifications**: Visual feedback when you have selected less than, exactly, or more than 10 items
- **Duplicate detection**: Automatically checks for duplicate links when running from a local draft
- **Split output**: The 10 selected items are split into two Slack poll commands:
  - **Section 1**: First 5 items
  - **Section 2**: Second 5 items

### Duplicate Checking

If you're working with a local draft, the app will check for duplicate links:

```r
# Run without duplicate checking
run_app(check_dups = FALSE)

# Run with duplicate checking (default)
run_app(check_dups = TRUE)
```

### Development Environment

This package uses [Nix](https://nixos.org/) for reproducible environments. The `default.nix` file contains all required R packages and system dependencies.

## Output Format

When you select 10 highlights, the app generates two Slack poll commands:

**Section 1 (First 5 items):**
```
/poll "Which of the following items in R Weekly 2026-W06 should be highlighted? (Part 1)" 
"Item 1 Title
URL 1" "Item 2 Title
URL 2" ... (5 items total)
```

**Section 2 (Second 5 items):**
```
/poll "Which of the following items in R Weekly 2026-W06 should be highlighted? (Part 2)" 
"Item 6 Title
URL 6" "Item 7 Title
URL 7" ... (5 items total)
```

Copy and paste each section into the '#highlights' Slack channel.

## Architecture

The application follows golem's modular structure:

- `R/app_ui.R` - Main UI using bslib components
- `R/app_server.R` - Main server logic
- `R/mod_highlights.R` - Highlights selection module
- `R/fct_parse_draft.R` - Draft parsing functions
- `R/fct_slack_format.R` - Slack poll formatting functions
- `R/dup.R` - Duplicate link detection utilities
- `inst/golem-config.yml` - Application configuration

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

MIT + file LICENSE
