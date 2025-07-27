test_that("notion_response prints prettily", {
  notion <- notion_client()

  vcr::local_cassette("notion-users-list")

  users <- notion$users$list()

  expect_s3_class(users, "notion_response")
  expect_snapshot({
    print(users)
  })
})
