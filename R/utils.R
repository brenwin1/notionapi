#' Create empty property configuration
#' @description
#' Helper function that creates an empty named list for property configurations
#' that require no additional settings.
#'
#' Many [database properties](https://developers.notion.com/reference/property-object) like text, checkbox and date
#' do not need configuration settings.
#' This function returns the empty configuration (`{}` in JSON)
#' that these properties expect.
#' @return An empty `named list` that serialises to `{}` in JSON
#' @export
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

vcr_example_start <- function(name) {
  vcr::insert_example_cassette(
    name,
    "notionapi",
    "none", # only use existing cassettes
    c("method", "path")
  )
}

vcr_example_end <- function() {
  vcr::eject_cassette()
}
