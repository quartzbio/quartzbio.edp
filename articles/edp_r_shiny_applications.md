# Creating and Deploying EDP R/Shiny Applications

Shiny is an R package that makes it easy to build interactive web apps
straight from R. Developers can use it to build standalone web apps and
dashboards. Shiny can also be extended with custom CSS and JavaScript.
The best way to get started with Shiny is to follow the
[Shiny](https://shiny.rstudio.com/tutorial/) Tutorial.

EDP users can create new Shiny apps through the R API client by creating
EDP applications. EDP applications represent unique OAuth2 credentials
that enable a third-party system to obtain EDP access tokens on behalf
of EDP users. By default, applications created on the EDP are accessible
only to users in the same organization.

## Getting Started

To get started, developers should ensure they have the latest EDP R
package (note: currently named quartzbio.edp) and install the shiny R
package and can also opt to install the shinyjs R package.

``` r
# Install the EDP R package
install.packages("quartzbio.edp")
# Install Shiny
install.packages("shiny")
# Install ShinyJS (optional, for token cookie storage)
install.packages("shinyjs")
```

The user should [authenticate their R
session](https://quartzbio.github.io/quartzbio.edp/articles/r_authentication.md)
using their QuartzBio credentials, and can then start using the EDP R
package to create apps. Each time a user creates a new app, a unique
client ID is generated. Users should make sure to save their client IDs
to a safe place after creation. Users can always contact EDP Support to
retrieve a list of their apps (with their client IDs) in the future.

To create an app, users can enter the following R commands. Doing so
will create the app and allow the user to view its client ID:

``` r
library(quartzbio.edp)
# The redirect URL (protocol, host, and port) must exactly match
# the local development URL.
redirect_uris <- "http://127.0.0.1:3838/"

# Creates the app (only once per application)
# using the standard Shiny OAuth2 redirect URL:
my_app <- Application.create(name = "My Shiny App", redirect_uris = redirect_uris)
# Prints the app's client ID:
cat(my_app$client_id)
```

Users can contact EDP Support to retrieve the relevant client ID if
lost.

## Authenticating Users

The primary advantage of using the R Shiny integration with EDP is the
ability to authenticate users. This enables developers to create
applications that dynamically understand the access permissions of a
user in the EDP. For example, a developer can create an application
allowing access to other users’ vaults without actually having access
themselves.

To authenticate with the EDP, developers can use the client ID in the
Protected Server R function
[`quartzbio.edp::protectedServer`](https://quartzbio.github.io/quartzbio.edp/reference/protectedServer.md)
in their app.R file:

``` r
library(shiny)
library(shinyjs)
library(quartzbio.edp)

# Set Shiny to use port 3838 (for development only)
options(shiny.port = 3838)

server <- function(input, output, session) {
  output$current_user <- renderText({
    # To use the current user's EDP credentials,
    # retrieve the `env` from the session:
    env <- session$userData$solvebio_env

    # Pass the env to any EDP R function:
    user <- User.retrieve(env = env)

    paste("Logged-in as: ", user$full_name)
  })
}

ui <- fluidPage(
  # Optional code for token cookie support
  shiny::tags$head(
    shiny::tags$script(src = "https://cdnjs.cloudflare.com/ajax/libs/js-cookie/2.2.0/js.cookie.js")
  ),
  useShinyjs(),
  extendShinyjs(
    text = quartzbio.edp::protectedServerJS(),
    functions = c("enableCookieAuth", "getCookie", "setCookie", "rmCookie")
  ),

  # UI code:
  titlePanel("Welcome to your EDP Shiny app!"),
  mainPanel(textOutput("current_user"))
)

# Wraps the base server and returns a new protected server function
# Setting client_secret is optional but will encrypt OAuth2 tokens in browser cookies
protected_server <- quartzbio.edp::protectedServer(server, client_id = "YOUR CLIENT ID", client_secret = NULL)

# On the last line of the file, declares the Shiny app with the protected_server
shinyApp(ui = ui, server = protected_server)
```

To authenticate with the EDP, developers can also use the client ID in
the Quartzbio Shiny Auth function
[`quartzbio.edp::quartzbio_shiny_auth`](https://quartzbio.github.io/quartzbio.edp/reference/quartzbio_shiny_auth.md)
in their app.R file. This function can be called in the app server
function whenever the app requires EDP login. This updates the server
session with the user access token which is then used to authenticate
EDP. This function supports component based authorization for
applications where EDP may not be the only data source.

``` r
library(shiny)
library(quartzbio.edp)

# Set Shiny to use port 3838 (for development only)
options(shiny.port = 3838)

# Updates the current session with OAuth2 tokens for EDP connection
quartzbio_shiny_auth(input, session, client_id = "YOUR CLIENT ID", client_secret = "YOUR CLIENT_SECRET", base_url = BASE_URL)
```

To override the OAuth2 Authentication and use EDP Personal Access token,
user can set the `SOLVEBIO_API_KEY` variable in the environment. This
will use the access token to authenticate to EDP.

### Logging in Shiny Applications

By utilizing the `logger` package, users of shiny apps can add verbose
logs in the log file to enhance the developer experience. The
[`quartzbio.edp::quartzbio_shiny_auth`](https://quartzbio.github.io/quartzbio.edp/reference/quartzbio_shiny_auth.md)
function provides user an option to record log messages to a logfile. If
the Shiny application uses `logger`, the `quartzbio_shiny_auth`
authentication function uses existing log file to log messages. By
setting the `create_logfile` parameter to TRUE, the function also gives
the user the choice to create log file to enable logging. Logging
defaults to the console if `logger` is not used.

## Updating Applications

Users can update the redirect URIs of their EDP R applications as
needed, such as when moving from a local development environment to a
production environment:

``` r
library(quartzbio.edp)

# Retrieves app (the first that matches the name, owned by the current user)
my_app <- Application.all(name = "My Shiny App", user = User.retrieve()$id)$data

# Adds the 'write' scope and set the production redirect URI.
Application.update(my_app$client_id, scopes = "read write", redirect_uris = "https://my-app.my-dash-apps.net/_oauth-redirect")
```

## Deleting Applications

Users can delete EDP R applications by issuing the following commands.
Deleting the application in this way will revoke the relevant
authentication credentials and client ID.

``` r
library(quartzbio.edp)

# Retrieves app (the first that matches the name, owned by the current user)
my_app <- Application.all(name = "My Shiny App", user = User.retrieve()$id)$data

# Deletes the app
Application.delete(my_app$client_id)
```

## Deploying Shiny Apps

The recommended way to deploy Shiny apps is to use Shiny Server Pro
(which may require a separate license). Users with an on-premises Shiny
Server can contact their local sysadmin for help deploying the app.

Users who want to test their Shiny apps using a public server can use
Shinyapps.io or [Heroku](https://www.heroku.com/). **Users should keep
in mind that their data may be accessible by a third-party system if
they choose one of these options.**

### Example Shiny App

The [Example R/EDP Shiny
App](https://github.com/solvebio/solvebio-r/tree/master/examples/secure_shiny_app)
is a simple Shiny app wrapped by EDP’s “protected server”, requiring
users to authorize the app with their QuartzBio account via OAuth2. The
app presents the user with a list of datasets in their personal vault.

In order to run the app, two environment variables are required: -
CLIENT_ID: The client ID of the user’s EDP application - APP_URL: The
full URL (host, port, and path if necessary) of the user’s app once it
is deployed (defaults to `http://127.0.0.1:3838`)

## Running Locally

After creating a client ID, the user should write it to a.Renvironfile
in the app’s directory as shown above (see Updating Applications):

    CLIENT_ID=your-client-id

The user can then install the dependencies for the app by running
init.R:

    Rscript init.R

To run the app locally, the user can run the code through RStudio or run
the following command in their shell:

    R -e "shiny::runApp(port=3838)"

After running the command, the user can open `http://127.0.0.1:3838` in
their web browser to open the app.

## Deploying to ShinyApps.io

First, the user should create a ShinyApps account. The user can follow
the instructions to install rsconnect and log in with their credentials.

Users should make sure to create their EDP app and set up their
.Renviron file (as shown in the section above) before deploying.

To deploy, the user can open R in the app’s directory and run:

    library(rsconnect)
    deployApp()

This may take a few minutes, and should automatically open up the user’s
browser to the app URL.

## Deploying to Heroku

First, the user should create a Heroku account. Deploying to Heroku
requires a special buildpack that supports R and Shiny, so the user will
need to create the app using the Heroku command line tools.

The custom buildpack needs the following files:

- Aptfile: contains additional system dependencies
- run.R: signals to Heroku that this is an R Shiny app
- init.R: install additional R dependencies

First, the user should create their app on Heroku:

    heroku create --buildpack http://github.com/virtualstaticvoid/heroku-buildpack-r.git#heroku-16

Once their app is created, the user should set up the following
environment variables:

    # Sets EDP app's client ID
    heroku config:set CLIENT_ID=<your client id>

    # Sets app's public URL (e.g. `https://<APP NAME>.herokuapp.com`)
    heroku config:set APP_URL=https://<your app>.herokuapp.com

Finally, the user can deploy the app:

`git push heroku master`

Note: The first deploy can take upwards of 20 minutes to complete.

## Applications Endpoints

This API reference is organized by resource type and endpoint. Each
resource type has one or more data representations and one or more
methods. Methods do not accept URL parameters or request bodies unless
specified. Please note that if your EDP endpoint is
sponsor.edp.aws.quartz.bio, you would use
sponsor.api.edp.aws.quartz.bio.

| Method |                 HTTP Request                  |      Description       |                                    Authorization                                     |                       Response                       |
|:------:|:---------------------------------------------:|:----------------------:|:------------------------------------------------------------------------------------:|:----------------------------------------------------:|
| create | POST `https://<EDP_API_HOST>/v2/applications` | Create an application. | This request requires an authorized user with permission to create new applications. | The response contains a single Application resource. |

|   Property    |     Value     |                              Description                              |
|:-------------:|:-------------:|:---------------------------------------------------------------------:|
|     name      |    string     |              (required) A user-visible name for the app.              |
| redirect_uris |    string     | (required) A list of space-separated valid redirection endpoint URIs. |
|  description  |    string     |                A user-friendly description of the app.                |
|   help_url    |    string     |        The URL where documentation about the app can be found.        |
|    scopes     |    string     |    OAuth2 scopes are required to use the app (read or read write).    |
|  source_url   |    string     |           The URL where the app’s source code can be found.           |
|     tags      | string (list) |            A list of arbitrary tags to categorize the app.            |
|    web_url    |    string     |            The URL where the app can be accessed by users.            |

| Method |                        HTTP Request                         |      Description       |                                       Authorization                                        |                      Response                       |
|:------:|:-----------------------------------------------------------:|:----------------------:|:------------------------------------------------------------------------------------------:|:---------------------------------------------------:|
| delete | DELETE `https://<EDP_API_HOST>/v2/applications/{CLIENT_ID}` | Delete an application. | This request requires an authorized user with permission to modify the target application. | The response returns “HTTP 200 OK” when successful. |

| Method |                       HTTP Request                       |               Description               |                                      Authorization                                       |                    Response                    |
|:------:|:--------------------------------------------------------:|:---------------------------------------:|:----------------------------------------------------------------------------------------:|:----------------------------------------------:|
|  get   | GET `https://<EDP_API_HOST>/v2/applications/{CLIENT_ID}` | Retrieve metadata about an application. | This request requires an authorized user with permission to view the target application. | The response contains an Application resource. |

| Method |                          HTTP Request                           |              Description              |                                             Authorization                                             |                                         Response                                          |
|:------:|:---------------------------------------------------------------:|:-------------------------------------:|:-----------------------------------------------------------------------------------------------------:|:-----------------------------------------------------------------------------------------:|
| secret | GET `https://<EDP_API_HOST>/v2/applications/{CLIENT_ID}/secret` | Retrieve an application’s secret key. | This request requires an authorized user with permission to view the target application’s secret key. | The response contains an Application resource with an additional client_secret attribute. |
