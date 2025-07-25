#' R6 Class for Blocks Endpoint
#'
#' @description
#' Handle all block operations in the Notion API
#'
#' **Note:** Access this endpoint through the client instance, e.g., `notion$blocks`. Not to be instantiated directly.
#'
#' @param block_id Character (required). The ID for a Notion block.
#' @returns A list containing the parsed API response.
#'
#' @examplesIf notion_token_exists()
#' \dontshow{notionapi:::vcr_example_start("notion-blocks-retrieve")}
#' notion <- notion_client()
#'
#' # ----- retrieve a block
#' notion$blocks$retrieve("23933ea0-c1e4-81dc-9f56-f3fa251a757f")
#' \dontshow{notionapi:::vcr_example_end()}
#'
#' # ----- update a block
#' \dontshow{notionapi:::vcr_example_start("notion-blocks-update")}
#' notion$blocks$update(
#'   "23933ea0-c1e4-81dc-9f56-f3fa251a757f",
#'   heading_2 = list(
#'     rich_text = list(
#'       list(
#'         text = list(
#'           content = "Updated Test Heading"
#'         )
#'       )
#'     )
#'   )
#' )
#' \dontshow{notionapi:::vcr_example_end()}
#'
#' # ----- delete a block
#' \dontshow{notionapi:::vcr_example_start("notion-blocks-delete")}
#' notion$blocks$delete(block_id = "23933ea0-c1e4-81d6-a6f6-dd5b57ad4aba")
#' \dontshow{notionapi:::vcr_example_end()}
BlocksEndpoint <- R6Class(
  "BlocksEndpoint",
  public = list(
    #' @field children Block children endpoint
    children = NULL,

    #' @description
    #' Initialise block endpoint.
    #' Not to be called directly, e.g., use `notion$blocks` instead.
    #' @param client Notion Client instance
    initialize = function(client) {
      private$.client <- client
      self$children <- BlocksChildrenEndpoint$new(client)
    },

    #' @description
    #' Retrieve a block
    #' @details
    #' [Endpoint documentation](https://developers.notion.com/reference/retrieve-a-block)
    retrieve = function(
      block_id
    ) {
      check_string(block_id, TRUE, FALSE)

      req <- notion_build_request(
        private$.client$request(),
        c("blocks", block_id),
        "GET",
        NULL,
        NULL
      )

      resp <- notion_perform_req(req)

      res <- notion_handle_resp(resp)

      res
    },

    #' @description
    #' Update a block
    #'
    #' @param archived Boolean. Set to TRUE to archive (delete) a block.
    #'   Set to FALSE to unarchive (restore) a block. Defaults to FALSE.
    #' @param ... <[`dynamic-dots`][rlang::dyn-dots]> Block-specific properties to update. Each argument should be named
    #'   after a [block type](https://developers.notion.com/reference/block) (e.g., `heading_1`, `paragraph`)
    #'   with a named list value containing the block configuration.
    #'
    #' @details
    #' [Endpoint documentation](https://developers.notion.com/reference/update-a-block)
    update = function(
      block_id,
      archived = FALSE,
      ...
    ) {
      check_string(block_id, TRUE, FALSE)
      check_bool(archived, FALSE)

      body_params <- parse_body_params(archived = archived, ...)

      req <-
        notion_build_request(
          private$.client$request(),
          c("blocks", block_id),
          "PATCH",
          body_params = body_params
        )

      resp <- notion_perform_req(req)

      res <- notion_handle_resp(resp)

      res
    },

    #' @description
    #' Delete a block
    #'
    #' @details
    #' [Endpoint documentation](https://developers.notion.com/reference/delete-a-block)
    delete = function(
      block_id
    ) {
      check_string(block_id, TRUE)

      req <- notion_build_request(
        private$.client$request(),
        c("blocks", block_id),
        "DELETE",
      )

      resp <- notion_perform_req(req)

      res <- notion_handle_resp(resp)

      res
    }
  ),
  private = list(
    .client = NULL
  ),
  cloneable = FALSE
)

