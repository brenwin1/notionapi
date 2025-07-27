test_that("notion_token_exists", {
  original_token <- Sys.getenv("NOTION_TOKEN")
  on.exit(Sys.setenv(NOTION_TOKEN = original_token))

  Sys.setenv(NOTION_TOKEN = "test_token")
  expect_true(notion_token_exists())

  Sys.setenv(NOTION_TOKEN = "")
  expect_false(notion_token_exists())
})
