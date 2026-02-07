#' Creates the Weekly Highlights Poll Slack Text.
#'
#' @details This app lets you pick up up to 10 links from the current
#'  R Weekly draft, to be voted upon by R Weekly editors.
#'   The app outputs the text to be pasted in the '#highlights'
#'   Slack channel.
#'
#' @param check_dups Logical. If TRUE, checks for duplicate links before launching the app.
#'   Only works when running from the rweekly.org repository with _posts directory present.
#'   Defaults to FALSE for development mode.
#' @param ... arguments to pass to golem_opts.
#' See `?golem::get_golem_options` for more details.
#' @inheritParams shiny::shinyApp
#'
#' @import shiny
#'
#' @examples
#' \dontrun{
#' run_app()
#' }
#' @export
run_app <- function(
  check_dups = FALSE,
  onStart = NULL,
  options = list(),
  enableBookmarking = NULL,
  uiPattern = "/",
  ...
) {
  # Check for duplicate links if requested and if we're in the rweekly.org repo
  cur_path <- file.path(getwd(), "draft.md")
  posts_path <- file.path(getwd(), "_posts")
  
  if (check_dups && file.exists(cur_path) && dir.exists(posts_path)) {
    message("Checking for duplicate links...")
    dups <- get_dups()
    if (length(dups)) {
      warning('Found duplicate links')
      print(dups)
      invisible(return(NULL))
    }
  } else if (check_dups && !dir.exists(posts_path)) {
    message("Note: Duplicate checking requires running from rweekly.org repository with _posts directory.")
    message("Skipping duplicate check and launching app...")
  }
  
  golem::with_golem_options(
    app = shinyApp(
      ui = app_ui,
      server = app_server,
      onStart = onStart,
      options = options,
      enableBookmarking = enableBookmarking,
      uiPattern = uiPattern
    ),
    golem_opts = list(...)
  )
}