#' @title R6 Class for Blocks children endpoint
#'
#' @description
#' Handle all block children operations in the Notion API
#'
#' **Note:** Access this endpoint through the client instance, e.g., `notion$blocks$children`. Not to be instantiated directly.
#'
#' @param block_id String (required). The ID for a Notion block.
#' @param page_size Integer. Number of items to return per page (1-100). Defaults to 100.
#' @param start_cursor Character. For pagination. If provided, returns results starting from this cursor.
#'   If NULL, returns the first page of results.
#'
#' @returns A list containing the parsed API response.
#'
#' @examplesIf notion_token_exists()
#' notion <- notion_client()
#'
#' # ----- append children to a block
#' \dontshow{notionapi:::vcr_example_start("notion-blocks-children-append")}
#' notion$blocks$children$append(
#'   block_id = "23933ea0-c1e4-81d6-a6f6-dd5b57ad4aba",
#'   children = list(
#'     # add a level 2 heading called "Test Heading"
#'     list(
#'       object = "block",
#'       heading_2 = list(
#'         rich_text = list(list(
#'           text = list(content = "Test Heading")
#'         ))
#'       )
#'     )
#'   )
#' )
#' \dontshow{notionapi:::vcr_example_end()}
#'
#' # ----- retrieve children of a block
#' \dontshow{notionapi:::vcr_example_start("notion-blocks-children-retrieve")}
#' notion$blocks$children$retrieve("23933ea0-c1e4-81d6-a6f6-dd5b57ad4aba")
#' \dontshow{notionapi:::vcr_example_end()}
#'
#' # ----- iterate through paginated results
#' \dontrun{
#' start_cursor <- NULL
#' has_more <- FALSE
#' resps <- list()
#' i <- 1
#'
#' while (has_more) {
#'   resps[[i]] <- notion$blocks$children$retrieve(
#'     "2926b407e3c44b49a1830609abe6744f",
#'     start_cursor
#'   )
#'   has_more <- resps[[i]][["has_more"]]
#'   start_cursor <- resps[[i]][["next_cursor"]]
#'   i <- i + 1
#' }
#' }
BlocksChildrenEndpoint <- R6Class(
  "BlocksChildrenEndpoint",
  public = list(
    #' @description
    #' Initialise block children endpoint.
    #' Not to be called directly, e.g., use `notion$pages$children` instead.
    #' @param client Notion Client instance
    initialize = function(client) {
      private$.client <- client
    },

    #' @description
    #' Retrieve a block's children
    #'
    #' @details
    #' [Endpoint documentation](https://developers.notion.com/reference/get-block-children)
    retrieve = function(
      block_id,
      start_cursor = NULL,
      page_size = 100
    ) {
      check_string(block_id, TRUE)
      check_string(start_cursor)
      check_int(page_size, 100)

      query_params <- parse_query_params(
        page_size = page_size,
        start_cursor = start_cursor
      )

      req <- notion_build_request(
        private$.client$request(),
        c("blocks", block_id, "children"),
        query_params = query_params
      )

      resp <- notion_perform_req(req)

      res <- notion_handle_resp(resp)

      return(res)
    },

    #' @description
    #' Append block children
    #'
    #' @param children List of lists (JSON array) (required). Block objects to append as children to the block.
    #' @param after Character. The ID of the existing block after which the new children are appended.
    #'
    #' @details
    #' [Endpoint documentation](https://developers.notion.com/reference/patch-block-children)
    append = function(
      block_id,
      children,
      after = NULL
    ) {
      check_string(block_id, TRUE)
      check_json_array(children, TRUE)
      check_string(after)
      if (missing(children)) {
        notionapi_error("`children` paremeter is required")
      }

      body_params <- parse_body_params(
        children = children,
        after = after
      )

      req <- notion_build_request(
        private$.client$request(),
        c("blocks", block_id, "children"),
        "PATCH",
        body_params = body_params
      )

      resp <- notion_perform_req(req)

      res <- notion_handle_resp(resp)

      return(res)
    }
  ),

  private = list(
    .client = NULL
  ),
  cloneable = FALSE
)

