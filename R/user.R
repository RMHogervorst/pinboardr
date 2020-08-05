#' Returns the user's secret RSS key (for viewing private feeds)
#'
#' Get your secret RSS key for private feeds.
#' @inheritParams pb_tags_get
#' @return the secret RSS key
#' @export
#' @examples
#' \dontrun{
#' pb_user_secret()
#' }
pb_user_secret <- function(username = NULL, token = NULL) {
  path <- "user/secret"
  result <- retrieve_results(path = path, username = username, token = token)
  result$result
}


#' Get your api token
#'
#' This is a silly endpoint and function, but I implemented it
#' anyways. To reach this endpoint, you already are in possession of your
#' token. And I will not implement a username and password authentication
#' because that is inherently unsafe in this API. Be safe people!
#' @return token in string format
#' @inheritParams pb_tags_get
#' @export
#' @examples
#' \dontrun{
#' pb_user_api_token()
#' }
pb_user_api_token <- function(username = NULL, token = NULL) {
  path <- "user/api_token/"
  result <- retrieve_results(path = path, username = username, token = token)
  result$result
}
