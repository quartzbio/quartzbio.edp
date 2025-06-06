% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/old_dataset_export.R
\name{DatasetExport.get_download_url}
\alias{DatasetExport.get_download_url}
\title{DatasetExport.get_download_url}
\usage{
DatasetExport.get_download_url(id, env = get_connection())
}
\arguments{
\item{id}{The ID of the dataset export.}

\item{env}{(optional) Custom client environment.}
}
\description{
Helper method to get the download URL for a dataset export.
}
\examples{
\dontrun{
DatasetExport.get_download_url("1234567890")
}

}
\references{
\url{https://docs.solvebio.com/}
}
\concept{quartzbio_api}
