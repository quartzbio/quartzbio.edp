% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/old_application.R
\name{Application.delete}
\alias{Application.delete}
\title{Application.delete}
\usage{
Application.delete(client_id, env = get_connection())
}
\arguments{
\item{client_id}{The client ID for the application.}

\item{env}{(optional) Custom client environment.}
}
\description{
Delete a specific application from QuartzBio EDP.
}
\examples{
\dontrun{
Application.delete("abcd1234")
}

}
\references{
\url{https://docs.solvebio.com/}
}
\concept{quartzbio_api}
