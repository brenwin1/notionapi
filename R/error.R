# Error helpers --------------------------------------------------

#' Create standardised notionapi errors
#'
#' @noRd
#' @keywords internal
notionapi_error <- function(
  message,
  class = NULL,
  call = caller_env(),
  .envir = caller_env(),
  ...
) {
  cli::cli_abort(
    message,
    call = call,
    class = c(class, "notionapi_error"),
    .envir = .envir
  )
}
