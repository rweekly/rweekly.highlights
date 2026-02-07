#' The application User-Interface
#'
#' @param request Internal parameter for `{shiny}`.
#'     DO NOT REMOVE.
#' @import shiny
#' @import bslib
#' @noRd
app_ui <- function(request) {
  tagList(
    # Leave this function for adding external resources
    golem_add_external_resources(),
    # Your application UI logic
    page_navbar(
      title = "Rweekly Highlights",
      theme = bs_theme(
        version = 5,
        bootswatch = "simplex"
      ),
      nav_panel(
        title = "Topics",
        icon = icon("rocket"),
        layout_columns(
          col_widths = c(6, 6),
          # Left column: Checkbox interface
          card(
            card_header("Select Highlights"),
            card_body(
              mod_highlights_ui("highlights_1")
            )
          ),
          # Right column: Output sections
          div(
            h4("Please copy and paste the following messages to our Slack channel"),
            p("(Please limit this list to 10 items as Simple Poll does not take more than 10 items.)"),
            card(
              card_header("Poll Section 1 (First 5 items)"),
              card_body(
                htmlOutput("vote_section1")
              )
            ),
            card(
              card_header("Poll Section 2 (Second 5 items)"),
              card_body(
                htmlOutput("vote_section2")
              )
            )
          )
        )
      )
    )
  )
}

#' Add external Resources to the Application
#'
#' This function is internally used to add external
#' resources inside the Shiny application.
#'
#' @import shiny
#' @importFrom golem add_resource_path activate_js favicon bundle_resources
#' @noRd
golem_add_external_resources <- function() {
  add_resource_path(
    "www",
    app_sys("app/www")
  )

  tags$head(
    favicon(),
    bundle_resources(
      path = app_sys("app/www"),
      app_title = "rweekly.highlights"
    )
    # Add here other external resources
    # for example, you can add shinyalert::useShinyalert()
  )
}
