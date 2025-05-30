% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/old_dataset.R
\name{Dataset.get_global_beacon_status}
\alias{Dataset.get_global_beacon_status}
\title{Dataset.get_global_beacon_status}
\usage{
Dataset.get_global_beacon_status(
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
Retrieves the global beacon status for the dataset.
}
\examples{
\dontrun{
Dataset.get_global_beacon_status("1234567890")
}

}
\references{
\url{https://docs.solvebio.com/}
}
\concept{quartzbio_api}
