
url_p <- "https://api.pinboard.in/"
version <- "v1/"

#' see https://pinboard.in/settings/password
#' @noRd
pb_auth <- function(username = NULL, token = NULL) {
  # search for pb_username and pb_token if null
  pb_username <- if_null_search_env_var(username, "PB_USERNAME")
  pb_token <- if_null_search_env_var(token, "PB_TOKEN")
  auth_token <- paste0(pb_username, ":", pb_token)
  auth_token
}

build_args <- function(arguments = NULL) {
  ifelse(is.null(arguments), "", paste0("&", arguments, collapse = ""))
}


build_url <- function(path, arguments = NULL, username = NULL, token = NULL) {
  start <- paste(url_p, version, collapse = "/", sep = "")
  auth <- paste0("?auth_token=", pb_auth(username, token))
  format <- "&format=json"
  args <- build_args(arguments)
  result <- paste0(start, path, auth, format, args)
  result
}

if_null_search_env_var <- function(arg = NULL, varname) {
  if (is.null(arg)) {
    result <- Sys.getenv(x = varname)
    if (result == "") {
      warning(paste0("Could not find env var ", varname))
    }
  } else {
    result <- arg
  }
  result
}

retrieve_results <- function(path, arguments = NULL, username = NULL, token = NULL, simplifyDataFrame = TRUE) {
  result <- httr::GET(url = build_url(path = path, arguments = arguments, username = username, token = token), httr::user_agent("pinboardr"))
  httr::stop_for_status(result)
  json <- httr::content(result)
  jsonlite::fromJSON(json, simplifyDataFrame = simplifyDataFrame)
}
