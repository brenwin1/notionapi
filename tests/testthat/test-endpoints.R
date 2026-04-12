# Set up --------------------------------------------------

test_page_title <- "Test Page for notionapi"

test_ids <- list(
  page_id = "22f33ea0c1e480b99c77d1ab72aedff9",
  user_id = "fda12729-108d-4eb5-bbfb-a8f0886794d1", # use `notion$users$list()` to retrieve your user ID
  # populated during test
  created_page_id = NULL,
  created_block_id = NULL,
  created_database_id = NULL,
  created_property_id = NULL,
  created_database_page_id = NULL,
  created_data_source_id = NULL,
  created_view_id = NULL,
  created_comment_id = NULL
)

# Validation --------------------------------------------------

test_that("Invalid input types trigger validation errors", {
  notion <- notion_client()

  # `check_string()`
  expect_error(
    notion$search(""),
    class = "notionapi_validation_error"
  )

  # `check_json_object()`
  expect_error(
    object = notion$search(
      "something",
      "not quite an JSON object"
    ),
    class = "notionapi_validation_error"
  )

  # `check_int()`
  expect_error(
    notion$search("something", page_size = "a string"),
    class = "notionapi_validation_error"
  )

  # `check_json_array()`
  expect_error(
    notion$comments$create(
      list(page_id = "5c6a28216bb14a7eb6e1c50111515c3d"),
      rich_text = list("not quite an JSON array")
    ),
    class = "notionapi_validation_error"
  )

  # `check_bool`
  expect_error(
    notion$blocks$update(test_ids[["page_id"]], "not a bool"),
    class = "notionapi_validation_error"
  )
})

test_that("Missing required arguments trigger validation errors", {
  notion <- notion_client()

  # `check_string`
  expect_error(
    notion$blocks$children$append(),
    class = "notionapi_validation_error"
  )

  # `check_json_array`
  expect_error(
    notion$blocks$children$append(block_id = test_ids[["page_id"]]),
    class = "notionapi_validation_error"
  )

  # `check_json_object`
  expect_error(
    notion$databases$create(),
    class = "notionapi_validation_error"
  )
})

# API Error --------------------------------------------------

test_that("API errors have correct error class", {
  notion <- notion_client()

  vcr::local_cassette("api-error-404")

  expect_error(
    object = notion$blocks$retrieve(
      block_id = "12345ea0c1e4808c95d2c6b376c4fe2f" # non-existent
    ),
    class = "notionapi_api_error"
  )
})

test_that("API error messages are formatted properly", {
  notion <- notion_client()

  vcr::local_cassette("api-error-404")

  expect_snapshot(
    notion$blocks$retrieve(block_id = "12345ea0c1e4808c95d2c6b376c4fe2f"), # non-existent
    error = TRUE
  )
})

test_that("API error multiline messages are formatted properly", {
  notion <- notion_client()

  vcr::local_cassette("api-error-400-validation-multiline")

  expect_snapshot(
    notion$comments$create(
      list(list(
        tetx = list(
          content = "hello world"
        )
      )),
      list(
        page_id = test_ids[["page_id"]]
      )
    ),
    error = TRUE
  )
})

test_that("Authentication error are handled", {
  notion <- notion_client("invalid_token")

  vcr::local_cassette("api-error-401-unauthorized")

  expect_error(
    notion$users$me(),
    class = "notionapi_api_error"
  )
})

# Endpoints properly initialised --------------------------------------------------

test_that("Endpoints properly initialised", {
  notion <- notion_client()

  expect_r6_class(notion$blocks, "BlocksEndpoint")
  expect_r6_class(notion$blocks$children, "BlocksChildrenEndpoint")
  expect_r6_class(notion$pages, "PagesEndpoint")
  expect_r6_class(notion$pages$properties, "PagesPropertiesEndpoint")
  expect_r6_class(notion$databases, "DatabasesEndpoint")
  expect_r6_class(notion$data_sources, "DataSourcesEndpoint")
  expect_r6_class(notion$views, "ViewsEndpoint")
  expect_r6_class(notion$views$queries, "ViewsQueriesEndpoint")
  expect_r6_class(notion$file_uploads, "FileUploadsEndpoint")
  expect_r6_class(notion$comments, "CommentsEndpoint")
  expect_r6_class(notion$users, "UsersEndpoint")
  expect_r6_class(notion$custom_emojis, "CustomEmojisEndpoint")

  # NotionClient direct method
  expect_type(notion$search, "closure")
})

