assert_api_key <- function() {
  skip_unless_api_key()
}

skip_unless_api_key <- function() {
  if (!quartzbio.edp:::.is_nz_string(Sys.getenv("EDP_API_SECRET"))) skip("EDP EDP_API_SECRET key not set")
}
