#' How to setup your authentication
#'
#' All interactions with the 'pinboard.in' API (application programming interface)
#' require authentication. This doc explains where to find your secrets and how
#' to set up your computer so you can programmaticaly interact with pinboard.
#'
#' You do need to have a pinboard account.
#'
#' ## Finding your secrets
#' Go to the [pinboard password page](https://pinboard.in/settings/password)
#' and scroll down to API Token.
#' It says something like: "this is your API token:
#' `username:NUMBERSANDLETTERS`
#'
#'
#' ### .Renvironment file
#' I would recommend you add the token to your .renviron file, either locally or
#' globally. A full introduction how these files work is beyond the scope
#' of this doc but if you create a 'hidden' file named .Renviron in the project folder
#' or in your home folder, R will read in the username and token and they will
#' be available to pinboardr.
#' Use `usethis::edit_r_environ()` or find the file manually.
#'
#' Add to your .renviron file the following
#' PB_USERNAME=username
#' PB_TOKEN="NUMBERSANDLETTERS"
#'
#' Restart the session to make the changes active.
#'
#' ### setting variables locally
#' This is not the recommended approach, but will work nevertheless.
#' You can either:
#'
#' - set the variables at the start of your session using Sys.setenv(PB_USERNAME = "username", PB_TOKEN="NUMBERSANDLETTERS")
#' - pass the username and token to every command: pb_last_update(username=username, token=NUMBERSANDLETTERS)
#'
#' Why is this not recommended?
#' This means your secrets, username and token are visible in your .rhistory, and if you save it in a
#' script, it will be visible to anyone who opens your script. I think you don't want that, but
#' my threatmodel is not your threatmodel.
#'
#' @name authentication
NULL




#' Pinboard format data.frame
#'
#' The pinboardr package returns the data in a format as close as possible
#' to the data supplied by the API. Because 'pinboard.in' modeled their
#' API on the original 'Delicious API' with the same unfortunate
#' choices. See also the description on pinboard
#' [posts_add docs](https://pinboard.in/api/#posts_add).
#'
#' I try to hide the complexity from you by translating but sometimes that
#' gives us different names. I first give you the pinboardr name
#' and than the name in the delicious and pinboard API:
#'
#' * The 'title' of a bookmark is actually called 'description'.
#' * The 'description' of a bookmark is actually called 'extended'.
#' * The 'public' setting of bookmarks is called 'shared'.
#'
#'
#' @name pinboard_formatting
NULL
