% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/02_shared_params.R
\name{params}
\alias{params}
\title{shared roxygen params}
\arguments{
\item{account_id}{an Account ID as a string.}

\item{alive}{whether to select the Tasks that are alive, i.e. not finished
or failed.}

\item{all}{whether to fetch all data, by iterating if needed.}

\item{ancestor_id}{an object ID of an ancestor, for filtering.}

\item{as_data_frame}{whether to convert the results as a data frame.}

\item{capacity}{The dataset capacity level (small, medium, or large).}

\item{client_id}{the client ID for the application.}

\item{commit_mode}{There are four commit modes that can be selected depending on the scenario:
append (default), overwrite, upsert, and delete.}

\item{conn}{a EDP connection object (as a named list or environment)}

\item{dataset_id}{a Dataset ID as a string}

\item{data_type}{the data type. one of:
\itemize{
\item auto (the default)
\item boolean - Either True, False, or null
\item date - A string in ISO 8601 format, for example: \verb{2017-03-29T14:52:01}
\item double - A double-precision 64-bit IEEE 754 floating point.
\item float - single-precision 32-bit IEEE 754 floating point.
\item integer     A signed 32-bit integer with a minimum value of -231 and a maximum value of 231-1.
\item long     A signed 64-bit integer with a minimum value of -263 and a maximum value of 263-1.
\item object     A key/value, JSON-like object, similar to a Python dictionary.
\item string     A valid UTF-8 string up to 32,766 characters in length.
\item text     A valid UTF-8 string of any length, indexed for full-text search.
\item blob     A valid UTF-8 string of any length, not indexed for search.
}}

\item{depth}{the depth of the object in the Vault as an integer (0 means root)}

\item{description}{the description as a string.}

\item{entity_type}{A valid entity type:
\itemize{
\item dataset - a Dataset ID (510110013133189334)
\item gene - A gene (EGFR)
\item genomic_region - A genomic region (GRCH38-7-55019017-55211628)
\item literature - A PubMed ID (19915526)
\item sample - A sample identifier (TCGA-02-0001)
\item variant - A genomic variant (GRCH38-7-55181378-55181378-T)
}}

\item{env}{Custom client environment.}

\item{exclude_fields}{A list of fields to exclude in the results, as a character vector.}

\item{exclude_group_id}{a group ID to exclude.}

\item{expression}{EDP xpressions are Python-like formulas that can be used to pull
data from datasets, calculate statistics, or run advanced algorithms.}

\item{facets}{A valid facets objects.}

\item{fields}{The fields to add.}

\item{field_id}{a Field object ID.}

\item{file_id}{a file Object ID.}

\item{filename}{an Object filename, without the parent folder (e.g. "foo.csv")}

\item{filters}{a filter expression as a JSON string.}

\item{full_path}{an Object full path, including the account, vault and path.}

\item{glob}{a glob (full path with wildcard characters) which searches
objects for matching paths (case-insensitive).}

\item{include_errors}{whether to include errors in the output.}

\item{is_list}{whether the result is expected to be a list.}

\item{limit}{The maximum number of elements to fetch, as an integer.
See also \code{page}.}

\item{local_path}{the path of a local file.}

\item{md5}{a MD5 fingerprint, as a string.}

\item{metadata}{metadata as a named list.}

\item{mimetype}{the MIME type of the Object.}

\item{min_distance}{used in conjuction with the ancestor_id filter to only include
objects at a minimum distance from the ancestor.}

\item{object_type}{the type of an object, one of  "file", "folder", or "dataset".}

\item{ordering}{A list of fields to order/sort the results with, as a character vector.}

\item{offset}{the file offset (starts from 0).}

\item{page}{The number of the page to fetch, as an integer. starts from 1.
See also \code{limit}.}

\item{path}{the path of an object, with the folders (e.g. "/d1/d2/foo.csv").}

\item{parallel}{whether to parallelize the API calls.}

\item{parent_object_id}{the ID of the parent of the Object.}

\item{query}{a string that matches any objects whose path contains that string.}

\item{raw}{whether to return the raw response.}

\item{records}{The data to annotate as a data frame.}

\item{regex}{A regular expression, as a string, to filter the results with.}

\item{size}{The size of the object.}

\item{status}{a Task status, one of (running, queued, pending, completed, failed
)}

\item{storage_class}{The Storage class of the vault \verb{('Standard', 'Standard-IA', 'Essential', 'Temporary', 'Performance', 'Archive')} as a string.}

\item{sync}{whether to proceed in synchronous mode, i.e to wait for all
sub tasks to finish before returning.}

\item{tag}{a single tag as a string.}

\item{tags}{a list of tags as a character vector.}

\item{target_fields}{A list of valid dataset fields to create or override in the import,
as a character vector.}

\item{task_id}{an (ECS) Task ID as a string.}

\item{url_template}{A URL template with one or more "value" sections that will be
interpolated with the field value and displayed as a link
in the dataset table.}

\item{user_id}{a user id (or User object) as a string}

\item{vault_id}{a Vault ID as a string (e.g. "19").}

\item{vault_name}{a Vault name as a string (e.g. "Public").}

\item{vault_full_path}{a Vault full path, as a string (e.g. "quartzbio:Public")}

\item{vault_path}{a Vault path, as a string (e.g. "/d1/d2/foo.csv")}

\item{vault_type}{the type of vault ('user', 'general') as a string}

\item{workers}{in parallel mode, the number of concurrent requests to make}

\item{...}{Additional query parameters, passed to .request().}
}
\description{
shared roxygen params
}
\references{
\url{https://docs.solvebio.com/}
}