#' R6 Class for Pages Endpoint
#'
#' @description
#' Handle all pages operations in the Notion API
#'
#' **Note:** Access this endpoint through the client instance, e.g., `notion$pages`. Not to be instantiated directly.
#'
#' @returns A list containing the parsed API response.
#'
#' @examplesIf notion_token_exists()
#' \dontshow{notionapi:::vcr_example_start("notion-pages-create")}
#' notion <- notion_client()
#'
#' # ----- create a page
#' notion$pages$create(
#'   list(page_id = "22f33ea0c1e480b99c77d1ab72aedff9"),
#'   list(
#'     title = list(list(
#'       text = list(
#'         content = "Test Page for notionapi"
#'       )
#'     ))
#'   )
#' )
#' \dontshow{notionapi:::vcr_example_end()}
#'
#' # ----- retrieve a page
#' \dontshow{notionapi:::vcr_example_start("notion-pages-retrieve")}
#' notion$pages$retrieve("23933ea0-c1e4-81d6-a6f6-dd5b57ad4aba")
#' \dontshow{notionapi:::vcr_example_end()}
PagesEndpoint <- R6Class(
  "PagesEndpoint",
  public = list(
    #' @field properties Pages properties endpoint
    properties = NULL,

    #' @description
    #' Initialise pages endpoint.
    #' Not to be called directly, e.g., use `notion$pages` instead.
    #' @param client Notion Client instance
    initialize = function(client) {
      private$.client <- client
      self$properties <- PagesPropertiesEndpoint$new(client)
    },

    #' @description
    #' Create a page
    #'
    #' @param parent Named list (JSON object) (required). The parent page or database where the new page is inserted.
    #' @param properties Named list (JSON object) (required). Key-value pairs representing the properties of the page.
    #' @param children List of lists (JSON array). Block objects to append as children to the page.
    #' @param icon Named list (JSON object). An icon for the page.
    #' @param cover Named list (JSON object). A cover image for the page.
    #'
    #' @details
    #' [Endpoint documentation](https://developers.notion.com/reference/post-page)
    create = function(
      parent,
      properties,
      children = NULL,
      icon = NULL,
      cover = NULL
    ) {
      check_json_object(parent, TRUE)
      check_json_object(properties, TRUE)
      check_json_array(children)
      check_json_object(icon)
      check_json_object(cover)

      body_params <- parse_body_params(
        parent = parent,
        properties = properties,
        children = children,
        icon = icon,
        cover = cover
      )

      req <- notion_build_request(
        private$.client$request(),
        "pages",
        "POST",
        body_params = body_params
      )

      resp <- notion_perform_req(req)

      res <- notion_handle_resp(resp)

      res
    },

    #' @description
    #' Retrieve page properties
    #'
    #' @param page_id Character (required.). The ID for a Notion page.
    #' @param filter_properties Character. Page property value IDs to include in the response schema.
    #'   If NULL, all properties are returned.
    #' @details
    #' [Endpoint documentation](https://developers.notion.com/reference/retrieve-a-page)
    retrieve = function(
      page_id,
      filter_properties = NULL
    ) {
      check_string(page_id, TRUE)

      check_string(
        filter_properties,
        FALSE,
        TRUE
      )

      query_params <- parse_repeated_query_params(
        as.character(filter_properties),
        "filter_properties"
      )

      req <- notion_build_request(
        private$.client$request(),
        c("pages", page_id),
        "GET",
        query_params
      )

      resp <- notion_perform_req(req)

      res <- notion_handle_resp(resp)

      res
    }
  ),
  private = list(
    .client = NULL
  ),
  cloneable = FALSE
)

