.onLoad <- function(libname = find.package("quartzbio.edp"), pkgname = "quartzbio.edp") {
    .config$host <- Sys.getenv('SOLVEBIO_API_HOST',
                                 unset='https://api.solvebio.com')
    .config$token <- Sys.getenv('SOLVEBIO_API_KEY', unset='')
    .config$token_type <- 'Token'

    if (nchar(.config$token) == 0L) {
        # No API key, look for access token
        .config$token <- Sys.getenv('SOLVEBIO_ACCESS_TOKEN', unset='')
        if (nchar(.config$token) > 0L) {
            .config$token_type <- 'Bearer'
        }
    }
}
