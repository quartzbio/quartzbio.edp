% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/old_shiny.R
\name{protectedServer}
\alias{protectedServer}
\title{protectedServer}
\usage{
protectedServer(
  server,
  client_id,
  client_secret = NULL,
  base_url = "https://my.solvebio.com"
)
}
\arguments{
\item{server}{Your original Shiny server function.}

\item{client_id}{Your application's client ID.}

\item{client_secret}{(optional) Your application's client secret.}

\item{base_url}{(optional) Override the default login host (default: https://my.solvebio.com).}
}
\description{
Wraps an existing Shiny server in an OAuth2 flow.
}
\examples{
\dontrun{
protectedServer(
  server = server,
  client_id = "abcd1234"
)
}

}
\references{
\url{https://docs.solvebio.com/}
}
\concept{quartzbio_api}
