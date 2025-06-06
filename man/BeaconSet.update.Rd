% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/old_beacon_set.R
\name{BeaconSet.update}
\alias{BeaconSet.update}
\title{BeaconSet.update}
\usage{
BeaconSet.update(id, env = get_connection(), ...)
}
\arguments{
\item{id}{The ID of the beacon set to update.}

\item{env}{(optional) Custom client environment.}

\item{...}{Beacon set attributes to change.}
}
\description{
Updates the attributes of an existing beacon set.
}
\examples{
\dontrun{
BeaconSet.update(
  id = "1234",
  title = "New Beacon Set Title"
)
}

}
\references{
\url{https://docs.solvebio.com/}
}
\concept{quartzbio_api}
