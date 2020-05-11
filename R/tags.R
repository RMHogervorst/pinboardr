
#' Find all tags in use.
#'
#' @param username your username You probably don't need to supply this every time. See `?authentication`
#' @param token your token
#'
#' @return a dataframe with all tags and their count
#' @export
#'
#' @examples
#' \dontrun{
#' pb_get_all_tags()
#' }
pb_tags_get <- function(username = NULL, token = NULL) {
  list_of_tags <- retrieve_results(path = "tags/get", username = username, token = token)
  parse_1d_list_to_df(list_of_tags)
}



#' Delete an existing tag
#'
#' Notice that 'pinboard.in' does not tell you if a tag
#' exists or not. It will return a 'done' unless something else goes wrong.
#' @param tag [REQUIRED] tag the delete
#' @inheritParams pb_tags_get
#'
#' @return text confirmation
#' @export
#'
#' @examples
#' \dontrun{
#' pb_tags_delete(tag = "svg")
#' }
pb_tags_delete <- function(tag, username = NULL, token = NULL) {
  result <- retrieve_results(path = "tags/delete", arguments = paste0("tag=", tag), username = username, token = token)
  result$result
}

#' Rename a tag
#'
#' Change the name of a tag. Notice that 'pinboard.in' does not tell you if a tag
#' exists or not. It will return a 'done' unless something else goes wrong.
#' @param old [REQUIRED] old tag name
#' @param new [REQUIRED] new tag name, if empty nothing will happen
#' @inheritParams pb_tags_get
#' @return text confirmation
#' @export
#' @examples
#' \dontrun{
#' pb_tags_rename(old = "svg", new = "illustrations")
#' }
pb_tags_rename <- function(old, new = NULL, username = NULL, token = NULL) {
  result <- retrieve_results(path = "tags/rename", arguments = c(paste0("old=", old), paste0("new=", new)), username = username, token = token)
  result$result
}
