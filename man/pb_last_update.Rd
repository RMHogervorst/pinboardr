% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/misc.R
\name{pb_last_update}
\alias{pb_last_update}
\title{Find the last update time}
\usage{
pb_last_update(as_datetime = FALSE, username = NULL, token = NULL)
}
\arguments{
\item{as_datetime}{defaults to FALSE, if TRUE will turn the text value into "POSIXlt" "POSIXt"}

\item{username}{your username You probably don't need to supply this every time. See \code{?authentication}}

\item{token}{your token}
}
\value{
time in text format or as "POSIXlt" "POSIXt"
}
\description{
Returns the most recent time a bookmark was added, updated or deleted.
Use this before calling posts_all to see if the data has changed since the last fetch.
}
\examples{
\dontrun{
pb_last_update(as_datetime = TRUE)
pb_last_update()
}
}