#' R6 Class for Pages Properties Endpoint
#'
#' @description
#' Handle all pages properties operations in the Notion API
#'
#' **Note:** Access this endpoint through the client instance, e.g., `notion$pages$properties`. Not to be instantiated directly.
#'
#' @param page_id Character (required). The ID for a Notion page.
#' @param page_size Integer. Number of items to return per page (1-100). Defaults to 100.
#' @param start_cursor Character. For pagination. If provided, returns results starting from this cursor.
#'   If NULL, returns the first page of results.
#'
#' @returns A list containing the parsed API response.
#'
#' @examplesIf notion_token_exists()
#' notion <- notion_client()
#'
#' # ----- retrieve a page property
#' \dontshow{notionapi:::vcr_example_start("notion-pages-properties-retrieve")}
#' notion$pages$properties$retrieve(
#'   "23933ea0-c1e4-8104-897b-f5a09269e561",
#'   property_id = "q;L^"
#' )
#' \dontshow{notionapi:::vcr_example_end()}
#'
#' # ----- update a page property
#' \dontshow{notionapi:::vcr_example_start("notion-pages-properties-update")}
#' notion$pages$properties$update(
#'   "23933ea0-c1e4-8104-897b-f5a09269e561",
#'   list(
#'     `In stock` = list(
#'       checkbox = TRUE
#'     )
#'   )
#' )
#' \dontshow{notionapi:::vcr_example_end()}
PagesPropertiesEndpoint <- R6Class(
  "PagesPropertiesEndpoint",
  public = list(
    #' @description
    #' Initialise pages properties endpoint.
    #' Not to be called directly, e.g., use `notion$pages$properties` instead.
    #' @param client Notion Client instance
    initialize = function(client) {
      private$.client <- client
    },

    #' @description
    #' Retrieve a page property item
    #' @param property_id Character (required). The ID of the property to retrieve.
    #'
    #' @details
    #' [Endpoint documentation](https://developers.notion.com/reference/retrieve-a-page-property)
    retrieve = function(
      page_id,
      property_id,
      page_size = 100,
      start_cursor = NULL
    ) {
      check_string(page_id, TRUE)
      check_string(property_id, TRUE)
      check_int(page_size, 100)
      check_string(start_cursor)

      property_id <- decode_query_param(property_id)

      query_params <- parse_query_params(
        page_size = page_size,
        start_cursor = start_cursor
      )

      req <-
        notion_build_request(
          private$.client$request(),
          c("pages", page_id, "properties", property_id),
          "GET",
          query_params
        )

      resp <- notion_perform_req(req)

      res <- notion_handle_resp(resp)

      return(res)
    },

    #' @description
    #' Update a page property
    #'
    #' @param properties Named list (JSON object). Page properties to update as key-value pairs.
    #' @param in_trash Boolean. Set to TRUE to move the block to trash (delete).
    #'   Set to FALSE to restore the block Defaults to FALSE.
    #' @param icon Named list (JSON object). An icon for the page.
    #' @param cover Named list (JSON object). A cover image for the page.
    #'
    #' @details
    #' [Endpoint documentation](https://developers.notion.com/reference/patch-page)
    update = function(
      page_id,
      properties = NULL,
      in_trash = NULL,
      icon = NULL,
      cover = NULL
    ) {
      check_string(page_id, TRUE)
      check_json_object(properties)
      check_bool(in_trash)
      check_json_object(icon, FALSE)
      check_json_object(cover, FALSE)

      body_params <- parse_body_params(
        properties = properties,
        in_trash = in_trash,
        icon = icon,
        cover = cover
      )

      req <- notion_build_request(
        private$.client$request(),
        c("pages", page_id),
        "PATCH",
        body_params = body_params
      )

      resp <- notion_perform_req(req)

      res <- notion_handle_resp(resp)

      res
    }
  ),
  private = list(
    .client = NULL
  ),
  cloneable = FALSE
)

