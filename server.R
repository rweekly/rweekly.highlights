library(shiny)

shinyServer(function(input, output, session) {
  
  library(httr)
  library(stringr)
  
  # Fetch draft
  draft <- GET("https://raw.githubusercontent.com/rweekly/rweekly.org/gh-pages/draft.md") %>%
    content("text")
  
  # Obtain Issue number
  issue <- (draft %>% str_match("title:\\s([^\\r]+)\\r"))[,2]
  
  # Obtaint Items list
  highlights <- draft %>%
    str_match_all("\\+\\s\\[([^\\]]+)\\]")
  highlights <- highlights[[1]][,2]
  
  output$highlights_checklist_UI <- renderUI({
    checkboxGroupInput("highlights_checklist", 
                       label = h3("Check 10 most important topics to vote"), 
                       choices = highlights,
                       selected = NULL,
                       width = "800px")
  })
  
  output$vote <- function(){
    if(is.null(input$highlights_checklist)){
      return(HTML(
        paste0(
          '<code>/poll "Which of the following items in ', issue, 
          ' should be highlighted?" </code>'
        )
      ))
    }
    HTML(
      paste0(
        '<code>/poll "Which of the following items in ', issue, 
        ' should be highlighted?" "', 
        paste0(input$highlights_checklist, collapse = '" "'), '"</code>'
      )
    )
  }
  
  
})
