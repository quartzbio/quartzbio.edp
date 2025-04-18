% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/old_vault.R
\name{Vault.get_by_full_path}
\alias{Vault.get_by_full_path}
\title{Vault.get_by_full_path}
\usage{
Vault.get_by_full_path(full_path, verbose = TRUE, env = get_connection())
}
\arguments{
\item{full_path}{The full path of a QuartzBio EDP vault.}

\item{verbose}{Print warning/error messages (default: TRUE).}

\item{env}{(optional) Custom client environment.}
}
\description{
Retrieves a specific vault by its full path (domain:vault).
}
\examples{
\dontrun{
Vault.get_by_full_path("QuartzBio EDP:Public")
}

}
\references{
\url{https://docs.solvebio.com/}
}
\concept{quartzbio_api}