#' R6 Class for Databases Endpoint
#'
#' @description
#' Handle all databases operations in the Notion API
#'
#' **Note:** Access this endpoint through the client instance, e.g., `notion$databases`. Not to be instantiated directly.
#'
#' @param database_id String (required). The ID of a Notion database.
#' @param page_size Integer. Number of items to return per page (1-100). Defaults to 100.
#' @param start_cursor Character. For pagination. If provided, returns results starting from this cursor.
#'   If NULL, returns the first page of results.
#'
#' @returns A list containing the parsed API response.
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
#'
#' # ----- retrieve a database
#' \dontshow{notionapi:::vcr_example_start("notion-databases-retrieve")}
#' notion$databases$retrieve(
#'   "23933ea0-c1e4-8136-b37b-fa235c6f2a71"
#' )
#' \dontshow{notionapi:::vcr_example_end()}
#'
#' # ----- update a database
#' \dontshow{notionapi:::vcr_example_start("notion-database-update")}
#' notion$databases$update(
#'   "23933ea0-c1e4-8136-b37b-fa235c6f2a71",
#'   list(list(
#'     text = list(
#'       content = "Today's grocery list"
#'     )
#'   ))
#' )
#' \dontshow{notionapi:::vcr_example_end()}
#'
#' # ----- query a database
#' \dontshow{notionapi:::vcr_example_start("notion-database-query")}
#' notion$databases$query(
#'   database_id = "23933ea0-c1e4-8136-b37b-fa235c6f2a71",
#'   filter = list(
#'     or = list(
#'       list(
#'         property = "In stock",
#'         checkbox = list(equals = TRUE)
#'       ),
#'       list(
#'         property = "Name",
#'         title = list(contains = "kale")
#'       )
#'     )
#'   ),
#'   sorts = list(list(
#'     property = "Name",
#'     direction = "ascending"
#'   ))
#' )
#' \dontshow{notionapi:::vcr_example_end()}
#'
#' # ----- iterate through paginated results
#' \dontrun{
#' i <- 1
#' resps <- list()
#' has_more <- FALSE
#' start_cursor <- NULL
#'
#' while (has_more) {
#'   resps[[i]] <- notion$databases$query(
#'     "22833ea0c1e481178e9cf1dcba79dbca",
#'     start_cursor = start_cursor
#'   )
#'
#'   has_more <- resps[[i]][["has_more"]]
#'   start_cursor <- resps[[i]][["next_cursor"]]
#'   i <- i + 1
#' }
#' }
DatabasesEndpoint <- R6Class(
  "DatabasesEndpoint",
  public = list(
    #' @description
    #' Initialise databases endpoint.
    #' Not to be called directly, e.g., use `notion$databases` instead.
    #' @param client Notion Client instance
    initialize = function(client) {
      private$.client <- client
    },

    #' @description
    #' Create a database
    #' @param parent Named list (JSON object) (required). The parent page where the database will be created.
    #' @param title List of lists (JSON array). Database title as an array of [rich text objects](https://developers.notion.com/reference/rich-text).
    #' @param properties Named list (JSON object) (required). The properties of the database as key-value pairs.
    #' @param ... <[`dynamic-dots`][rlang::dyn-dots]> Additional body parameters to include in the request body.
    #'
    #' @details
    #' [Endpoint documentation](https://developers.notion.com/reference/create-a-database)
    create = function(
      parent,
      title,
      properties,
      ...
    ) {
      check_json_object(parent, TRUE)
      check_json_array(title)
      check_json_object(properties, TRUE)

      body_params <- parse_body_params(
        parent = parent,
        title = title,
        properties = properties,
        ...
      )

      req <- notion_build_request(
        private$.client$request(),
        "databases",
        "POST",
        body_params = body_params
      )

      resp <- notion_perform_req(req)

      res <- notion_handle_resp(resp)

      res
    },

    #' @description
    #' Query a database
    #' @param filter_properties Character vector. Property value IDs to include in the response schema.
    #' @param filter Named list (JSON object). [Filter conditions](https://developers.notion.com/reference/post-database-query-filter)
    #'   to apply to the query.
    #' @param sorts List of lists (JSON array). [Sort conditions](https://developers.notion.com/reference/post-database-query-sort)
    #'   to apply to the query.
    #' @param ... Reserved for future use.
    #'
    #' @details
    #' [Endpoint documentation](https://developers.notion.com/reference/post-database-query)
    query = function(
      database_id,
      filter_properties = NULL,
      filter = NULL,
      sorts = NULL,
      start_cursor = NULL,
      page_size = 100,
      ...
    ) {
      check_string(database_id, TRUE)
      check_string(filter_properties, FALSE, TRUE)
      check_string(start_cursor)
      check_int(page_size, 100, FALSE)

      query_params <- if (!is.null(filter_properties)) {
        filter_properties <- decode_query_param(filter_properties)

        query_params <- parse_repeated_query_params(
          filter_properties,
          "filter_properties"
        )
      }

      body_params <- parse_body_params(
        filter = filter,
        sorts = sorts,
        start_cursor = start_cursor,
        page_size = page_size,
        ...
      )

      req <- notion_build_request(
        private$.client$request(),
        c("databases", database_id, "query"),
        "POST",
        query_params,
        body_params
      )

      resp <- notion_perform_req(req)

      res <- notion_handle_resp(resp)

      res
    },

    #' @description
    #' Retrieve a database
    #'
    #' @details
    #' [Endpoint documentation](https://developers.notion.com/reference/retrieve-a-database)
    retrieve = function(
      database_id
    ) {
      check_string(database_id, TRUE)

      req <- notion_build_request(
        private$.client$request(),
        c("databases", database_id)
      )

      resp <- notion_perform_req(req)

      res <- notion_handle_resp(resp)

      res
    },

    #' @description
    #' Update a database
    #' @param title List of lists (JSON array). Database title as an array of rich text objects.
    #' @param description List of lists (JSON array). Database description as an array of rich text objects.
    #' @param properties Named list (JSON object). Database properties to update as key-value pairs.
    #'
    #' @details
    #' [Endpoint documentation](https://developers.notion.com/reference/update-a-database)
    update = function(
      database_id,
      title = NULL,
      description = NULL,
      properties = NULL
    ) {
      check_string(database_id, TRUE)

      check_json_array(title)
      check_json_array(description)
      check_json_object(properties)

      body_params <- parse_body_params(
        title = title,
        description = description,
        properties = properties
      )

      req <- notion_build_request(
        private$.client$request(),
        c("databases", database_id),
        "PATCH",
        body_params = body_params
      )

      resp <- notion_perform_req(req)

      res <- notion_handle_resp(resp)

      res
    }
  ),
  private = list(
    .client = NULL
  ),
  cloneable = FALSE
)