# Test Endpoints using a sequential workflow --------------------------------------------------

test_that("notion$pages$create() works", {
  notion <- notion_client()

  vcr::local_cassette("notion-pages-create")

  resp <- notion$pages$create(
    list(page_id = test_ids[["page_id"]]),
    list(
      title = list(list(
        text = list(
          content = test_page_title
        )
      ))
    )
  )

  expect_s3_class(resp, "notion_response")
  expect_type(resp, "list")
  expect_equal(resp[["object"]], "page")

  test_ids[["created_page_id"]] <<- resp[["id"]]
})

test_that("notion$pages$retrieve() works", {
  notion <- notion_client()

  vcr::local_cassette("notion-pages-retrieve")

  resp <- notion$pages$retrieve(test_ids[["created_page_id"]])

  expect_s3_class(resp, "notion_response")
  expect_type(resp, "list")
  expect_equal(resp[["object"]], "page")
})

test_that("notion$pages$update() works", {
  notion <- notion_client()

  vcr::local_cassette("notion-pages-update")

  resp <- notion$pages$update(
    test_ids[["created_page_id"]],
    icon = list(
      icon = list(
        name = "pizza",
        color = "blue"
      )
    )
  )

  expect_s3_class(resp, "notion_response")
  expect_type(resp, "list")
  expect_equal(resp[["object"]], "page")
  expect_gt(length(resp[["icon"]]), 0)
})

test_that("can send explicit JSON null", {
  notion <- notion_client()

  vcr::local_cassette("notion-pages-update-null")

  resp <- notion$pages$update(
    test_ids[["created_page_id"]],
    icon = NA
  )

  expect_s3_class(resp, "notion_response")
  expect_type(resp, "list")
  expect_equal(resp[["object"]], "page")
  expect_null(resp[["icon"]])
})

test_that("notion$blocks$children$append() works", {
  notion <- notion_client()

  vcr::local_cassette("notion-blocks-children-append")

  resp <- notion$blocks$children$append(
    test_ids[["created_page_id"]],
    list(
      # add a level 2 heading called "Test Heading"
      list(
        object = "block",
        heading_2 = list(
          rich_text = list(list(
            text = list(content = "Test Heading")
          ))
        )
      )
    ),
    position = list(type = "start")
  )

  expect_s3_class(resp, "notion_response")
  expect_type(resp, "list")
  expect_equal(resp[["object"]], "list")

  test_ids[["created_block_id"]] <<- resp[["results"]][[1]][["id"]]
})

test_that("notion$blocks$children$list() works", {
  notion <- notion_client()

  vcr::local_cassette("notion-blocks-children-list")

  resp <- notion$blocks$children$list(
    test_ids[["created_page_id"]]
  )

  expect_s3_class(resp, "notion_response")
  expect_type(resp, "list")
  expect_equal(resp[["object"]], "list")
  expect_gt(length(resp[["results"]]), 0)
})

test_that("notion$blocks$retrieve() works", {
  notion <- notion_client()

  vcr::local_cassette("notion-blocks-retrieve")

  resp <- notion$blocks$retrieve(test_ids[["created_block_id"]])

  expect_s3_class(resp, "notion_response")
  expect_type(resp, "list")
  expect_equal(resp[["object"]], "block")
})

test_that("notion$blocks$update() works", {
  notion <- notion_client()

  vcr::local_cassette("notion-blocks-update")

  resp <- notion$blocks$update(
    test_ids[["created_block_id"]],
    heading_2 = list(
      rich_text = list(list(
        text = list(
          content = "Updated Test Heading"
        )
      ))
    )
  )

  expect_s3_class(resp, "notion_response")
  expect_type(resp, "list")
  expect_equal(resp[["id"]], test_ids[["created_block_id"]])
})

