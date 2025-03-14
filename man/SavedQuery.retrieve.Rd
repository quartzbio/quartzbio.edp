% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/old_saved_query.R
\name{SavedQuery.retrieve}
\alias{SavedQuery.retrieve}
\title{SavedQuery.retrieve}
\usage{
SavedQuery.retrieve(id, env = get_connection())
}
\arguments{
\item{id}{String The ID of a QuartzBio EDP saved query.}

\item{env}{(optional) Custom client environment.}
}
\description{
Retrieves a specific saved query on QuartzBio EDP by ID.
}
\examples{
\dontrun{
SavedQuery.retrieve(12345)
}

}
\references{
\url{https://docs.solvebio.com/}
}
\concept{quartzbio_api}
