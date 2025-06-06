% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/old_dataset.R
\name{Dataset.fields}
\alias{Dataset.fields}
\title{Dataset.fields}
\usage{
Dataset.fields(id, env = get_connection(), ...)
}
\arguments{
\item{id}{The ID of a QuartzBio EDP dataset, or a Dataset object.}

\item{env}{(optional) Custom client environment.}

\item{...}{(optional) Additional query parameters (e.g. limit, offset).}
}
\description{
Retrieves the list of fields and field metadata for a dataset.
}
\examples{
\dontrun{
Dataset.fields("1234567890")
}

}
\references{
\url{https://docs.solvebio.com/}
}
\concept{quartzbio_api}
