library(shiny)

shinyServer(function(input, output, session) {
  
  # Fetch draft
  draft <- httr::GET("https://raw.githubusercontent.com/rweekly/rweekly.org/gh-pages/draft.md") %>%
    httr::content("text")
  
  # Obtain Issue number
  issue <- (draft %>% stringr::str_match("title:\\s(.+)\\n"))[,2]
  
  # Obtain Items list
  highlights <- draft %>% 
    stringr::str_match_all("\\+\\s\\[([^\\]]+)\\]\\(([^\\)]+)\\)")
  
  highlightList <- paste0(highlights[[1]][,2], "\n", highlights[[1]][,3])
  
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
        '<code>/poll "Which of the following items in ', issue, 
        ' should be highlighted?" "', 
        paste0(
          highlightList[as.numeric(input$highlights_checklist)],
          collapse = '" "'),
        '"</code>'
      )
    )
  }

})

