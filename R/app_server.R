#' The application server-side
#'
#' @param input,output,session Internal parameters for {shiny}.
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_server <- function(input, output, session) {
  # Call highlights module
  highlights_data <- mod_highlights_server("highlights_1")
  
  # Generate Section 1 output (first 5 items)
  output$vote_section1 <- renderUI({
    selected <- highlights_data$selected()
    
    if (is.null(selected) || length(selected) == 0) {
      return(HTML(
        paste0(
          '<code>/poll "Which of the following items in ',
          highlights_data$issue,
          ' should be highlighted? (Part 1)" </code>'
        )
      ))
    }
    
    # Generate poll text for first 5 items
    slack_code <- format_slack_poll(
      highlights_data$highlightList,
      selected,
      highlights_data$issue,
      section = 1
    )
    
    n_section1 <- min(5, length(selected))
    
    HTML(
      paste0(
        '<p>', n_section1, ' items in section 1.</p>',
        '<code>', slack_code, '</code>'
      )
    )
  })
  
  # Generate Section 2 output (second 5 items)
  output$vote_section2 <- renderUI({
    selected <- highlights_data$selected()
    
    if (is.null(selected) || length(selected) <= 5) {
      return(HTML(
        paste0(
          '<code>/poll "Which of the following items in ',
          highlights_data$issue,
          ' should be highlighted? (Part 2)" </code>'
        )
      ))
    }
    
    # Generate poll text for second 5 items
    slack_code <- format_slack_poll(
      highlights_data$highlightList,
      selected,
      highlights_data$issue,
      section = 2
    )
    
    n_section2 <- length(selected) - 5
    
    HTML(
      paste0(
        '<p>', n_section2, ' items in section 2.</p>',
        '<code>', slack_code, '</code>'
      )
    )
  })
}
