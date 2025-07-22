# nocov start

.onLoad <- function(libname, pkgname) {
  op <- options()

  op.notionapi <- list(
    notionapi.version = "2022-06-28",
    notionapi.base_url = "https://api.notion.com/v1"
  )

  toset <- !(names(op.notionapi) %in% names(op))

  if (any(toset)) {
    options(
      op.notionapi[toset]
    )
  }
}

## nocov end
