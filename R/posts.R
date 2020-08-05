#' Add a bookmark
#'
#' You must give a url and description, all other arguments are optional.
#'
#' @param url **REQUIRED** the URL of the item
#' @param title **REQUIRED** Title of the item.
#' @param description Description of the item
#' @param tags vector of up to 100 tags
#' @param dt	creation time for this bookmark. Defaults to current time. Datestamps more than 10 minutes ahead of server time will be reset to current server time (UTC timestamp in this format: 2010-12-11T19:48:02Z)
#' @param replace Replace any existing bookmark with this URL. Default is TRUE If set to FALSE, will throw an error if bookmark exists
#' @param public	TRUE/FALSE	Make bookmark public. Default is "TRUE" unless user has enabled the "save all bookmarks as private" user setting, in which case default is "no"
#' @param toread	TRUE/FALSE	Marks the bookmark as unread. Default is "FALSE"
#' @inheritParams pb_tags_get
#'
#' @return status in text 'done'
#' @export
#'
#' @examples
#' \dontrun{
#' pb_posts_add(url="https://example.com", title="an example website")
#' }
pb_posts_add <- function(url, title, description = NULL, tags = NULL, dt = NULL, replace = NULL, public = NULL, toread = NULL, username = NULL, token = NULL) {
  stop_on_no_url(url)
  if (length(tags) > 100) stop("you can add a maximum of 100 tags")
  arguments <- concat_args(
    url = url, title = title, description = description, tags = tags_parser(tags), dt = dt, replace = replace, public = public, toread = toread
  )
  path <- "posts/add"
  result <- retrieve_results(path = path, arguments = arguments, username = username, token = token)
  result$result_code
}


#' Delete a bookmark
#'
#' Delete a bookmark from pinboard by url.
#' @param url **REQUIRED** url of bookmark to delete
#' @inheritParams pb_tags_get
#'
#' @return status in text: "done", "item not found"
#' @export
#'
#' @examples
#' \dontrun{
#' pb_posts_delete("https://example.com")
#' }
pb_posts_delete <- function(url = NULL, username = NULL, token = NULL) {
  stop_on_no_url(url)
  path <- "posts/delete"
  result <- retrieve_results(path = path, arguments = paste0("url=", url), username = username, token = token)
  result$result_code
}


#' Get all posts on a day
#'
#' Returns one or more posts on a single day matching the arguments.
#' If no date or url is given, date of most recent bookmark will be used.
#' @param tags	filter by up to three tags
#' @param dt	return results bookmarked on this day (UTC date in this format: 2010-12-31).
#' @param url	return bookmark for this URL
#' @param meta TRUE/FALSE	include a change detection signature in a meta attribute
#' @inheritParams pb_tags_get
#'
#' @return a dataframe of all posts of pinboard format see `?pinboard_formatting`
#' @export
#'
#' @examples
#' \dontrun{
#' pb_posts_get()
#' }
pb_posts_get <- function(tags = NULL, dt = NULL, url = NULL, meta = NULL, username = NULL, token = NULL) {
  stop_on_more_3_tags(tags)
  tag <- tags_parser(tags)
  meta <- true_false_yes_no(meta)
  path <- "posts/get"
  arguments <- c(paste0("tag=", tag), paste0("dt=", dt), paste0("url=", url), paste0("meta=", meta))
  arguments <- remove_empty_vars(arguments)
  result <- retrieve_results(path = path, arguments = arguments, username = username, token = token)
  pinboard_dataframe_to_logical_names(result$posts)
}


#' Get most recent posts
#'
#' Returns a list of the user's most recent posts, filtered by tag.
#' @param tags tags filter by up to three tags
#' @param count number of results to return default is 15 max is 100
#' @inheritParams pb_tags_get
#'
#' @return a dataframe of all recent of pinboard format see `?pinboard_formatting`
#' @export
#'
#' @examples
#' \dontrun{
#' pb_posts_recent(tags = "inspiration")
#' }
pb_posts_recent <- function(tags = NULL, count = 15, username = NULL, token = NULL) {
  if (count > 100) stop("set count to maximum of 100")
  stop_on_more_3_tags
  tag <- tags_parser(tags)
  # todo tag up to three
  path <- "posts/recent"
  arguments <- c(paste0("tag=", tag), paste0("count=", count))
  arguments <- remove_empty_vars(arguments)
  result <- retrieve_results(path = path, arguments = arguments, username = username, token = token)
  pinboard_dataframe_to_logical_names(result$posts)
}



#' Posts per date
#'
#' Returns a dataframe of dates with the number of posts at each date.
#' Use this to see all posts per date or posts per tag per date.
#' @param tags	filter by up to three tags
#' @inheritParams pb_tags_get
#'
#' @return a data.frame with dates and counts
#' @export
#'
#' @examples
#' \dontrun{
#' pb_posts_dates(tags = "europe")
#' }
pb_posts_dates <- function(tags = NULL, username = NULL, token = NULL) {
  path <- "posts/dates"
  result <- retrieve_results(path = path, arguments = paste0("tag=", tags), username = username, token = token)
  parse_1d_list_to_df(result$dates, col1 = "date", col2 = "count")
}

#' Return all bookmarks in the user's account
#'
#' This API endpoint is rate limited to once every 5 minutes.
#' @param tags	filter by up to three tags
#' @param start	int	offset value (default is 0)
#' @param results	int	number of results to return. Default is all
#' @param fromdt	datetime	return only bookmarks created after this time
#' @param todt	datetime	return only bookmarks created before this time
#' @param meta	int	include a change detection signature for each bookmark
#' @inheritParams pb_tags_get
#'
#' @return a dataframe of all posts of pinboard format see `?pinboard_formatting`
#' @export
#' @examples
#' \dontrun{
#' pb_posts_all(tags = "inspiration", results = 15)
#' }
pb_posts_all <- function(tags = NULL, start = 0L, results = NULL, fromdt = NULL, todt = NULL, meta = NULL, username = NULL, token = NULL) {
  stop_on_more_3_tags(tags)
  tag <- tags_parser(tags)
  arguments <- c(
    paste0("tag=", tag),
    paste0("start=", start),
    paste0("results=", results),
    paste0("fromdt=", fromdt),
    paste0("todt=", todt),
    paste0("meta=", meta)
  )
  arguments <- remove_empty_vars(arguments)
  path <- "posts/all"
  result <- retrieve_results(path = path, arguments = arguments, username = username, token = token)
  pinboard_dataframe_to_logical_names(result)
}

#' Returns a list of popular tags and recommended tags for a given URL.
#'
#' Popular tags are tags used site-wide for the url; recommended tags are drawn from the user's own tags.
#' @param url **REQUIRED** url to get suggestions for
#' @inheritParams pb_tags_get
#'
#' @return a data.frame with popular and recommended tags
#' @export
#'
#' @examples
#' \dontrun{
#' pb_posts_suggest(url = "https://example.com")
#' }
pb_posts_suggest <- function(url = NULL, username = NULL, token = NULL) {
  stop_on_no_url(url)
  result <- retrieve_results(path = "posts/suggest", arguments = paste0("url=", url), username = username, token = token, simplifyDataFrame = FALSE)
  suggest_to_df(result)
}
