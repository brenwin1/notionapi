#' Print the result of a Notion API call
#'
#' @param x The result object.
#' @param ... Ignored.
#' @returns The JSON result.
#'
#' @importFrom jsonlite toJSON
#' @export
print.notion_response <- function(x, ...) {
  print(toJSON(unclass(x), pretty = TRUE, auto_unbox = TRUE))
}
