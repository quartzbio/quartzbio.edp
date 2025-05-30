% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/old_dataset.R
\name{Dataset.template}
\alias{Dataset.template}
\title{Dataset.template}
\usage{
Dataset.template(id, env = get_connection())
}
\arguments{
\item{id}{String The ID of a QuartzBio EDP dataset}

\item{env}{(optional) Custom client environment.}
}
\description{
Retrieves the template for a dataset.
}
\examples{
\dontrun{
Dataset.template("1234567890")
}

}
\references{
\url{https://docs.solvebio.com/}
}
\concept{quartzbio_api}
