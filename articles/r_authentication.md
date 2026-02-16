# R Authentication

EDP supports programmatic access via R. To get started, users will need
to authenticate their session using a Personal Access Token.

### Personal Access Tokens

Clients can authenticate with Personal Access Tokens. Create a new
Personal Access Token by clicking “Generate New Token” on the Personal
Access Tokens page
(`https://DOMAIN.edp.aws.quartz.bio/settings/tokens`). Without valid
credentials, API endpoints may return `403 Forbidden`, or
`401 Not Authorized`.

## Pre-Requisites

The EDP supports the use of R for both Unix (Linux, Mac) and Windows
environments. Instructions vary for authentication depending on
environment - see below sections for more detail.

Regardless of environment, all users should first insure that they have
installed the EDP R package as shown below:

``` r
remotes::install_github("quartzbio/quartzbio.edp", dependencies = TRUE, ref = "main")
```

**quartzbio.edp** uses the RcppSimdJson R package for speed. But on some
older systems, RcppSimdJson requires a CXX17 compatible C++ compiler,
even when installed from a pre-compiled binary package.

In this case, you can manually install a CXX17 compiler. Here are some
resources:

<https://www.geeksforgeeks.org/complete-guide-to-install-c17-in-windows/>

<https://gasparri.org/2020/07/30/installing-c17-and-c20-on-ubuntu-and-amazon-linux/>

In any case, **RcppSimdJson** is **optional**. If not installed,
**quartzbio.edp** will work seamlessly in **degraded mode**.

## R Authentication

After installing the package, users will next create the relevant
credential storage files. In a the environment, the EDP R package will,
by default, look for the \$EDP_API_SECRET and \$EDP_API_HOST or
\$QUARTZBIO_ACCESS_TOKEN and \$QUARTZBIO_API_HOST environment variables.

``` r
Sys.setenv(EDP_API_SECRET = "TOKEN")
Sys.setenv(EDP_API_HOST = "https://DOMAIN.api.edp.aws.quartz.bio")
```

## Testing your credentials

When writing R scripts, users can confirm that their token and domain
are loaded appropriately by loading the package and then using the
[`connect()`](https://quartzbio.github.io/quartzbio.edp/reference/connect.md)
function:

``` r
library(quartzbio.edp)

# Load your token from the environment variable

quartzbio.edp::connect()
```

After which, the user credentials should be retrievable within a block
of R code as follows:

``` r
# Load your credentials from $EDP_API_SECRET

quartzbio.edp::connect()

# Get current User

User.retrieve()$email
```

## Connect using QuartzBio EDP configuration profile

Create a EDP configuration profile file `~/.qb/edp.json` as the default
EDP configuration profile. Create a connection profile using
`save_connection_profile` function. This is an example of how your
`~/.qb/edp.json` should look like:

    {
      "default": {
        "secret": "PUT_HERE_YOUR_AUTHENTICATION_TOKEN",
        "host": "https://DOMAIN.api.edp.aws.quartz.bio"
      }
    }

Create and save a connection profile using `save_connection_profile`
function. This creates and saves the **default** connection profile to
`~/.qb/edp.json`

``` r
conn <- quartzbio.edp::connect()
quartzbio.edp::save_connection_profile(conn)
```

Connect to the QuartzBio EDP API using a saved profile in
`~/.qb/edp.json` using `connect_with_profile` function:

``` r
quartzbio.edp::connect_with_profile()
```

The package functions will use this default profile by default if you do
not use an explicit configuration. For example:

``` r
library(quartzbio.edp)
User()
Vaults()
Folders()
```

## EDP Health Check

To perform a quick check to test your credentials and EDP connection use
`edp_health_check` function. This provides a situation report which
checks if their token and domain are valid and EDP connection is
established successfully. It provides the user details if the EDP
connection is successful.

``` r
edp_health_check()
```

The health check function can retrieve the list of vaults created by the
user by setting `get_vault_list` parameter to TRUE

``` r
edp_health_check(get_vault_list = TRUE)
```
