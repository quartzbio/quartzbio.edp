% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/connect.R
\name{save_connection_profile}
\alias{save_connection_profile}
\title{save a connection profile}
\usage{
save_connection_profile(
  conn,
  profile = get_env("EDP_PROFILE", "default"),
  path = get_env("EDP_CONFIG", "~/.qb/edp.json"),
  overwrite = FALSE
)
}
\arguments{
\item{conn}{a EDP connection object (as a named list or environment)}

\item{profile}{the name of the profile, as a string}

\item{path}{the path to the connection profiles file, as a string}

\item{overwrite}{whether to overwrite an existing profile}
}
\description{
save a connection profile
}
\seealso{
Other connection: 
\code{\link{read_connection_profile}()}
}
\concept{connection}
