% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/old_object.R
\name{Object.get_global_beacon_status}
\alias{Object.get_global_beacon_status}
\title{Object.get_global_beacon_status}
\usage{
Object.get_global_beacon_status(
  id,
  raise_on_disabled = FALSE,
  env = get_connection()
)
}
\arguments{
\item{id}{The ID of a QuartzBio EDP dataset.}

\item{raise_on_disabled}{Whether to raise an exception if Global Beacon is disabled or to return NULL.}

\item{env}{(optional) Custom client environment.}
}
\description{
Retrieves the global beacon status for the specified dataset.
}
\examples{
\dontrun{
Object.get_global_beacon_status("1234567890")
Object.get_global_beacon_status("1234567890", raise_on_disabled = TRUE)
}

}
\references{
\url{https://docs.solvebio.com/}
}
\concept{quartzbio_api}