#' R6 Class for Comments Endpoint
#'
#' @description
#' Handle all comments operations in the Notion API
#'
#' **Note:** Access this endpoint through the client instance, e.g., `notion$comments`. Not to be instantiated directly.
#'
#' @param page_size Integer. Number of items to return per page (1-100). Defaults to 100.
#' @param start_cursor Character. For pagination. If provided, returns results starting from this cursor.
#'   If NULL, returns the first page of results.
#'
#' @returns A list containing the parsed API response.
#'
#' @examplesIf notion_token_exists()
#' notion <- notion_client()
#'
#' # ----- create comment
#' \dontshow{notionapi:::vcr_example_start("notion-comments-create")}
#' notion$comments$create(
#'   list(page_id = "23933ea0-c1e4-81d6-a6f6-dd5b57ad4aba"),
#'   rich_text = list(list(
#'     text = list(
#'       content = "Hello world"
#'     )
#'   ))
#' )
#' \dontshow{notionapi:::vcr_example_end()}
#'
#' # ----- retrieve comments
#' \dontshow{notionapi:::vcr_example_start("notion-comments-retrieve")}
#' notion$comments$retrieve(block_id = "23933ea0-c1e4-81d6-a6f6-dd5b57ad4aba")
#' \dontshow{notionapi:::vcr_example_end()}
CommentsEndpoint <- R6Class(
  "CommentsEndpoint",
  public = list(
    #' @description
    #' Initialise comments endpoint.
    #' Not to be called directly, e.g., use `notion$comments` instead.
    #' @param client Notion Client instance
    initialize = function(client) {
      private$.client <- client
    },

    #' @description
    #' Create a comment
    #'
    #' @param parent List (JSON object). The parent page where comment is created. Required if `discussion_id` is not provided
    #' @param discussion_id Character. The ID of the discussion thread for the comment. Required if `parent` is not provided.
    #' @param rich_text List of lists (JSON array) (required). [Rich text object(s)](https://developers.notion.com/reference/rich-text) representing the comment content.
    #' @param attachments List of lists (JSON array). Attachments to include in the comment.
    #' @param display_name Named list (JSON object). Custom display name of the comment.
    #'
    #' @details
    #' [Endpoint documentation](https://developers.notion.com/reference/create-a-comment)
    create = function(
      parent = NULL,
      discussion_id = NULL,
      rich_text,
      attachments = NULL,
      display_name = NULL
    ) {
      check_exclusive(parent, discussion_id, .require = TRUE)
      check_json_object(parent)
      check_string(discussion_id)
      check_json_array(rich_text, TRUE)
      check_json_array(attachments)
      check_json_object(display_name)

      body_params <- parse_body_params(
        parent = parent,
        discussion_id = discussion_id,
        rich_text = rich_text,
        attachments = attachments,
        display_name = display_name
      )

      req <- notion_build_request(
        private$.client$request(),
        "comments",
        "POST",
        body_params = body_params
      )

      resp <- notion_perform_req(req)

      res <- notion_handle_resp(resp)

      res
    },
    #' @description
    #' Retrieve comments for a block
    #'
    #' @param block_id Character. The ID for a Notion block.
    #'
    #' @details
    #' [Endpoint documentation](https://developers.notion.com/reference/retrieve-a-comment)
    retrieve = function(
      block_id,
      start_cursor = NULL,
      page_size = NULL
    ) {
      check_string(block_id, TRUE)
      check_string(start_cursor)
      check_int(start_cursor, 100)

      query_params <- parse_query_params(
        block_id = block_id,
        start_cursor = start_cursor,
        page_size = page_size
      )

      req <- notion_build_request(
        private$.client$request(),
        "comments",
        query_params = query_params,
      )

      resp <- notion_perform_req(req)

      res <- notion_handle_resp(resp)

      res
    }
  ),
  private = list(
    .client = NULL
  ),
  cloneable = FALSE
)

