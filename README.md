QuartzBio EDP for R
=========================


This package contains the QuartzBio EDP R language bindings. QuartzBio EDP makes it easy
to access genomic reference data.

Features of this package include:

* Authentication with QuartzBio EDP's API
* REST API query support
* S3 object system for QuartzBio EDP API resources
* Portability between most platforms: Linux, Windows, OS X.

Please see the QuartzBio EDP [documentation](https://docs.solvebio.com) for more
information about the platform.


## Installation

Installing this package requires an installed [R environment](https://www.r-project.org).

```R
install.packages("solvebio")
library(solvebio)
```

## Usage

### connection/authentication

```R
# assume that key holds an API key, and token an API token, and secret either a key or a token, 
# and host an API host

# implicit
conn <- connect(key)
conn <- connect(token)
conn <- connect(secret)
conn <- connect(key, api_host = host)

# explicit
conn <- connect(api_key = key)
conn <- connect(api_token = token, api_host = host)

# equivalently using a list
conn <- connect(list(api_secret = secret  , api_host = host))

# using env vars: any of EDP_SECRET, SOLVEBIO_API_KEY or SOLVEBIO_API_TOKEN containing a secret
# with priority of EDP_SECRET > SOLVEBIO_API_TOKEN > SOLVEBIO_API_KEY
# and EDP_HOST > SOLVEBIO_API_HOST the API host

conn <- connect()

###### profiles
# use default path (~/qb/edp.json) and default profile ("default")
conn <- connect_with_profile()
conn <- connect_with_profile("testing")
conn <- connect_with_profile(profile = "testing", path = "toto.json")


what about using env vars EDP_PROFILE and EDP_CONFIG_PATH ? 
Should they work also with `connect()` 


### default connection
# all API functions will have a conn = get_connection() param
`get_connection()` will:
- if not connection is set, set it using `set_connection(connect())`
- otherwise just return the default connection






```





```R
# By default it will look for a key in the $SOLVEBIO_API_KEY environment variable.
library(solvebio)

# You may also supply an API key in your code
login(api_key="<Your API key>")
# RStudio users can put the following line in ~/.Rprofile
# Sys.setenv(SOLVEBIO_API_KEY="<Your API key>")

# Retrieve a list of all datasets
datasets <- Dataset.all()

# Retrieve a specific dataset (metadata)
ClinVar <- Dataset.get_by_full_path("solvebio:public:/ClinVar/3.7.4-2017-01-30/Variants-GRCh37")

# Query a dataset with filters as JSON:
filters <- '[["gene_symbol", "BRCA1"]]'
# or, filters as R code:
filters <- list(list('gene_symbol', 'BRCA1'), list('clinical_significance',
'Benign'))

# Execute the queries
# NOTE: paginate=TRUE may issue multiple requests, depending on the dataset and filters
results <- Dataset.query(id = ClinVar$id, filters = filters, limit = 1000, paginate = TRUE)

# Access the results (flattened by default)
results

```


## Shiny

To use QuartzBio EDP in your Shiny app, refer to the docs on [Developing Applications with R Shiny and QuartzBio EDP](https://docs.solvebio.com/applications/developing/#r-shiny-and-solvebio).

This package provides a Shiny server wrapper called `quartzbio.edp::protectedServer()` which requires users to authenticate with QuartzBio EDP and authorize the app before proceeding. In addition, you may enable token cookie storage by installing [ShinyJS](https://deanattali.com/shinyjs/) and adding JS code (`quartzbio.edp::protectedServerJS()`) to your Shiny UI.

An example app is available in the [solvebio-shiny-example](https://github.com/solvebio/solvebio-shiny-example) GitHub repository.


## Developers

To install the development version of this package from GitHub, you will need the `devtools` package.

```R
install.packages(c("devtools", "httr", "jsonlite"))
library(devtools)
devtools::install_github("solvebio/solvebio-r", ref="master")
library(solvebio)
```

To run the test suite:

```bash
make test
```


## Packaging and Releasing

1. Bump the version using the `bumpversion` command (pip install bumpversion).
2. Update the NEWS.md with changes.
3. Update the DESCRIPTION file with the latest date.
4. Regenerate roxygen2 and build/check the tarball:

    make clean
    make
    make check

5. Submit to CRAN.
