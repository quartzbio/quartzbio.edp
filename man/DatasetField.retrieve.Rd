% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/old_dataset_field.R
\name{DatasetField.retrieve}
\alias{DatasetField.retrieve}
\title{DatasetField.retrieve}
\usage{
DatasetField.retrieve(id, env = get_connection())
}
\arguments{
\item{id}{String The ID of a dataset field.}

\item{env}{(optional) Custom client environment.}
}
\description{
Retrieves the metadata about a specific dataset field.
}
\examples{
\dontrun{
DatasetField.retrieve(691)
}

}
\references{
\url{https://docs.solvebio.com/}
}
\concept{quartzbio_api}
