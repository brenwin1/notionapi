#' Print the result of a Notion API call
#'
#' @param x The result object.
#' @param ... Ignored.
#' @return The JSON result.
#'
#' @importFrom jsonlite toJSON
#' @export
print.notion_response <- function(x, ...) {
  print(jsonlite::toJSON(unclass(x), pretty = TRUE, auto_unbox = TRUE))
}