test_that("notion$pages$retrieve_markdown() works", {
  notion <- notion_client()

  vcr::local_cassette("notion-pages-retrieve-markdown")

  resp <- notion$pages$retrieve_markdown(
    test_ids[["created_page_id"]]
  )

  expect_s3_class(resp, "notion_response")
  expect_type(resp, "list")
  expect_equal(resp[["object"]], "page_markdown")
})

test_that("notion$pages$update_markdown() works", {
  notion <- notion_client()

  vcr::local_cassette("notion-pages-update-markdown")

  resp <- notion$pages$update_markdown(
    test_ids[["created_page_id"]],
    "replace_content",
    replace_content = list(
      new_str = '## Updated Test Heading\nUsed markdown{color="blue"}'
    )
  )

  expect_s3_class(resp, "notion_response")
  expect_type(resp, "list")
  expect_equal(resp[["object"]], "page_markdown")
})

test_that("notion$databases$create() works", {
  notion <- notion_client()

  vcr::local_cassette(name = "notion-databases-create")

  resp <- notion$databases$create(
    list(
      type = "page_id",
      page_id = test_ids[["page_id"]]
    ),
    title = list(list(
      text = list(
        content = "Test Database"
      )
    ))
  )

  expect_s3_class(resp, "notion_response")
  expect_type(resp, "list")
  expect_equal(resp[["object"]], "database")

  test_ids[["created_database_id"]] <<- resp[["id"]]
})

test_that("notion$databases$retrieve() works", {
  notion <- notion_client()
  vcr::local_cassette("notion-databases-retrieve")

  resp <- notion$databases$retrieve(
    test_ids[["created_database_id"]]
  )

  expect_s3_class(resp, "notion_response")
  expect_type(resp, "list")
  expect_equal(resp[["object"]], "database")
})

test_that("notion$databases$update() works", {
  notion <- notion_client()

  vcr::local_cassette("notion-database-update")

  resp <- notion$databases$update(
    test_ids[["created_database_id"]],
    description = list(list(
      text = list(
        content = "For testing purposes"
      )
    )),
    icon = list(
      icon = list(
        name = "calendar",
        color = "gray"
      )
    )
  )

  expect_s3_class(resp, "notion_response")
  expect_type(resp, "list")
  expect_equal(resp[["object"]], "database")
})

test_that("notion$data_sources$create() works", {
  notion <- notion_client()

  vcr::local_cassette("notion-data-sources-create")

  resp <- notion$data_sources$create(
    list(
      database_id = test_ids[["created_database_id"]]
    ),
    properties = list(
      Title = list(
        title = no_config()
      )
    ),
    title = list(list(
      text = list(
        content = "Test data source"
      )
    ))
  )

  expect_s3_class(resp, "notion_response")
  expect_type(resp, "list")
  expect_equal(resp[["object"]], "data_source")

  test_ids[["created_data_source_id"]] <<- resp[["id"]]
})

test_that("notion$data_sources$update() works", {
  notion <- notion_client()

  vcr::local_cassette("notion-data-sources-update")

  resp <- notion$data_sources$update(
    test_ids[["created_data_source_id"]],
    properties = list(
      Status = list(
        status = list(
          options = list(
            list(
              name = "To do",
              color = "red"
            ),
            list(
              name = "Done",
              color = "green"
            )
          )
        )
      )
    )
  )

  expect_s3_class(resp, "notion_response")
  expect_type(resp, "list")
  expect_equal(resp[["object"]], "data_source")
})

test_that("notion$data_sources$retrieve works", {
  notion <- notion_client()

  vcr::local_cassette("notion-data-sources-retrieve")

  resp <- notion$data_sources$retrieve(
    test_ids[["created_data_source_id"]]
  )

  expect_s3_class(resp, "notion_response")
  expect_type(resp, "list")
  expect_equal(resp[["object"]], "data_source")

  test_ids[["created_property_id"]] <<- resp$properties[["Status"]][["id"]]
})

test_that("notion$data_sources$list_templates() works", {
  notion <- notion_client()

  vcr::local_cassette("notion-data-sources-list-templates")

  resp <- notion$data_sources$list_templates(
    test_ids[["created_data_source_id"]]
  )

  expect_s3_class(resp, "notion_response")
  expect_type(resp, "list")
  expect_contains(names(resp), c("templates", "has_more"))
})

