#' Creates the Weekly Highlights Poll Slack Text.
#'
#' @details This app lets you pick up up to 10 links from the current
#'  R Weekly draft, to be voted upon by R Weekly editors.
#'   The app outputs the text to be pasted in the '#highlights'
#'   Slack channel.
#'
#' @param check_dups Logical. If TRUE, checks for duplicate links before launching the app.
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
  check_dups = TRUE,
  onStart = NULL,
  options = list(),
  enableBookmarking = NULL,
  uiPattern = "/",
  ...
) {
  # Check for duplicate links if requested
  cur_path <- file.path(getwd(), "draft.md")
  if (file.exists(cur_path) && check_dups) {
    dups <- get_dups()
    if (length(dups)) {
      warning('Found duplicate links')
      print(dups)
      invisible(return(NULL))
    }
  }
  
  with_golem_options(
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
