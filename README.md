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

## ALPHA - RELEASE

* on going migration of former solvebio R API to the new package.  
* backward compatibility has been maintained.  
* See [ChangeLog](../docs/news/index.html) for updates

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

* Save into the ** ~/.qb/edp.json files** a default EDP configuration profile.  

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
Vaults()
Folders()
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