test_that("notion$pages$move() works", {
  notion <- notion_client()

  vcr::local_cassette("notion-pages-move")

  resp <- notion$pages$move(
    test_ids[["created_page_id"]],
    list(
      data_source_id = test_ids[["created_data_source_id"]]
    )
  )

  expect_s3_class(resp, "notion_response")
  expect_type(resp, "list")
  expect_equal(resp[["object"]], "page")
})

test_that("notion$pages$properties$retrieve works", {
  notion <- notion_client()
  vcr::local_cassette("notion-pages-properties-retrieve")

  resp <- notion$pages$properties$retrieve(
    test_ids[["created_page_id"]],
    test_ids[["created_property_id"]]
  )

  expect_s3_class(resp, "notion_response")
  expect_type(resp, "list")
  expect_equal(resp[["object"]], "property_item")
})

test_that("notion$data_sources$query works", {
  notion <- notion_client()

  vcr::local_cassette("notion-data-sources-query")

  resp <- notion$data_sources$query(
    test_ids[["created_data_source_id"]],
    filter = list(
      property = "Status",
      status = list(
        equals = "To do"
      )
    )
  )

  expect_s3_class(resp, "notion_response")
  expect_type(resp, "list")
  expect_equal(resp[["object"]], "list")
})

test_that("notion$views$create() works", {
  notion <- notion_client()

  vcr::local_cassette(name = "notion-views-create")

  resp <- notion$views$create(
    test_ids[["created_data_source_id"]],
    "Test view",
    "table",
    test_ids[["created_database_id"]],
  )

  expect_s3_class(resp, "notion_response")
  expect_type(resp, "list")
  expect_equal(resp[["object"]], "view")

  test_ids[["created_view_id"]] <<- resp[["id"]]
})

test_that("notion$views$retrieve() works", {
  notion <- notion_client()

  vcr::local_cassette("notion-views-retrieve")

  resp <- notion$views$retrieve(
    test_ids[["created_view_id"]]
  )

  expect_s3_class(resp, "notion_response")
  expect_type(resp, "list")
  expect_equal(resp[["object"]], "view")
})

test_that("notion$views$list() works", {
  notion <- notion_client()

  vcr::local_cassette("notion-views-list")

  resp <- notion$views$list(
    data_source_id = test_ids[["created_data_source_id"]]
  )

  expect_s3_class(resp, "notion_response")
  expect_type(resp, "list")
  expect_equal(resp[["object"]], "list")
  expect_gt(length(resp[["results"]]), 0)
})

test_that("notion$views$update() works", {
  notion <- notion_client()

  vcr::local_cassette("notion-views-update")

  resp <- notion$views$update(
    test_ids[["created_view_id"]],
    "Updated view name"
  )

  expect_s3_class(resp, "notion_response")
  expect_type(resp, "list")
  expect_equal(resp[["object"]], "view")
})

test_that("notion$views$queries$create() works", {
  notion <- notion_client()

  vcr::local_cassette("notion-views-queries-create")

  resp <- notion$views$queries$create(
    test_ids[["created_view_id"]]
  )

  expect_s3_class(resp, "notion_response")
  expect_type(resp, "list")
  expect_equal(resp[["object"]], "view_query")

  test_ids[["query_id"]] <<- resp[["id"]]
})

test_that("notion$views$queries$results() works", {
  notion <- notion_client()

  vcr::local_cassette("notion-views-queries-results")

  resp <- notion$views$queries$results(
    test_ids[["created_view_id"]],
    test_ids[["query_id"]]
  )

  expect_s3_class(resp, "notion_response")
  expect_type(resp, "list")
  expect_equal(resp[["object"]], "list")
})

test_that("notion$views$queries$delete() works", {
  notion <- notion_client()

  vcr::local_cassette("notion-views-queries-delete")

  resp <- notion$views$queries$delete(
    test_ids[["created_view_id"]],
    test_ids[["query_id"]]
  )

  expect_s3_class(resp, "notion_response")
  expect_type(resp, "list")
  expect_equal(resp[["object"]], "view_query")
})

