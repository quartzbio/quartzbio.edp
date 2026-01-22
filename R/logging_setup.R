#' Configure log file and set the log-level
#'
#' Setup the  log record appender function for the file provided
#' @param log_file Path to the file to log records
#' @param log_level Set log level. Default is set to INFO. Available levels: FATAL, ERROR, WARN, INFO, DEBUG
#' @return The log file, if logging file is configured successfully,
#' `"console"` if logging defaults to console or `NULL` if logging is disabled (due to invalid path or missing logger package).
#' @export
configure_logger <- function(log_file, log_level = "INFO") {
  if (!requireNamespace("logger", quietly = TRUE)) {
    warning("The 'logger' package is not installed. Logging will be disabled.")
    invisible(NULL)
  } else {
    logger::log_threshold(log_level)

    if (!is.null(log_file) && length(log_file) == 1 && is.character(log_file)) {
      logger::log_appender(logger::appender_file(log_file)) # Write log in file
      invisible(log_file)
    } else {
      warning("Invalid file path for log file. Defaulting to console logging")
      logger::log_appender(logger::appender_console)
      invisible("console")
    }
  }
}


#' Record a log message with the given log level
#'
#' Add log messages with the given log level
#' @param level log level Available levels: FATAL, ERROR, WARN, INFO, DEBUG
#' @param content message to be logged
#' @examples
#' \dontrun{
#' log_message("INFO", "This is a info message")
#' log_message("WARN", "This is a warning")
#' log_message("ERROR", "This is an error")
#' log_message("FATAL", "this is a fatal message")
#' log_message("DEBUG", "this is a debug")
#' }
#' @export
log_message <- function(level, content) {
  if (requireNamespace("logger", quietly = TRUE)) {
    if (level == "INFO") {
      logger::log_info(content)
    } else if (level == "WARN") {
      logger::log_warn(content)
    } else if (level == "ERROR") {
      logger::log_error(content)
    } else if (level == "FATAL") {
      logger::log_fatal(content)
    } else if (level == "DEBUG") {
      logger::log_debug(content)
    } else {
      message("Invalid log level, INFO used instead")
      logger::log_info(content)
    }
  } else {
    if (level == "INFO" || level == "DEBUG") {
      message(level, ": ", content)
    } else if (level == "WARN") {
      warning("WARNING: ", content)
    } else if (level == "ERROR" || level == "FATAL") {
      warning(level, ": ", content)
    } else {
      message("Invalid log level, INFO used instead")
      message("INFO: ", content)
    }
  }
}


#' edp_health_check
#'
#' Provides quick health check to test your EDP connection and retrieves user details and vaults
#' @param get_vault_list Get the vault list created by the user
#' @export
edp_health_check <- function(get_vault_list = FALSE) {
  if (!requireNamespace("cli", quietly = TRUE)) {
    stop("The 'cli' package is required for this function, but not installed.")
  }

  # Check if the access token is valid and check Connection

  cli::cli_h2("EDP Connection Check")
  conn <- autoconnect(check = TRUE)

  cli::cli_text("EDP Connection established successfully")

  # Get user details

  cli::cli_h2("EDP User")
  current_user <- User(conn)
  cli::cli_text(
    "EDP user {current_user$full_name} {current_user$username}. Role: {current_user$role}"
  )

  # Fetch user's vaults

  if (get_vault_list) {
    cli::cli_h2("Fetching Vault List")
    fetch_vaults.User(current_user, conn)
  }
}