#' R6 Class for Users Endpoint
#'
#' @description
#' Handle all users operations in the Notion API
#'
#' **Note:** Access this endpoint through the client instance, e.g., `notion$users`. Not to be instantiated directly.
#'
#' @param page_size Integer. Number of items to return per page (1-100). Defaults to 100.
#' @param start_cursor Character. For pagination. If provided, returns results starting from this cursor.
#'   If NULL, returns the first page of results.
#'
#' @returns A list containing the parsed API response.
#'
#' @examplesIf notion_token_exists()
#' notion <- notion_client()
#'
#' # ----- list all users
#' \dontshow{notionapi:::vcr_example_start("notion-users-list")}
#' notion$users$list()
#' \dontshow{notionapi:::vcr_example_end()}
#'
#' # ----- retrieve a user
#' \dontshow{notionapi:::vcr_example_start("notion-users-retrieve")}
#' notion$users$retrieve(user_id = "fda12729-108d-4eb5-bbfb-a8f0886794d1")
#' \dontshow{notionapi:::vcr_example_end()}
#'
#' # ----- retrieve the bot User associated with the API token
#' \dontshow{notionapi:::vcr_example_start("notion-users-me")}
#' notion$users$me()
#' \dontshow{notionapi:::vcr_example_end()}
UsersEndpoint <- R6Class(
  "UsersEndpoint",
  public = list(
    #' @description
    #' Initialise users endpoint.
    #' Not to be called directly, e.g., use `notion$users` instead.
    #' @param client Notion Client instance
    initialize = function(client) {
      private$.client <- client
    },

    #' @description
    #' List all users
    #'
    #' @details
    #' [Endpoint documentation](https://developers.notion.com/reference/get-users)
    list = function(
      start_cursor = NULL,
      page_size = NULL
    ) {
      check_string(start_cursor)
      check_int(page_size, 100, FALSE)

      query_params <- parse_query_params(
        page_size = page_size,
        start_cursor = start_cursor
      )

      req <- notion_build_request(
        private$.client$request(),
        "users",
        query_params = query_params
      )

      resp <- notion_perform_req(req)

      res <- notion_handle_resp(resp)

      res
    },

    #' @description
    #' Retrieve a user
    #'
    #' @param user_id Character (required). The ID of the user to retrieve.
    #'
    #' @details
    #' [Endpoint documentation](https://developers.notion.com/reference/get-user)
    retrieve = function(
      user_id
    ) {
      check_string(user_id, TRUE)

      req <- notion_build_request(
        private$.client$request(),
        c("users", user_id),
      )

      resp <- notion_perform_req(req)

      res <- notion_handle_resp(resp)

      return(res)
    },

    #' @description
    #' Retrieve the bot User associated with the API token
    #'
    #' @details
    #' [Endpoint documentation](https://developers.notion.com/reference/get-self)
    me = function() {
      req <- notion_build_request(
        private$.client$request(),
        c("users", "me"),
      )

      resp <- notion_perform_req(req)

      res <- notion_handle_resp(resp)

      res
    }
  ),
  private = list(
    .client = NULL
  ),
  cloneable = FALSE
)
