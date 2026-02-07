#' Creates the Weekly Highlights Poll Slack Text.
#'
#' @details This app lets you pick up up to 10 links from the current
#'  R Weekly draft, to be voted upon by R Weekly editors.
#'   The app outputs the text to be pasted in the '#highlights'
#'   Slack channel.
#'
#' @import shiny
#'
#' @examples
#' \dontrun{
#' run_app()
#' }
#' @export
run_app <- function(check_dups = TRUE) {
  if (!requireNamespace("shiny", quietly = TRUE)) {
    message("run_app needs the shiny package, \n
              Install it via install.packages('shiny')")
    return(NULL)
  }

  if (!requireNamespace("httr", quietly = TRUE)) {
    message("run_app needs the httr package, \n
              Install it via install.packages('httr')")
    return(NULL)
  }

  if (!requireNamespace("stringr", quietly = TRUE)) {
    message("run_app needs the stringr package, \n
              Install it via install.packages('stringr')")
    return(NULL)
  }
  cur_path <- file.path(getwd(), "draft.md")
  if (file.exists(cur_path) & check_dups) {
    dups <- get_dups()
    if (length(dups)) {
      warning('find dups')
      print(dups)
      invisible(return(NULL))
    }
  }

  shiny::shinyApp(ui = highlight_ui, server = highlight_server)
}

highlight_ui <- navbarPage(
  "Rweekly Highlights",
  theme = shinythemes::shinytheme("simplex"),
  position = "static-top",
  fluid = F,
  windowTitle = "Discover RStudio Addins",

  tabPanel(
    "Topics", class = "active", icon = icon("rocket"),
    fluidRow(
      column(6, wellPanel(uiOutput("highlights_checklist_UI"))),
      column(6,
             h4("Please copy and paste the following message to ",
                "our Slack channel"),
             p("(Please limit this list to 10 items as `Simple Poll` ",
               "does not take more than 10 items.)"),
             # disable for linux server
             # actionButton("copy", "Copy to Clipboard", icon = icon("clipboard")),
             htmlOutput("vote")
      )
    )
  )
)


highlight_server <- function(input, output, session) {
  cur_path <- file.path(getwd(), 'draft.md')
  if (file.exists(cur_path)) {
    draft <- paste(readLines(cur_path), sep = '\n', collapse = '\n')
  } else {
    warning('using the remote draft, skip checking dup links. Run this function in the folder with the draft to check duplicated items')
    # Fetch draft
    draft <- httr::GET("https://raw.githubusercontent.com/rweekly/rweekly.org/gh-pages/draft.md") %>%
      httr::content("text")
  }

  # Obtain Issue number
  issue <- (draft %>% stringr::str_match("title:\\s(.+)\\n"))[,2]

  # Obtain Items list
  highlights <- draft %>%
    stringr::str_match_all("\\+\\s\\[([^\\]]+)\\]\\(([^\\)]+)\\)")

  highlightList <- gsub('["“”]', '', paste0(highlights[[1]][,2], "\n", highlights[[1]][,3]))

  observeEvent(input$highlights_checklist, {

    if (length(input$highlights_checklist) < 10) {
      showNotification("More items needed.",
                       duration = NULL,
                       closeButton = FALSE,
                       id = "status",
                       type = "warning")
    } else if (length(input$highlights_checklist) == 10) {
      showNotification("Ready!",
                       duration = NULL,
                       closeButton = FALSE,
                       id = "status",
                       type = "message")
    } else {
      showNotification("Too many items selected.",
                       duration = NULL,
                       closeButton = FALSE,
                       id = "status",
                       type = "error")
    }

  })

  output$highlights_checklist_UI <- renderUI({
    checkboxGroupInput("highlights_checklist",
                       label = h3("Check 10 most important topics to vote"),
                       choiceNames = highlights[[1]][,2],
                       choiceValues = 1:length(highlights[[1]][,2]),
                       selected = NULL,
                       width = "800px")
  })

  slack_code <- reactive({
    paste0(
      '/poll "Which of the following items in ', issue,
      ' should be highlighted?" "',
      paste0(
        highlightList[as.numeric(input$highlights_checklist)],
        collapse = '" "'),
      '"'
    )
  })

  output$vote <- function(){
    if (is.null(input$highlights_checklist)) {
      return(HTML(
        paste0(
          '<code>/poll "Which of the following items in ', issue,
          ' should be highlighted?" </code>'
        )
      ))
    }
    HTML(
      paste0(
        '<p>', length(input$highlights_checklist), ' selected.</p>',
        '<code>', slack_code(), '</code>'
      )
    )
  }

  observeEvent(input$copy, {
    clipr::write_clip(slack_code(), allow_non_interactive = TRUE)
    updateActionButton(session, "copy", label = "Copied")
  })

  observeEvent(input$highlights_checklist, {
    updateActionButton(session, "copy", label = "Copy to Clipboard")
  })


}
