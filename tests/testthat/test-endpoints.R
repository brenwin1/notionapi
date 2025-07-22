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
  created_database_page_id = NULL
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
    notion$databases$query(
      "22833ea0c1e481178e9cf1dcba79dbca",
      filter = list(
        # intentional typo "orr" instead of "or"
        orr = list(list(
          property = "In stock",
          checkbox = list(equals = TRUE)
        ))
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

  expect_s3_class(notion$blocks, "BlocksEndpoint")
  expect_s3_class(notion$blocks$children, "BlocksChildrenEndpoint")
  expect_s3_class(notion$pages, "PagesEndpoint")
  expect_s3_class(notion$pages$properties, "PagesPropertiesEndpoint")
  expect_s3_class(notion$databases, "DatabasesEndpoint")
  expect_s3_class(notion$comments, "CommentsEndpoint")
  expect_s3_class(notion$users, "UsersEndpoint")

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
    )
  )

  expect_s3_class(resp, "notion_response")
  expect_type(resp, "list")
  expect_equal(resp[["object"]], "list")

  test_ids[["created_block_id"]] <<- resp[["results"]][[1]][["id"]]
})

test_that("notion$blocks$children$retrieve() works", {
  notion <- notion_client()

  vcr::local_cassette("notion-blocks-children-retrieve")

  resp <- notion$blocks$children$retrieve(
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
      rich_text = list(
        list(
          text = list(
            content = "Updated Test Heading"
          )
        )
      )
    )
  )

  expect_s3_class(resp, "notion_response")
  expect_type(resp, "list")
  expect_equal(
    resp[["id"]],
    test_ids[["created_block_id"]]
  )
})

test_that("`notion$databases$create()` works", {
  notion <- notion_client()
  vcr::local_cassette("notion-databases-create")

  resp <- notion$databases$create(
    list(page_id = test_ids[["created_page_id"]]),
    list(
      list(
        type = "text",
        text = list(
          content = "Grocery list"
        )
      )
    ),
    list(
      Name = list(
        title = no_config()
      ),
      `In stock` = list(
        checkbox = no_config()
      )
    )
  )

  expect_s3_class(resp, "notion_response")
  expect_type(resp, "list")
  expect_equal(resp[["object"]], "database")

  test_ids[["created_database_id"]] <<- resp[["id"]]
  test_ids[["created_property_id"]] <<- resp[["properties"]][["In stock"]][[
    "id"
  ]]
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

test_that("notion$pages$create() works with a database", {
  notion <- notion_client()

  vcr::local_cassette("notion-pages-create-database")

  resp <- notion$pages$create(
    list(database_id = test_ids[["created_database_id"]]),
    list(
      Name = list(
        title = list(
          list(
            text = list(
              content = "Tuscan Kale"
            )
          )
        )
      ),
      `In stock` = list(
        checkbox = TRUE
      )
    )
  )

  expect_s3_class(resp, "notion_response")
  expect_type(resp, "list")
  expect_equal(resp[["object"]], "page")

  test_ids[["created_database_page_id"]] <<- resp[["id"]]
})

test_that("notion$databases$query() works", {
  notion <- notion_client()
  vcr::local_cassette("notion-database-query")

  resp <- notion$databases$query(
    test_ids[["created_database_id"]],
    filter = list(
      or = list(
        list(
          property = "In stock",
          checkbox = list(equals = TRUE)
        ),
        list(
          property = "Name",
          title = list(contains = "kale")
        )
      )
    ),
    sorts = list(list(
      property = "Name",
      direction = "ascending"
    ))
  )

  expect_s3_class(resp, "notion_response")
  expect_type(resp, "list")
  expect_equal(resp[["object"]], "list")
})

test_that("notion$pages$properties$retrieve works", {
  notion <- notion_client()
  vcr::local_cassette("notion-pages-properties-retrieve")

  resp <- notion$pages$properties$retrieve(
    test_ids[["created_database_page_id"]],
    test_ids[["created_property_id"]]
  )

  expect_s3_class(resp, "notion_response")
  expect_type(resp, "list")
  expect_equal(resp[["object"]], "property_item")
})

test_that("notion$pages$properties$update works", {
  notion <- notion_client()
  vcr::local_cassette("notion-pages-properties-update")

  resp <- notion$pages$properties$update(
    test_ids[["created_database_page_id"]],
    list(
      `In stock` = list(
        checkbox = TRUE
      )
    )
  )

  expect_s3_class(resp, "notion_response")
  expect_type(resp, "list")
  expect_equal(resp[["object"]], "page")
  expect_equal(resp[["id"]], test_ids[["created_database_page_id"]])
})

test_that("notion$databases$update() works", code = {
  notion <- notion_client()
  vcr::local_cassette("notion-database-update")

  resp <- notion$databases$update(
    test_ids[["created_database_id"]],
    list(list(
      text = list(
        content = "Today's grocery list"
      )
    ))
  )

  expect_s3_class(resp, "notion_response")
  expect_type(resp, "list")
  expect_equal(resp[["object"]], "database")
})

test_that("notion$search works", {
  notion <- notion_client()
  vcr::local_cassette("notion-search")

  resp <- notion$search(
    test_page_title,
    page_size = 1,
    filter = list(
      value = "page",
      property = "object"
    ),
    sort = list(
      direction = "descending",
      timestamp = "last_edited_time"
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
    list(page_id = test_ids[["created_page_id"]]),
    rich_text = list(list(
      text = list(
        content = "Hello world"
      )
    ))
  )

  expect_s3_class(resp, "notion_response")
  expect_type(resp, "list")
  expect_equal(resp[["object"]], "comment")
})

test_that("notion$comments$retrieve works", {
  notion <- notion_client()
  vcr::local_cassette("notion-comments-retrieve")

  resp <- notion$comments$retrieve(test_ids[["created_page_id"]])

  expect_s3_class(resp, "notion_response")
  expect_type(resp, "list")
  expect_equal(resp[["object"]], "list")
  expect_gt(length(resp[["results"]]), 0)
})

test_that("notion$blocks$delete works", {
  notion <- notion_client()
  vcr::local_cassette("notion-blocks-delete")

  resp <- notion$blocks$delete(test_ids[["created_page_id"]])

  expect_s3_class(resp, "notion_response")
  expect_type(resp, "list")
  expect_equal(resp[["object"]], "block")
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
