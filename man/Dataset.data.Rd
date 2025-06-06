% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/old_dataset.R
\name{Dataset.data}
\alias{Dataset.data}
\title{Dataset.data}
\usage{
Dataset.data(id, filters, env = get_connection(), ...)
}
\arguments{
\item{id}{The ID of a QuartzBio EDP dataset, or a Dataset object.}

\item{filters}{(optional) Query filters.}

\item{env}{(optional) Custom client environment.}

\item{...}{(optional) Additional query parameters (e.g. limit, offset).}
}
\description{
Returns one page of documents from a QuartzBio EDP dataset and processes the response.
}
\examples{
\dontrun{
Dataset.data("1234567890")
}

}
\references{
\url{https://docs.solvebio.com/}
}
\concept{quartzbio_api}