testthat::test_that("notion$views$delete works", {
  notion <- notion_client()

  vcr::local_cassette("notion-views-delete")

  resp <- notion$views$delete(test_ids[["created_view_id"]])

  expect_s3_class(resp, "notion_response")
  expect_type(resp, "list")
  expect_equal(resp[["object"]], "view")
})

test_that("notion$search works", {
  notion <- notion_client()

  vcr::local_cassette("notion-search")

  resp <- notion$search(
    query = test_page_title,
    page_size = 1,
    filter = list(
      property = "object",
      value = "page"
    ),
    sort = list(
      timestamp = "last_edited_time",
      direction = "descending"
    )
  )

  expect_s3_class(resp, "notion_response")
  expect_type(resp, "list")
  expect_equal(resp[["object"]], "list")
})

test_that("notion$comments$create works", {
  notion <- notion_client()

  vcr::local_cassette("notion-comments-create")

  resp <- notion$comments$create(
    parent = list(
      page_id = test_ids[["created_page_id"]]
    ),
    rich_text = list(
      list(
        text = list(
          content = "Hello world!"
        )
      )
    )
  )

  expect_s3_class(resp, "notion_response")
  expect_type(resp, "list")
  expect_equal(resp[["object"]], "comment")

  test_ids[["created_comment_id"]] <<- resp[["id"]]
})

test_that("notion$comments$retrieve works", {
  notion <- notion_client()

  vcr::local_cassette("notion-comments-retrieve")

  resp <- notion$comments$retrieve(
    test_ids[["created_comment_id"]]
  )

  expect_s3_class(resp, "notion_response")
  expect_type(resp, "list")
  expect_equal(resp[["object"]], "comment")
})

test_that("notion$comments$list works", {
  notion <- notion_client()

  vcr::local_cassette("notion-comments-list")

  resp <- notion$comments$list(
    test_ids[["created_page_id"]]
  )

  expect_s3_class(resp, "notion_response")
  expect_type(resp, "list")
  expect_equal(resp[["object"]], "list")
})

# clean up
test_that("notion$blocks$delete works", {
  notion <- notion_client()

  vcr::local_cassette("notion-blocks-delete")

  resp <- notion$blocks$delete(
    test_ids[["created_block_id"]]
  )

  expect_s3_class(resp, "notion_response")
  expect_type(resp, "list")
  expect_equal(resp[["object"]], "block")
})

test_that("can update a page to trash", {
  notion <- notion_client()

  vcr::local_cassette("notion-pages-trash")

  resp <- notion$pages$update(
    test_ids[["created_page_id"]],
    in_trash = TRUE
  )

  expect_s3_class(resp, "notion_response")
  expect_type(resp, "list")
  expect_equal(resp[["object"]], "page")
})

test_that("can delete a database", {
  notion <- notion_client()

  vcr::local_cassette("notion-database-delete")

  resp <- notion$databases$update(
    test_ids[["created_database_id"]],
    in_trash = TRUE
  )

  expect_s3_class(resp, "notion_response")
  expect_type(resp, "list")
  expect_equal(resp[["object"]], "database")
})

# Test Endpoints outside sequential workflow --------------------------------------------------

test_that("notion$users$list() works", {
  notion <- notion_client()
  vcr::local_cassette("notion-users-list")

  resp <- notion$users$list()

  expect_s3_class(resp, "notion_response")
  expect_type(resp, "list")
  expect_equal(resp[["object"]], "list")
})

test_that("notion$users$retrieve() works", {
  notion <- notion_client()
  vcr::local_cassette("notion-users-retrieve")

  resp <- notion$users$retrieve(test_ids[["user_id"]])

  expect_s3_class(resp, "notion_response")
  expect_type(resp, "list")
  expect_equal(resp[["object"]], "user")
  expect_equal(resp[["id"]], test_ids[["user_id"]])
})

test_that("notion$users$me() works", {
  notion <- notion_client()
  vcr::local_cassette("notion-users-me")

  resp <- notion$users$me()

  expect_s3_class(resp, "notion_response")
  expect_type(resp, "list")
  expect_equal(resp[["object"]], "user")
})

