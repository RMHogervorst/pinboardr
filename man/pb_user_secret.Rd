% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/user.R
\name{pb_user_secret}
\alias{pb_user_secret}
\title{Returns the user's secret RSS key (for viewing private feeds)}
\usage{
pb_user_secret(username = NULL, token = NULL)
}
\arguments{
\item{username}{your username You probably don't need to supply this every time. See \code{?authentication}}

\item{token}{your token}
}
\value{
the secret RSS key
}
\description{
Get your secret RSS key for private feeds.
}
\examples{
\dontrun{
pb_user_secret()
}
}
