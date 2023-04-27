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

Authentication Tokens can be obtained from [Personal Access Tokens](https://docs.solvebio.com/#authentication)


## Installation

Installing this package requires an installed [R environment](https://www.r-project.org).  

**from CRAN**
```R

install.packages("quartzbio.edp")
library(quartzbio.edp)
```

**from github**

```R
install.packages(c("devtools", "httr", "jsonlite"))
library(devtools)
devtools::install_github("quartzbio.edp/quartzbio.edp-r", ref="master")
```


## Usage

### connection/authentication

See the [Connection to an EDP host vignette](../doc/connection.html)  Connection to an EDP host vignette for more details.

Save into the ** ~/.qb/edp.json files** a default EDP configuration profile.
Functions use it if no connection are specified in arguments.


```
{
  "default": {
    "secret": "API_TOKEN",
    "host": "https://api.solvebio.com"
  }
}
```

```R
library(quartzbio.edp)
User()
```

### Vaults, DataSets


## Shiny

To use QuartzBio EDP in your Shiny app, refer to the docs on [Developing Applications with R Shiny and QuartzBio EDP](https://docs.solvebio.com/applications/developing/#r-shiny-and-solvebio).

This package provides a Shiny server wrapper called `quartzbio.edp::protectedServer()` which requires users to authenticate with QuartzBio EDP and authorize the app before proceeding. In addition, you may enable token cookie storage by installing [ShinyJS](https://deanattali.com/shinyjs/) and adding JS code (`quartzbio.edp::protectedServerJS()`) to your Shiny UI.

An example app is available in the [solvebio-shiny-example](https://github.com/solvebio/solvebio-shiny-example) GitHub repository.


## Developers

To install the development version of this package from GitHub, you will need the `devtools` package.

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
