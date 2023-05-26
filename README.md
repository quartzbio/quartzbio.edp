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
* See [ChangeLog](https://quartzbio.github.io/quartzbio.edp/news/index.html) for updates

## Installation

Installing this package requires an installed [R environment](https://www.r-project.org).  

**from github**

```R
install.packages(c("devtools", "httr"), dependencies = TRUE)
install.packages(c("leafem", "leaflet", "leafpop", "raster", "satellite"), dependencies = TRUE)
install.packages(c("sf"), dependencies = TRUE)
install.packages(c("jsonlite"), dependencies = TRUE)

install.packages(c("RcppSimdJson"), dependencies = TRUE)

library(devtools)
devtools::install_github("quartzbio/quartzbio.edp", ref="main")
```


## Usage

* [Github quartzbio.edp](https://github.com/quartzbio/quartzbio.edp)
* [Github quartzbio.edp package documentation](https://quartzbio.github.io/quartzbio.edp)


### Connection/Authentication

See the [Connection to an EDP host vignette](https://quartzbio.github.io/quartzbio.edp/articles/connection.html)  Connection to an EDP host vignette for more details.

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


## Articles

* [Vignettes](https://quartzbio.github.io/quartzbio.edp/articles)
