#' Create empty property configuration
#' @description
#' Helper function that creates an empty named list for property configurations
#' that require no additional settings.
#'
#' Many [database properties](https://developers.notion.com/reference/property-object) like text, checkbox and date
#' do not need configuration settings.
#' This function returns the empty configuration (`{}` in JSON)
#' that these properties expect.
#' @returns An empty `named list` that serialises to `{}` in JSON
#' @export
#'
#' @examplesIf notion_token_exists()
#' notion <- notion_client()
#' \dontshow{notionapi::vcr_example_start("notion-data-sources-create")}
#' # ----- Create a data source
#' notion$data_sources$create(
#'   list(
#'     database_id = "5f9759b2-ad71-4b66-880f-d0306614227b"
#'   ),
#'   properties = list(
#'     Title = list(
#'       title = no_config()
#'     )
#'   ),
#'   title = list(list(
#'     text = list(
#'       content = "Test data source"
#'     )
#'   ))
#' )
#' \dontshow{notionapi::vcr_example_end()}
no_config <- function() {
  set_names(list(), character())
}

drop_named_nulls <- function(x) {
  null <- vapply(
    x,
    is.null,
    logical(1)
  )

  x[!null]
}

# as seen in `purrr`, with the name `has_names()`
has_name <- function(x) {
  nms <- names(x)

  if (is.null(nms)) {
    rep_len(FALSE, length(x))
  } else {
    !(is.na(nms) | nms == "")
  }
}

has_names <- function(x) {
  all(has_name(x))
}

decode_query_param <- function(param_value) {
  utils::URLdecode(param_value)
}

#' VCR Example Helpers
#'
#' Internal functions for managing VCR cassettes in package examples.
#' These functions are not intended for direct use by package users.
#'
#' @param name Character. The name of the cassette to be used.
#' @keywords internal
#' @name vcr_example_helpers
NULL

#' @rdname vcr_example_helpers
#' @export
vcr_example_start <- function(name) {
  vcr::insert_example_cassette(
    name,
    "notionapi",
    "none", # only use existing cassettes
    c("method", "path")
  )
}

#' @rdname vcr_example_helpers
#' @export
vcr_example_end <- function() {
  vcr::eject_cassette()
}

is_testing <- function() {
  identical(Sys.getenv("TESTTHAT"), "true")
}
