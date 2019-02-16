#' Creates the Weekly Highlights Poll Slack Text.
#'
#' @details This app lets you pick up up to 10 links from the current
#'  R Weekly draft, to be voted upon by R Weekly editors.
#'   The app outputs the text to be pasted in the '#highlights' 
#'   Slack channel.
#'
#' @examples
#' \dontrun{
#' run_app()
#' }
#' @export
run__app <- function() {
  if (!requireNamespace("shiny", quietly = TRUE)) {
    message("run_shiny_app needs the shiny package, \n
              Install it via install.packages('shiny')")
    return(NULL)
  }
  
  if (!requireNamespace("httr", quietly = TRUE)) {
    message("run_shiny_app needs the httr package, \n
              Install it via install.packages('httr')")
    return(NULL)
  }
  
  if (!requireNamespace("stringr", quietly = TRUE)) {
    message("run_shiny_app needs the stringr package, \n
              Install it via install.packages('stringr')")
    return(NULL)
  }
  # nocov start
  app_dir <- system.file("shiny-examples",
                         "myapp", package = "rtimicropem")
  if (app_dir == "") {
    stop("Could not find example directory. Try re-installing `micropem`.",
         call. = FALSE)
  }
  
  shiny::runApp(app_dir, display.mode = "normal")
}
# nocov end
