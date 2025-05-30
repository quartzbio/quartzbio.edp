% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/old_dataset.R
\name{Dataset.delete}
\alias{Dataset.delete}
\title{Dataset.delete}
\usage{
Dataset.delete(id, env = get_connection())
}
\arguments{
\item{id}{String The ID of a QuartzBio EDP dataset}

\item{env}{(optional) Custom client environment.}
}
\description{
Delete a specific dataset from QuartzBio EDP.
}
\examples{
\dontrun{
Dataset.delete("1234567890")
}

}
\references{
\url{https://docs.solvebio.com/}
}
\concept{quartzbio_api}