test_that("can upload using single-part mode", {
  notion <- notion_client()

  vcr::local_cassette(
    "notion-file-uploads-single-part",
    match_requests_on = c("method", "uri")
  )

  resp <- notion$file_uploads$create(
    "single_part"
  )
  file_upload_id <- resp[["id"]]

  expect_s3_class(resp, "notion_response")
  expect_type(resp, "list")
  expect_equal(resp[["object"]], "file_upload")
  expect_equal(resp[["status"]], "pending")

  test_file <- test_path("test.pdf")

  raw <- readBin(test_file, "raw", file.size(test_file))

  resp <- notion$file_uploads$send(
    file_upload_id,
    list(
      filename = basename(test_file),
      data = raw
    )
  )

  expect_s3_class(resp, "notion_response")
  expect_type(resp, "list")
  expect_equal(resp[["object"]], "file_upload")
  expect_equal(resp[["status"]], "uploaded")

  resp <- notion$file_uploads$retrieve(
    file_upload_id
  )

  expect_s3_class(resp, "notion_response")
  expect_type(resp, "list")
  expect_equal(resp[["object"]], "file_upload")
})

test_that("can upload using multi-part mode", {
  notion <- notion_client()

  vcr::local_cassette(
    "notion-file-uploads-multi-part",
    match_requests_on = c("method", "uri")
  )

  raw <- as.raw(
    rep(65L, 11 * 1024 * 1024)
  )

  mid <- base::ceiling(
    length(raw) / 2
  )

  parts <- list(
    raw[seq_len(mid)],
    raw[seq(mid + 1L, length(raw))]
  )

  resp <- notion$file_uploads$create(
    "multi_part",
    "test-large.txt",
    number_of_parts = 2L
  )
  file_upload_id <- resp[["id"]]

  expect_s3_class(resp, "notion_response")
  expect_type(resp, "list")
  expect_equal(resp[["object"]], "file_upload")
  expect_equal(resp[["status"]], "pending")

  for (i in seq_along(parts)) {
    resp <- notion$file_uploads$send(
      file_upload_id,
      list(
        filename = "test-large.txt",
        data = parts[[i]]
      ),
      as.character(i)
    )

    expect_s3_class(resp, "notion_response")
    expect_equal(resp[["object"]], "file_upload")
    expect_equal(resp[["status"]], "pending")
  }

  resp <- notion$file_uploads$complete(
    file_upload_id
  )

  expect_s3_class(resp, "notion_response")
  expect_type(resp, "list")
  expect_equal(resp[["object"]], "file_upload")
  expect_equal(resp[["status"]], "uploaded")
  expect_equal(resp[["filename"]], "test-large.txt")

  resp <- notion$file_uploads$retrieve(
    file_upload_id
  )

  expect_s3_class(resp, "notion_response")
  expect_type(resp, "list")
  expect_equal(resp[["object"]], "file_upload")
})

test_that("can upload files from an external URL", {
  notion <- notion_client()

  vcr::local_cassette(
    "notion-file-uploads-external-url",
    match_requests_on = c("method", "uri")
  )

  resp <- notion$file_uploads$create(
    "external_url",
    "dummy.pdf",
    "application/pdf",
    external_url = "https://github.com/brenwin1/notionapi/blob/dev/tests/testthat/test.pdf"
  )

  expect_s3_class(resp, "notion_response")
  expect_type(resp, "list")
  expect_equal(resp[["object"]], "file_upload")
})

test_that("notion$file_uploads$list() works", {
  notion <- notion_client()

  vcr::local_cassette("notion-file-uploads-list")

  resp <- notion$file_uploads$list()

  expect_s3_class(resp, "notion_response")
  expect_type(resp, "list")
  expect_equal(resp[["object"]], "list")
})

test_that("notion$custom_emojis$list works", {
  notion <- notion_client()

  vcr::local_cassette("notion-custom-emojis-list")

  resp <- notion$custom_emojis$list()

  expect_s3_class(resp, "notion_response")
  expect_type(resp, "list")
  expect_equal(resp[["object"]], "list")
})
