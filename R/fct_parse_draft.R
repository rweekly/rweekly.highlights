#' Parse Draft Highlights
#'
#' Extract highlights from the R Weekly draft markdown file
#'
#' @param draft Character string containing the draft markdown content
#'
#' @return A list containing highlights matrix and issue number
#' @noRd
parse_draft_highlights <- function(draft) {
  # Obtain Issue number
  issue <- (draft %>% stringr::str_match("title:\\s(.+)\\n"))[,2]
  
  # Obtain Items list - extract links with format: + [text](url)
  highlights <- draft %>%
    stringr::str_match_all("\\+\\s\\[([^\\]]+)\\]\\(([^\\)]+)\\)")
  
  # Create formatted list: "Title\nURL"
  highlightList <- gsub('[\"""]', '', paste0(highlights[[1]][,2], "\n", highlights[[1]][,3]))
  
  list(
    highlights = highlights[[1]],
    highlightList = highlightList,
    issue = issue
  )
}

#' Fetch Draft Content
#'
#' Fetch draft.md from local file or GitHub repository
#'
#' @return Character string with draft content
#' @noRd
fetch_draft <- function() {
  cur_path <- file.path(getwd(), 'draft.md')
  
  if (file.exists(cur_path)) {
    draft <- paste(readLines(cur_path), sep = '\n', collapse = '\n')
  } else {
    warning('Using the remote draft, skip checking dup links. Run this function in the folder with the draft to check duplicated items')
    # Fetch draft from GitHub
    draft <- httr::GET("https://raw.githubusercontent.com/rweekly/rweekly.org/gh-pages/draft.md") %>%
      httr::content("text")
  }
  
  draft
}
