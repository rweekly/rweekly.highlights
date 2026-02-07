# rweekly.highlights 0.1.0.0000

## Major Changes

* Converted application to use the golem framework for better maintainability and production readiness
* Replaced shinythemes with bslib for modern Bootstrap 5 UI components
* Split poll output into two sections (Part 1 and Part 2), each displaying 5 selections
* Improved duplicate checking to work gracefully in both development and production modes

## New Features

* Added modular Shiny module structure for highlights selection
* Implemented two-section output with separate copy buttons for each part
* Added robust error handling for missing _posts directory in development mode
* Updated UI with bslib cards and modern layout components

## Bug Fixes

* Fixed duplicate checking to skip gracefully when _posts directory is not present
* Changed default `check_dups` parameter to FALSE for development mode

## Internal Changes

* Reorganized code into golem structure with app_ui.R, app_server.R, and modules
* Extracted business logic into separate function files (fct_*.R)
* Added golem configuration support via inst/golem-config.yml
* Updated package dependencies (added golem, bslib, config)

# rweekly.highlights 0.0.0.9001

* Update acceptable duplicate links to match script in RWeekly GitHub repository script
* Add toggle for running duplicate checks in `run_app()`, in case duplicate checks have been performed already by another process.