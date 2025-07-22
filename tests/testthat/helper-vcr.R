library("vcr") # *Required* as vcr is set up on loading

vcr_dir <- system.file("_vcr", package = "notionapi")

invisible(
  vcr::vcr_configure(
    dir = vcr_dir
  )
)

if (!nzchar(Sys.getenv("NOTION_TOKEN"))) {
  if (dir.exists(vcr_dir)) {
    Sys.setenv("NOTION_TOKEN" = "foo")
  } else {
    stop("No API key nor cassettes, tests cannot be run.", call. = FALSE)
  }
}
