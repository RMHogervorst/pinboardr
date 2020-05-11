
#' Find the last update time
#'
#' Returns the most recent time a bookmark was added, updated or deleted.
#' Use this before calling posts_all to see if the data has changed since the last fetch.
#' @param as_datetime defaults to FALSE, if TRUE will turn the text value into "POSIXlt" "POSIXt"
#' @inheritParams pb_tags_get
#'
#' @return time in text format or as "POSIXlt" "POSIXt"
#' @export
#'
#' @examples
#' \dontrun{
#' pb_last_update(as_datetime = TRUE)
#' pb_last_update()
#' }
pb_last_update <- function(as_datetime = FALSE, username = NULL, token = NULL) {
  path <- "posts/update"
  timestamp <- retrieve_results(path = path, username = username, token = token)
  result <- timestamp$update_time
  if (as_datetime) {
    result <- strptime(result, format = "%Y-%m-%dT%H:%M:%S", tz = "UTC")
  }
  result
}


parse_1d_list_to_df <- function(list, col1 = "tag", col2 = "count") {
  tags <- data.frame(
    tag = names(list),
    count = as.numeric(unlist(list))
  )
  stats::setNames(tags, c(col1, col2))
}

remove_empty_vars <- function(vec) {
  vec[!grepl("=$", vec)]
}

concat_args <- function(url = NULL, title = NULL, description = NULL, tags = NULL, dt = NULL, replace = NULL, public = NULL, toread = NULL) {
  title <- url_encode_when_not_null(title)
  description <- url_encode_when_not_null(description)
  arguments <- c(
    paste0("url=", url),
    paste0("description=", title),
    paste0("extended=", description),
    paste0("tags=", tags),
    paste0("dt=", dt),
    paste0("replace=", replace),
    paste0("shared=", public),
    paste0("toread=", toread)
  )
  remove_empty_vars(arguments)
}

url_encode_when_not_null <- function(value) {
  if (!is.null(value)) {
    utils::URLencode(value)
  }
}

stop_on_more_3_tags <- function(tags) {
  if (length(tags) > 3) stop("do not use more than 3 tags")
}


true_false_yes_no <- function(BOOL) {
  if (length(BOOL) == 0) {
    ""
  } else if (BOOL) {
    "yes"
  } else if (!BOOL) {
    "no"
  } else {
    stop("argument was not TRUE or FALSE")
  }
}


suggest_to_df <- function(suggest_list) {
  h_l <- list()
  for (i in 1:length(suggest_list)) {
    name <- names(suggest_list[[i]])
    items <- suggest_list[[i]][[1]]
    if (length(items) == 0) items <- NA
    h_l[[name]] <- items
  }
  popular <- stats::na.exclude(h_l$popular)
  recommended <- stats::na.exclude(h_l$recommended)
  suggested_tags <- data.frame(tag = union(popular, recommended))
  suggested_tags$popular <- suggested_tags$tag %in% popular
  suggested_tags$recommended <- suggested_tags$tag %in% recommended
  suggested_tags
}

stop_on_no_url <- function(url) {
  if (is.null(url)) stop("No url supplied")
}

tags_parser <- function(tag_vector = NULL) {
  if (any(grepl(" |,", tag_vector))) warning("tags contain whitespaces or commas, removing...")
  tag_vector <- gsub(" ", "", tag_vector)
  tag_vector <- gsub(",", "", tag_vector)
  paste0(tag_vector, collapse = "+")
}

pinboard_dataframe_to_logical_names <- function(api_df) {
  api_df <- rename_column(api_df, "description", "title")
  api_df <- rename_column(api_df, "extended", "description")
  api_df <- rename_column(api_df, "shared", "public")
  api_df
}

rename_column <- function(df, oldname, newname) {
  names(df)[names(df) == oldname] <- newname
  df
}

#' Extract one tag from tag columns into separate column.
#'
#' Convenience function to make working with the dataframe of bookmarks
#' a bit easier.
#' @param dataframe the dataframe of bookmarks
#' @param tag tag you would like to extract into a new column
#' @return a dataframe with one extra column, containing TRUE or FALSE for presence of the tag
#' @export
#'
#' @examples
#' \dontrun{
#' pb_add_tag_column(all_bookmars, "europe")
#' }
pb_add_tag_column <- function(dataframe, tag) {
  dataframe[tag] <- grepl(tag, dataframe$tags)
  dataframe
}
