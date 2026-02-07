#' highlights UI Function
#'
#' @description A shiny Module for selecting weekly highlights.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_highlights_ui <- function(id) {
  ns <- NS(id)
  tagList(
    uiOutput(ns("highlights_checklist_UI"))
  )
}

#' highlights Server Functions
#'
#' @param id Module id
#'
#' @return A list with reactive values: selected (indices), highlightList, issue
#' @noRd
mod_highlights_server <- function(id) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns
    
    # Fetch and parse draft
    draft <- fetch_draft()
    parsed_data <- parse_draft_highlights(draft)
    
    highlights <- parsed_data$highlights
    highlightList <- parsed_data$highlightList
    issue <- parsed_data$issue
    
    # Render checkbox group
    output$highlights_checklist_UI <- renderUI({
      checkboxGroupInput(
        ns("highlights_checklist"),
        label = h3("Check 10 most important topics to vote"),
        choiceNames = highlights[,2],
        choiceValues = 1:nrow(highlights),
        selected = NULL,
        width = "100%"
      )
    })
    
    # Observe selection changes and show notifications
    observeEvent(input$highlights_checklist, {
      n_selected <- length(input$highlights_checklist)
      
      if (n_selected < 10) {
        showNotification(
          "More items needed.",
          duration = NULL,
          closeButton = FALSE,
          id = "status",
          type = "warning"
        )
      } else if (n_selected == 10) {
        showNotification(
          "Ready!",
          duration = NULL,
          closeButton = FALSE,
          id = "status",
          type = "message"
        )
      } else {
        showNotification(
          "Too many items selected.",
          duration = NULL,
          closeButton = FALSE,
          id = "status",
          type = "error"
        )
      }
    })
    
    # Return reactive values
    list(
      selected = reactive(input$highlights_checklist),
      highlightList = highlightList,
      issue = issue
    )
  })
}
