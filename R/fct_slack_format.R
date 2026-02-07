#' Format Slack Poll Text
#'
#' Generate Slack poll command text for selected highlights
#'
#' @param highlightList Character vector of formatted highlights
#' @param selected_indices Numeric vector of selected highlight indices
#' @param issue Character string with issue number
#' @param section Integer (1 or 2) indicating which section of the poll
#'
#' @return Character string with formatted Slack poll command
#' @noRd
format_slack_poll <- function(highlightList, selected_indices, issue, section = NULL) {
  if (is.null(selected_indices) || length(selected_indices) == 0) {
    return(NULL)
  }
  
  # Determine which items to include based on section
  if (!is.null(section)) {
    if (section == 1) {
      # First 5 items (indices 1-5)
      indices_to_use <- selected_indices[1:min(5, length(selected_indices))]
      section_text <- " (Part 1)"
    } else if (section == 2) {
      # Second 5 items (indices 6-10)
      if (length(selected_indices) > 5) {
        indices_to_use <- selected_indices[6:length(selected_indices)]
        section_text <- " (Part 2)"
      } else {
        # Not enough items for section 2
        return(NULL)
      }
    } else {
      indices_to_use <- selected_indices
      section_text <- ""
    }
  } else {
    indices_to_use <- selected_indices
    section_text <- ""
  }
  
  # Build the Slack poll command
  paste0(
    '/poll "Which of the following items in ', issue,
    ' should be highlighted?', section_text, '" "',
    paste0(
      highlightList[as.numeric(indices_to_use)],
      collapse = '" "'),
    '"'
  )
}
