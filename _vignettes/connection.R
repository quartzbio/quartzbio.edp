## ---- include = FALSE, echo = FALSE, message =  FALSE, warning=FALSE----------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)
withr:::defer({Sys.unsetenv('EDP_PROFILE')}, parent.frame(n=2))

## -----------------------------------------------------------------------------

# by default all functions will use the default profile set in the default config file
library(quartzbio.edp)
User()
vlst <- Vaults()
vlst[[1]]

flds <- Folders()
flds[[1]]

fis  <- Files()
fis[[1]]

das  <-Datasets()
das[[1]]


## -----------------------------------------------------------------------------

# use the default profile
User()

# use explicitely the default profile
conn <- connect_with_profile()
User(conn)

# use  profile named demo-corp defined in the default config file without
# changing the current connection
conn <- connect_with_profile('demo-corp')
User(conn)
Vaults(conn = conn)

# still using the default profile
# because no explicit profile connection is given in argument
Vaults()


## ---- include = FALSE, echo = FALSE, message =  FALSE, warning=FALSE----------
  # usnet connection for next block
  set_connection(NULL)

## -----------------------------------------------------------------------------
# set the demo-corp connection as the default for future connections

Sys.getenv('EDP_PROFILE')
Sys.setenv(EDP_PROFILE = 'demo-corp')
User()


## -----------------------------------------------------------------------------
conn <- read_connection_profile('default')
secret <- conn$secret
host <- conn$host
conn <- connect(secret, host)
User(conn)


## -----------------------------------------------------------------------------
# auto connect use the EDP profile to set the current connection
Sys.setenv(EDP_PROFILE = 'demo-corp')
conn <- autoconnect()
User(conn = conn)
User()


# unset the EDP_PROFILE environment variable
# autoconnect() use the default settings.
Sys.unsetenv('EDP_PROFILE') # unset current profile environment variables
set_connection(NULL) # unset current connection

conn <- autoconnect()

# Will used the default profile
User(conn=conn)
User()


## -----------------------------------------------------------------------------

# explicitely set the connection with a profile
set_connection( connect_with_profile('demo-corp'))

# remove the current connection
set_connection(NULL)

# the firt call to User() sets the current default connection to the default connection
# both calls will use the current connection

User()
User(conn = get_connection())

# the current connection remains the 'default'
# connecting with a profile did not change it
conn_corp <- connect_with_profile('demo-corp')
User(conn_corp)
User()

# the current connection will be the 'demo-corp' one 
# after unsetting the previous connection and profile environment variables
Sys.setenv(EDP_PROFILE = 'demo-corp')
set_connection(NULL)
User()


