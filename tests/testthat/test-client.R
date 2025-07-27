test_that("notion_client() creates a valid client", {
  notion <- notion_client()

  expect_s3_class(notion, "NotionClient")

  expect_s3_class(notion, "R6")

  expect_s3_class(notion$request(), "httr2_request")

  expect_match(
    notion[["base_url"]],
    "api\\.notion\\.com"
  )

  expect_match(
    notion[["version"]],
    "\\d{4}-\\d{2}-\\d{2}"
  )
})

test_that("Client creation fails without authentication", {
  token <- Sys.getenv("NOTION_TOKEN")
  on.exit(Sys.setenv(NOTION_TOKEN = token))

  Sys.unsetenv("NOTION_TOKEN")
  expect_error(
    notion_client(auth = ""),
    class = "notionapi_auth_error"
  )
})

test_that("async_notion_client creates AsyncNotionClient", {
  async_notion <- async_notion_client()

  expect_s3_class(async_notion, "AsyncNotionClient")
  expect_s3_class(async_notion, "NotionClient") # test inheritance
})

test_that("Async methods return promises", {
  async_notion <- async_notion_client()

  vcr::local_cassette("notion-users-list")

  p <- async_notion$users$list()

  expect_true(
    promises::is.promise(p)
  )
})
