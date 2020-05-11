#' Returns a data.frame of the user's notes
#'
#' Return a data.frame of notes meta information,
#' id, hash, title, length, created_at and updated_at.
#' When you know the id, you can use the other endpoint
#' pb_get_note
#' @return a data.frame with notes meta information
#' @inheritParams pb_tags_get
#' @export
pb_get_notes_overview <- function(username = NULL, token = NULL) {
  path <- "notes/list"
  result <- retrieve_results(path = path, username = username, token = token)
  result$notes
}


#' Get one specific note
#'
#' @param id the id of a note
#' @inheritParams pb_tags_get
#' @return a list containing id, title, created_at, updated_at, length, text and hash
#' @export
pb_get_note <- function(id = NULL, username = NULL, token = NULL) {
  if (is.null(id)) stop("need an id")
  path <- paste0("notes/", id)
  retrieve_results(path = path, username = username, token = token)
}
