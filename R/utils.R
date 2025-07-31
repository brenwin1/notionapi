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
#'
#' # ----- create a database
#' \dontshow{notionapi:::vcr_example_start("notion-databases-create")}
#' notion$databases$create(
#'   parent = list(page_id = "23933ea0-c1e4-81d6-a6f6-dd5b57ad4aba"),
#'   title = list(
#'     list(
#'       type = "text",
#'       text = list(
#'         content = "Grocery list"
#'       )
#'     )
#'   ),
#'   properties = list(
#'     Name = list(
#'       title = no_config()
#'     ),
#'     `In stock` = list(
#'       checkbox = no_config()
#'     )
#'   )
#' )
#' \dontshow{notionapi:::vcr_example_end()}
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

is_testing <- function() {
  identical(Sys.getenv("TESTTHAT"), "true")
}
