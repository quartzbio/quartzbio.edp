QuartzBio EDP for R
=========================

This package contains the QuartzBio EDP R language bindings for the EDP (Enterprise Data Platform) API.

Features:

* Authentication
* Parallelization of dataset queries
* Progress report
* S3 methods
* Portability between most platforms: Linux, Windows, OS X.

Please see the legacy SolveBio [documentation](https://docs.solvebio.com) for more
information about the platform.

## Beta Release

* on-going migration of legacy solvebio R API to the new **quartzbio.edp** package.
* backwards compatibility is currently maintained by providing the legacy SolveBio R client with the
  new client.
* See [ChangeLog](https://quartzbio.github.io/quartzbio.edp/news/index.html) for updates


## Installation

Installing this package requires an installed R environment.

### installation from GitHub

```R
remotes::install_github("quartzbio/quartzbio.edp", dependencies = TRUE, ref = "main")
```

### RcppSimdJson and CXX17

**quartzbio.edp** uses the [RcppSimdJson](https://cran.r-project.org/package=RcppSimdJson) R package for speed.


But on some older systems, **RcppSimdJson** requires a **CXX17** compatible C++ compiler, even when installed from a pre-compiled binary package..

In this case, you can manually install a **CXX17** compiler. Here are some resources:
- https://www.geeksforgeeks.org/complete-guide-to-install-c17-in-windows/
- https://gasparri.org/2020/07/30/installing-c17-and-c20-on-ubuntu-and-amazon-linux/


In any case, **RcppSimdJson** is **optional**. If not installed, **quartzbio.edp** will work seamlessly in **degraded mode**.


### complete reproducible installation example using a tidyverse qbrocker image

```
# run a shell inside the tidyverse container
docker run -ti --rm rocker/tidyverse  bash

# use the pre-installed installGithub.r script
installGithub.r -d TRUE quartzbio/quartzbio.edp

### OR: run R and use the `install_github()` function
R
>remotes::install_github("quartzbio/quartzbio.edp", dependencies = TRUE)
```

## documentation

* Github public [quartzbio.edp](https://github.com/quartzbio/quartzbio.edp) source repository
* Github quartzbio.edp online package [documentation](https://quartzbio.github.io/quartzbio.edp/)


## Usage

### connection/authentication

See the [Connection to an EDP host vignette](https://quartzbio.github.io/quartzbio.edp/articles/connection.html) for more details.

- Get an Authentication Token. They can be obtained from [Personal Access Tokens](https://docs.solvebio.com/#authentication)


* Save it into the `~/.qb/edp.json` file as the **default** EDP configuration profile.
Your `~/.qb/edp.json` may look like:
```
{
  "default": {
    "secret": "PUT_HERE_TOUR_AUTHENTICATION_TOKEN",
    "host": "https://api.solvebio.com"
  }
}
```

The package functions will use this default profile by default if you do not use an explicit configuration.
For example:

```R
library(quartzbio.edp)
User()
Vaults()
Folders()
```


## Articles

* [Vignettes](https://quartzbio.github.io/quartzbio.edp/articles/)
