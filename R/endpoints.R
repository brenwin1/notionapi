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
#' notion <- notion_client()
#' \dontshow{notionapi::vcr_example_start("notion-blocks-retrieve")}
#' # ----- Retrieve a block
#' notion$blocks$retrieve("34033ea0-c1e4-8137-9ae8-e09c23601f12")
#' \dontshow{notionapi::vcr_example_end()}
#' \dontshow{notionapi::vcr_example_start("notion-blocks-update")}
#' # ----- Update a block
#' notion$blocks$update(
#'   "34033ea0-c1e4-8137-9ae8-e09c23601f12",
#'   heading_2 = list(
#'     rich_text = list(list(
#'       text = list(
#'         content = "Updated Test Heading"
#'       )
#'     ))
#'   )
#' )
#' \dontshow{notionapi::vcr_example_end()}
#' \dontshow{notionapi::vcr_example_start("notion-blocks-delete")}
#' # ----- Delete a block
#' notion$blocks$delete(
#'   "34033ea0-c1e4-8137-9ae8-e09c23601f12"
#' )
#' \dontshow{notionapi::vcr_example_end()}
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
    #' @param in_trash Boolean. Set to TRUE to trash (delete) a block.
    #'   Set to FALSE to restore a block.
    #' @param ... <[`dynamic-dots`][rlang::dyn-dots]> Block-specific properties to update. Each argument should be named
    #'   after a [block type](https://developers.notion.com/reference/block) (e.g., `heading_1`, `paragraph`)
    #'   with a named list value containing the block configuration.
    #'
    #' @details
    #' [Endpoint documentation](https://developers.notion.com/reference/update-a-block)
    update = function(
      block_id,
      in_trash = NULL,
      ...
    ) {
      check_string(block_id, TRUE, FALSE)
      check_bool(in_trash, FALSE)

      body_params <- parse_body_params(
        in_trash = in_trash,
        ...
      )

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
#' \dontshow{notionapi::vcr_example_start("notion-blocks-children-append")}
#' # ----- Append children to a block
#' notion$blocks$children$append(
#'   "34033ea0-c1e4-8181-a411-fcffc69c690a",
#'   list(
#'     list(
#'       object = "block",
#'       heading_2 = list(
#'         rich_text = list(list(
#'           text = list(content = "Test Heading")
#'         ))
#'       )
#'     )
#'   ),
#'   position = list(type = "start")
#' )
#' \dontshow{notionapi::vcr_example_end()}
#' \dontshow{notionapi::vcr_example_start("notion-blocks-children-list")}
#' # ----- Retrieve children of a block
#' notion$blocks$children$list("34033ea0-c1e4-8181-a411-fcffc69c690a")
#' \dontshow{notionapi::vcr_example_end()}
#' # ----- Iterate through paginated results
#' \dontrun{
#' start_cursor <- NULL
#' has_more <- FALSE
#' resps <- list()
#' i <- 1
#'
#' while (has_more) {
#'   resps[[i]] <- notion$blocks$children$list(
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
    list = function(
      block_id,
      start_cursor = NULL,
      page_size = NULL
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
    #' @param position Named list (JSON object). Controls where new blocks are inserted
    #'   among parent's children. Defaults to end of parent block's children when omitted.
    #'
    #' @details
    #' [Endpoint documentation](https://developers.notion.com/reference/patch-block-children)
    append = function(
      block_id,
      children,
      position = NULL
    ) {
      check_string(block_id, TRUE)
      check_json_array(children, TRUE)
      check_json_object(position)

      body_params <- parse_body_params(
        children = children,
        position = position
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
#' notion <- notion_client()
#' \dontshow{notionapi::vcr_example_start("notion-pages-create")}
#' # ----- Create a page
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
#' \dontshow{notionapi::vcr_example_end()}
#' \dontshow{notionapi::vcr_example_start("notion-pages-retrieve")}
#' # ----- Retrieve a page
#' notion$pages$retrieve("34033ea0-c1e4-8181-a411-fcffc69c690a")
#' \dontshow{notionapi::vcr_example_end()}
#' \dontshow{notionapi::vcr_example_start("notion-pages-move")}
#' # ----- Move page into a database
#' notion$pages$move(
#'   "34033ea0-c1e4-8181-a411-fcffc69c690a",
#'   list(
#'     data_source_id = "34033ea0-c1e4-81a2-aaf4-000b260f79c9"
#'   )
#' )
#' \dontshow{notionapi::vcr_example_end()}
#' \dontshow{notionapi::vcr_example_start("notion-pages-update")}
#' # ----- Update a page
#' notion$pages$update(
#'   "34033ea0-c1e4-8181-a411-fcffc69c690a",
#'   icon = list(
#'     emoji = "🐶"
#'   )
#' )
#' \dontshow{notionapi::vcr_example_end()}
#' \dontshow{notionapi::vcr_example_start("notion-pages-update-null")}
#' # ----- Use `NA` to send JSON `null` — below removes the page's icon
#' notion$pages$update(
#'   "34033ea0-c1e4-8181-a411-fcffc69c690a",
#'   icon = NA
#' )
#' \dontshow{notionapi::vcr_example_end()}
#' \dontshow{notionapi::vcr_example_start("notion-pages-retrieve-markdown")}
#' # ----- Retrieve a page as markdown
#' notion$pages$retrieve_markdown("34033ea0-c1e4-8181-a411-fcffc69c690a")
#' \dontshow{notionapi::vcr_example_end()}
#' \dontshow{notionapi::vcr_example_start("notion-pages-update-markdown")}
#' # ----- Update/replace a page content
#' notion$pages$update_markdown(
#'   "34033ea0-c1e4-8181-a411-fcffc69c690a",
#'   "replace_content",
#'   replace_content = list(
#'     new_str = '## Updated Test Heading\nUsed markdown{color="blue"}'
#'   )
#' )
#' \dontshow{notionapi::vcr_example_end()}
#' \dontshow{notionapi::vcr_example_start("notion-pages-trash")}
#' # ----- Trash a page
#' notion$pages$update(
#'   "34033ea0-c1e4-8181-a411-fcffc69c690a",
#'   in_trash = TRUE
#' )
#' \dontshow{notionapi::vcr_example_end()}
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
    #' @param parent Named list (JSON object) (required). The parent under which the new page is created.
    #' @param properties Named list (JSON object). Key-value pairs representing the page's properties.
    #' @param icon Named list (JSON object). The page icon.
    #' @param cover Named list (JSON object). The page cover image.
    #' @param content List of lists (JSON array). Block objects to append as children to the page.
    #' @param children List of lists (JSON array). Block objects to append as children to the page.
    #' @param markdown Character. Page content as Notion-flavored Markdown.
    #'   Mutually exclusive with content/children.
    #' @param template Named list (JSON object). A data source template apply to the new page.
    #'   Cannot be combined with children.
    #' @param position Named list (JSON object). Controls where new blocks are inserted
    #'   among parent's children. Defaults to end of parent block's children when omitted.
    #'
    #' @details
    #' [Endpoint documentation](https://developers.notion.com/reference/post-page)
    create = function(
      parent,
      properties = NULL,
      icon = NULL,
      cover = NULL,
      content = NULL,
      children = NULL,
      markdown = NULL,
      template = NULL,
      position = NULL
    ) {
      check_json_object(parent, TRUE)
      check_json_object(properties, FALSE)
      check_json_object(icon, FALSE)
      check_json_object(cover, FALSE)
      check_json_array(content, FALSE)
      check_json_array(children, FALSE)
      check_string(markdown, FALSE)
      check_json_object(template, FALSE)
      check_json_object(position, FALSE)

      body_params <- parse_body_params(
        parent = parent,
        properties = properties,
        icon = icon,
        cover = cover,
        content = content,
        children = children,
        markdown = markdown,
        template = template,
        position = position
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
    #' @param page_id Character (required). The ID for a Notion page.
    #' @param filter_properties Character vector. Page property value IDs to include in the response schema.
    #'   If NULL (default), all properties are returned.
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
    },
    #' @description
    #' Move a page
    #'
    #' @param page_id Character (required). The ID of the page to move.
    #' @param parent Named list (JSON object) (required). The new parent location for the page.
    #'
    #' @details
    #' [Endpoint documentation](https://developers.notion.com/reference/move-page)
    move = function(
      page_id,
      parent
    ) {
      check_string(page_id, TRUE, FALSE)
      check_json_object(parent, TRUE)

      body_params <- parse_body_params(
        parent = parent
      )

      req <- notion_build_request(
        private$.client$request(),
        c("pages", page_id, "move"),
        "POST",
        body_params = body_params
      )

      resp <- notion_perform_req(req)

      res <- notion_handle_resp(resp)

      res
    },

    #' @description
    #' Update attributes of a Notion page
    #'
    #' @param page_id Character (required). The ID for a Notion page.
    #' @param properties Named list (JSON object). Key-value pairs representing the page's properties.
    #' @param icon Named list (JSON object). The page icon.
    #' @param cover Named list (JSON object). The page cover image.
    #' @param is_locked Boolean. Whether the page should be locked from editing.
    #' @param template Named list (JSON object). A template to apply to the page.
    #' @param erase_content Boolean. Whether to erase all existing content from the page.
    #'   Irreversible via the API.
    #' @param in_trash Boolean. Set to TRUE to trash (delete) the page.
    #'   Set to FALSE to restore the page.
    #' @param is_archived Boolean. Deprecated alias for `in_trash`. Use `in_trash`
    #'   for new integrations.
    #' @details
    #' [Endpoint documentation](https://developers.notion.com/reference/patch-page)
    update = function(
      page_id,
      properties = NULL,
      icon = NULL,
      cover = NULL,
      is_locked = NULL,
      template = NULL,
      erase_content = NULL,
      in_trash = NULL,
      is_archived = NULL
    ) {
      check_string(page_id, TRUE)
      check_json_object(properties, FALSE)
      check_json_object(icon, FALSE)
      check_json_object(cover, FALSE)
      check_bool(is_locked, FALSE)
      check_json_object(template, FALSE)
      check_bool(erase_content, FALSE)
      check_bool(in_trash, FALSE)
      check_bool(is_archived, FALSE)

      body_params = parse_body_params(
        properties = properties,
        icon = icon,
        cover = cover,
        is_locked = is_locked,
        template = template,
        erase_content = erase_content,
        in_trash = in_trash,
        is_archived = is_archived
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
    },

    #' @description Retrieve a page as markdown
    #'
    #' @param page_id Character (required). The ID of the page (or block) to
    #'   to retrieve as markdown.
    #' @param include_transcript Boolean. Whether to include meeting note transcripts.
    #'   Defaults to false.
    #'
    #' @details
    #' [Endpoint documentation](https://developers.notion.com/reference/retrieve-page-markdown)
    retrieve_markdown = function(
      page_id,
      include_transcript = NULL
    ) {
      check_string(page_id, TRUE, FALSE)

      check_bool(include_transcript, FALSE)

      query_params <- parse_query_params(
        include_transcript = include_transcript
      )

      req <- notion_build_request(
        private$.client$request(),
        c("pages", page_id, "markdown"),
        "GET",
        query_params
      )

      resp <- notion_perform_req(req)

      res <- notion_handle_resp(resp)

      return(res)
    },

    #' @description
    #' Update a page's content as markdown
    #'
    #' @param page_id Character (required). The ID of the page to update.
    #' @param type Character (required). The update command type.
    #'   One of "update_content", "replace_content", "insert_content"
    #'   and "replace_content_range". The first two are recommended.
    #' @param update_content Named list (JSON object). Update specific content
    #'   using search-and-replace operations.
    #' @param replace_content Named list (JSON object). Replace the entire page content
    #'   with new markdown.
    #' @param insert_content Named list (JSON object). Insert new content into
    #'   the page.
    #' @param replace_content_range Named list (JSON object). Replace a range
    #'   of content in the page.
    #'
    #' @details
    #' [Endpoint documentation](https://developers.notion.com/reference/update-page-markdown)
    update_markdown = function(
      page_id,
      type,
      update_content = NULL,
      replace_content = NULL,
      insert_content = NULL,
      replace_content_range = NULL
    ) {
      check_exclusive(
        update_content,
        replace_content,
        insert_content,
        replace_content_range,
        .require = TRUE
      )

      check_string(page_id, TRUE, FALSE)
      check_string(type, TRUE, FALSE)
      check_json_object(update_content, FALSE)
      check_json_object(replace_content, FALSE)
      check_json_object(insert_content, FALSE)
      check_json_object(replace_content_range, FALSE)

      body_params <- parse_body_params(
        type = type,
        update_content = update_content,
        replace_content = replace_content,
        insert_content = insert_content,
        replace_content_range = replace_content_range
      )

      req <- notion_build_request(
        private$.client$request(),
        c("pages", page_id, "markdown"),
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
#' \dontshow{notionapi::vcr_example_start("notion-pages-properties-retrieve")}
#' # ----- Retrieve a page property
#' notion$pages$properties$retrieve(
#'   "34033ea0-c1e4-8181-a411-fcffc69c690a",
#'   "BvMv"
#' )
#' \dontshow{notionapi::vcr_example_end()}
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
      start_cursor = NULL,
      page_size = NULL
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
#' \dontshow{notionapi::vcr_example_start("notion-databases-create")}
#' # ----- Create a database
#' notion$databases$create(
#'   list(
#'     type = "page_id",
#'     page_id = "22f33ea0c1e480b99c77d1ab72aedff9"
#'   ),
#'   title = list(list(
#'     text = list(
#'       content = "Test Database"
#'     )
#'   ))
#' )
#' \dontshow{notionapi::vcr_example_end()}
#' \dontshow{notionapi::vcr_example_start("notion-databases-retrieve")}
#' # ----- Retrieve a database
#' notion$databases$retrieve("efab1bec-0094-4afe-a90c-c9b72d538b4b")
#' \dontshow{notionapi::vcr_example_end()}
#' \dontshow{notionapi::vcr_example_start("notion-database-update")}
#' # ----- Update a database
#' notion$databases$update(
#'   "efab1bec-0094-4afe-a90c-c9b72d538b4b",
#'   description = list(list(
#'     text = list(
#'       content = "For testing purposes"
#'     )
#'   )),
#'   icon = list(
#'     emoji = "🤩"
#'   )
#' )
#' \dontshow{notionapi::vcr_example_end()}
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
    #' @param parent Named list (JSON object) (required). The parent page or workspace
    #'   where the database will be created.
    #' @param title List of lists (JSON array). The title of the database.
    #' @param description List of lists (JSON array). The description of the database.
    #' @param is_inline Boolean. Whether the database should be displayed inline
    #'   in the parent page. Defaults to false.
    #' @param initial_data_source Named list (JSON object). Initial data source
    #'   configuration for the database
    #' @param icon Named list (JSON object). The icon for the database.
    #' @param cover Named list (JSON object). The cover image for the database.
    #'
    #' @details
    #' [Endpoint documentation](https://developers.notion.com/reference/create-database)
    create = function(
      parent,
      title = NULL,
      description = NULL,
      is_inline = NULL,
      initial_data_source = NULL,
      icon = NULL,
      cover = NULL
    ) {
      check_json_object(parent, TRUE)
      check_json_array(title)
      check_json_array(description)
      check_bool(is_inline)
      check_json_object(initial_data_source)
      check_json_object(icon)
      check_json_object(cover)

      body_params <- parse_body_params(
        parent = parent,
        title = title,
        description = description,
        is_inline = is_inline,
        initial_data_source = initial_data_source,
        icon = icon,
        cover = cover
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
    #' Retrieve a database
    #'
    #' @details
    #' [Endpoint documentation](https://developers.notion.com/reference/retrieve-database)
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
    #'
    #' @param parent Named list (JSON object). The parent page or workspace
    #'   to move the database to. If not provided, the database will not be moved.
    #' @param title List of lists (JSON array). The updated title of the database.
    #' @param description List of lists (JSON array). The updated description of the database.
    #' @param is_inline Boolean. Whether the database should be displayed in the
    #'   parent page.
    #' @param icon Named list (JSON object). The updated icon for the database.
    #' @param cover Named list (JSON object). The updated cover image for the database.
    #' @param in_trash Boolean. Whether the database should be moved to or from the trash.
    #' @param is_locked Boolean. Whether the database should be locked from editing.
    #'
    #' @details
    #' [Endpoint documentation](https://developers.notion.com/reference/update-database)
    update = function(
      # path params.
      database_id,
      # body params.
      parent = NULL,
      title = NULL,
      description = NULL,
      is_inline = NULL,
      icon = NULL,
      cover = NULL,
      in_trash = NULL,
      is_locked = NULL
    ) {
      check_string(database_id, TRUE)
      check_json_object(parent)
      check_json_array(title)
      check_json_array(description)
      check_bool(is_inline)
      check_json_object(icon)
      check_json_object(cover)
      check_bool(in_trash)
      check_bool(is_locked)

      body_params <- parse_body_params(
        parent = parent,
        title = title,
        description = description,
        is_inline = is_inline,
        icon = icon,
        cover = cover,
        in_trash = in_trash,
        is_locked = is_locked
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

#' R6 Class for DataSources Endpoint
#'
#' @description
#' Handle all data sources operations in the Notion API
#'
#' **Note:** Access this endpoint through the client instance, e.g., `notion$datas_ources`. Not to be instantiated directly.
#'
#' @param data_source_id Character (required). ID of a Notion data source.
#' @param start_cursor Character. For pagination. If provided, returns results starting from this cursor.
#'   If NULL, returns the first page of results.
#' @param page_size Integer. Number of items to return per page (1-100). Defaults to 100
#'
#' @returns A list containing the parsed API response.
#'
#' @examplesIf notion_token_exists()
#' notion <- notion_client()
#' \dontshow{notionapi::vcr_example_start("notion-data-sources-create")}
#' # ----- Create a data source
#' notion$data_sources$create(
#'   list(
#'     database_id = "efab1bec-0094-4afe-a90c-c9b72d538b4b"
#'   ),
#'   properties = list(
#'     Title = list(
#'       title = no_config()
#'     )
#'   ),
#'   title = list(list(
#'     text = list(
#'       content = "Test data source"
#'     )
#'   ))
#' )
#' \dontshow{notionapi::vcr_example_end()}
#' \dontshow{notionapi::vcr_example_start("notion-data-sources-update")}
#' # ----- Update data source
#' notion$data_sources$update(
#'   "34033ea0-c1e4-81a2-aaf4-000b260f79c9",
#'   properties = list(
#'     Status = list(
#'       status = list(
#'         options = list(
#'           list(
#'             name = "To do",
#'             color = "red"
#'           ),
#'           list(
#'             name = "Done",
#'             color = "green"
#'           )
#'         )
#'       )
#'     )
#'   )
#' )
#' \dontshow{notionapi::vcr_example_end()}
#' \dontshow{notionapi::vcr_example_start("notion-data-sources-retrieve")}
#' # ----- Retrieve a data source
#' notion$data_sources$retrieve("34033ea0-c1e4-81a2-aaf4-000b260f79c9")
#' \dontshow{notionapi::vcr_example_end()}
#' \dontshow{notionapi::vcr_example_start("notion-data-sources-list-templates")}
#' # ----- List data source templates
#' notion$data_sources$list_templates("34033ea0-c1e4-81a2-aaf4-000b260f79c9")
#' \dontshow{notionapi::vcr_example_end()}
#' \dontshow{notionapi::vcr_example_start("notion-data-sources-query")}
#' # ----- Query a data source
#' notion$data_sources$query(
#'   "34033ea0-c1e4-81a2-aaf4-000b260f79c9",
#'   filter = list(
#'     property = "Status",
#'     status = list(
#'       equals = "To do"
#'     )
#'   )
#' )
#' \dontshow{notionapi::vcr_example_end()}
DataSourcesEndpoint <- R6Class(
  "DataSourcesEndpoint",
  public = list(
    #' @description
    #' Initialise data sources endpoint.
    #' Not to be called directly, e.g., use `notion$datasources` instead.
    #' @param client Notion Client instance
    initialize = function(client) {
      private$.client <- client
    },

    #' @description
    #' Create a data source
    #'
    #' @param parent Named list (JSON object) (required). An object specifying
    #'   the parent of the new data source to be created.
    #' @param properties Named list (JSON object) (required). Property schema
    #'   of data source.
    #' @param title List of lists (JSON array). Title of data source.
    #' @param icon Named list (JSON object). Page icon.
    #'
    #' @details
    #' [Endpoint documentation](https://developers.notion.com/reference/create-a-data-source)
    create = function(
      parent,
      properties,
      title = NULL,
      icon = NULL
    ) {
      check_json_object(parent, TRUE)
      check_json_object(properties, TRUE)
      check_json_array(title)
      check_json_object(icon)

      body_params <- parse_body_params(
        parent = parent,
        properties = properties,
        title = title,
        icon = icon
      )

      req <- notion_build_request(
        private$.client$request(),
        "data_sources",
        "POST",
        body_params = body_params
      )

      resp <- notion_perform_req(req)

      res <- notion_handle_resp(resp)

      return(res)
    },

    #' @description
    #' Retrieve a data source
    #'
    #' @details
    #' [Endpoint documentation](https://developers.notion.com/reference/retrieve-a-data-source)
    retrieve = function(
      data_source_id
    ) {
      check_string(data_source_id, TRUE)

      req <- notion_build_request(
        private$.client$request(),
        c("data_sources", data_source_id),
        "GET"
      )

      resp <- notion_perform_req(req)

      res <- notion_handle_resp(resp)

      return(res)
    },

    #' @description
    #' List page templates available for a data source
    #'
    #' @param name Character. Name to filter templates by.
    list_templates = function(
      data_source_id,
      name = NULL,
      start_cursor = NULL,
      page_size = NULL
    ) {
      check_string(data_source_id, TRUE)
      check_string(name)
      check_string(start_cursor)
      check_int(page_size, 100)

      query_params <- parse_query_params(
        name = name,
        start_cursor = start_cursor,
        page_size = page_size
      )

      req <- notion_build_request(
        private$.client$request(),
        c("data_sources", data_source_id, "templates"),
        "GET",
        query_params,
      )

      resp <- notion_perform_req(req)

      res <- notion_handle_resp(resp)

      return(res)
    },

    #' @description
    #' Update a data source
    #'
    #' @param title List of lists (JSON array). Title of data source.
    #' @param icon Named list (JSON object). Page icon.'
    #' @param properties Named list (JSON object). Key-value pairs representing
    #'   the data source's properties.
    #' @param in_trash Boolean. Whether the database should be moved to or from the trash.
    #' @param parent Named list (JSON object). The parent of the data source,
    #'   when moving it to a different database.
    update = function(
      data_source_id,
      title = NULL,
      icon = NULL,
      properties = NULL,
      in_trash = NULL,
      parent = NULL
    ) {
      check_string(data_source_id)
      check_json_array(title)
      check_json_object(icon)
      check_json_object(properties)
      check_bool(in_trash)
      check_json_object(parent)

      body_params <- parse_body_params(
        title = title,
        icon = icon,
        properties = properties,
        in_trash = in_trash,
        parent = parent
      )

      req <- notion_build_request(
        private$.client$request(),
        c("data_sources", data_source_id),
        "PATCH",
        body_params = body_params
      )

      resp <- notion_perform_req(req)

      res <- notion_handle_resp(resp)

      return(res)
    },

    #' @description
    #' Query a data source
    #'
    #' @param filter_properties Character vector. Page property value IDs to include in the response schema.
    #'   If NULL (default), all properties are returned.
    #' @param sorts List of lists (JSON array). [Sort conditions](https://developers.notion.com/reference/sort-data-source-entries)
    #'   to apply to the query
    #' @param filter List of lists (JSON array). [Filter conditions](https://developers.notion.com/reference/filter-data-source-entries)
    #'   to apply. to the query
    #' @param in_trash Boolean. If `TRUE`, trashed pages are included in the results alongside
    #'   non-trashed pages. If `FALSE` or `NULL` (default), only non-trashed pages are returned.
    #' @param result_type Character. Filter results by type. Available options are
    #'   "page" and "data_source". If `NULL` (default), all result types are returned.
    query = function(
      data_source_id,
      filter_properties = NULL,
      sorts = NULL,
      filter = NULL,
      start_cursor = NULL,
      page_size = NULL,
      in_trash = NULL,
      result_type = NULL
    ) {
      check_string(data_source_id, TRUE)
      check_string(
        filter_properties,
        multiple = TRUE
      )
      check_json_array(sorts)
      check_json_object(filter)
      check_string(start_cursor)
      check_int(page_size, 100)
      check_bool(in_trash)
      check_string(result_type)

      query_params <- if (!is.null(filter_properties)) {
        filter_properties <- decode_query_param(filter_properties)

        query_params <- parse_repeated_query_params(
          filter_properties,
          "filter_properties"
        )
      }

      body_params <- parse_body_params(
        sorts = sorts,
        filter = filter,
        start_cursor = start_cursor,
        page_size = page_size,
        in_trash = in_trash,
        result_type = result_type
      )

      req <- notion_build_request(
        private$.client$request(),
        c("data_sources", data_source_id, "query"),
        "POST",
        query_params,
        body_params
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

#' R6 Class for Views Endpoint
#'
#' @description
#' Handle all views operations in the Notion API
#'
#' **Note:** Access this endpoint through the client instance, e.g., `notion$views`. Not to be instantiated directly.
#'
#' @param view_id ID of a Notion view.
#' @param start_cursor Character. For pagination. If provided, returns results starting from this cursor.
#'   If NULL, returns the first page of results.
#' @param page_size Integer. Number of items to return per page (1-100). Defaults to 100
#'
#' @returns A list containing the parsed API response.
#'
#' @examplesIf notion_token_exists()
#' notion <- notion_client()
#' \dontshow{notionapi::vcr_example_start("notion-views-create")}
#' # ----- Create a view
#' notion$views$create(
#'   "34033ea0-c1e4-81a2-aaf4-000b260f79c9",
#'   "Test view",
#'   "table",
#'   "efab1bec-0094-4afe-a90c-c9b72d538b4b"
#' )
#' \dontshow{notionapi::vcr_example_end()}
#' \dontshow{notionapi::vcr_example_start("notion-views-retrieve")}
#' # ----- Retrieve a view
#' notion$views$retrieve("34033ea0-c1e4-81e1-942f-000c08810f61")
#' \dontshow{notionapi::vcr_example_end()}
#' \dontshow{notionapi::vcr_example_start("notion-views-list")}
#' # ----- List views
#' notion$views$list(data_source_id = "34033ea0-c1e4-81a2-aaf4-000b260f79c9")
#' \dontshow{notionapi::vcr_example_end()}
#' \dontshow{notionapi::vcr_example_start("notion-views-update")}
#' # ----- Update a view
#' notion$views$update("34033ea0-c1e4-81e1-942f-000c08810f61", "Updated view name")
#' \dontshow{notionapi::vcr_example_end()}
#' \dontshow{notionapi::vcr_example_start("notion-views-delete")}
#' # ----- Delete a view
#' notion$views$delete("34033ea0-c1e4-81e1-942f-000c08810f61")
#' \dontshow{notionapi::vcr_example_end()}
ViewsEndpoint <- R6Class(
  "ViewsEndpoint",
  public = list(
    #' @field queries Views Queries Endpoint
    queries = NULL,

    #' @description
    #' Initialise views endpoint.
    #' Not to be called directly, e.g., use `notion$views` instead.
    #' @param client Notion Client instance
    initialize = function(client) {
      private$.client <- client
      self$queries <- ViewsQueriesEndpoint$new(client)
    },

    #' @description
    #' Create a view
    #'
    #' @param data_source_id Character (required). The ID of the data source this
    #'   view is scoped to.
    #' @param name Character (required). The name of the view.
    #' @param type Character (required). The type of view to create.
    #' @param database_id Character. The ID of the database to create a view in.
    #'   Mutually exclusive with `view_id` and `create_database`
    #' @param view_id Character. The ID of a dashboard view to add this view to
    #'   as a widget. Mutually exclusive with `database_id` and `create_database`.
    #' @param filter Named list (JSON object). Filter to apply to the view.
    #' @param sorts List of lists (JSON array). Sorts to apply to the view.
    #' @param quick_filters Named list (JSON object). Key-value pairs of quick filters
    #'  to pin in the view's filter bar.
    #' @param create_database Named list (JSON object). Create a new linked database
    #'   block and add the view to it. Mutually exclusive with `database_id` and `view_id`
    #' @param configuration Named list (JSON object). View presentation configuration.
    #' @param position Named list (JSON object). Where to place the new view
    #'   in the database's view tab bar. Only applicable when `database_id` is provided.
    #'   Defaults to "end" (append).
    #' @param placement Named list (JSON object). Where to place the new widget in a dashboard view.
    #'   Only applicable when `view_id` is provided. Defaults to creating a new row at the end.
    #'
    #' @details
    #' [Endpoint documentation](https://developers.notion.com/reference/create-view)
    create = function(
      data_source_id,
      name,
      type,
      database_id = NULL,
      view_id = NULL,
      filter = NULL,
      sorts = NULL,
      quick_filters = NULL,
      create_database = NULL,
      configuration = NULL,
      position = NULL,
      placement = NULL
    ) {
      check_exclusive(database_id, view_id, create_database, .require = TRUE)
      check_string(data_source_id, TRUE)
      check_string(name, TRUE)
      check_string(type, TRUE)
      check_string(database_id)
      check_string(view_id)
      check_json_object(filter)
      check_json_array(sorts)
      check_json_object(quick_filters)
      check_json_object(create_database)
      check_json_object(configuration)
      check_json_object(position)
      check_json_object(placement)

      body_params <- parse_body_params(
        data_source_id = data_source_id,
        name = name,
        type = type,
        database_id = database_id,
        view_id = view_id,
        filter = filter,
        sorts = sorts,
        quick_filters = quick_filters,
        create_database = create_database,
        configuration = configuration,
        position = position,
        placement = placement
      )

      req <- notion_build_request(
        private$.client$request(),
        "views",
        "POST",
        body_params = body_params
      )

      resp <- notion_perform_req(req)

      res <- notion_handle_resp(resp)

      return(res)
    },

    #' @description
    #' Retrieve a view
    #'
    #' @details
    #' [Endpoint documentation](https://developers.notion.com/reference/retrieve-a-view)
    retrieve = function(
      view_id
    ) {
      check_string(view_id, TRUE)

      req <- notion_build_request(
        private$.client$request(),
        c("views", view_id),
        "GET"
      )

      resp <- notion_perform_req(req)

      res <- notion_handle_resp(resp)

      return(res)
    },

    #' @description
    #' Update a view
    #'
    #' @param name Character. New name for the view.
    #' @param filter Named list (JSON object). Filter to apply to the view.
    #' @param sorts List of lists (JSON array). Property sorts to apply to the view.
    #' @param quick_filters Named list (JSON object). Key-value pairs of quick filters
    #'   to add/update.
    #' @param configuration Named list (JSON object). View presentation configuration.
    #'
    #' @details
    #' [Endpoint documentation](https://developers.notion.com/reference/update-a-view)
    update = function(
      view_id,
      name = NULL,
      filter = NULL,
      sorts = NULL,
      quick_filters = NULL,
      configuration = NULL
    ) {
      check_string(view_id, TRUE)
      check_string(name)
      check_json_object(filter)
      check_json_array(sorts)
      check_json_object(quick_filters)
      check_json_object(configuration)

      body_params <- parse_body_params(
        name = name,
        filter = filter,
        sorts = sorts,
        quick_filters = quick_filters,
        configuration = configuration
      )

      req <- notion_build_request(
        private$.client$request(),
        c("views", view_id),
        "PATCH",
        body_params = body_params
      )

      resp <- notion_perform_req(req)

      res <- notion_handle_resp(resp)

      return(res)
    },

    #' @description
    #' Delete a view
    #'
    #' @details
    #' [Endpoint documentation](https://developers.notion.com/reference/delete-view)
    delete = function(
      view_id
    ) {
      check_string(view_id, TRUE)

      req <- notion_build_request(
        private$.client$request(),
        c("views", view_id),
        "DELETE"
      )

      resp <- notion_perform_req(req)

      res <- notion_handle_resp(resp)

      return(res)
    },

    #' @description
    #' List all views in a database
    #'
    #' @param database_id Character. ID of a Notion database to list views for.
    #'   At least one of `database_id` or `data_source_id` is required.
    #' @param data_source_id Character. ID of a data source to list all views for,
    #'   including linked views across the workspace. At least one of `database_id`
    #'   or `data_source_id` is required.
    #'
    #' @details
    #' [Endpoint documentation](https://developers.notion.com/reference/list-views)
    list = function(
      database_id = NULL,
      data_source_id = NULL,
      start_cursor = NULL,
      page_size = NULL
    ) {
      check_exclusive(database_id, data_source_id, .require = TRUE)
      check_string(database_id)
      check_string(data_source_id)
      check_string(start_cursor)
      check_int(page_size, 100, FALSE)

      query_params <- parse_query_params(
        database_id = database_id,
        data_source_id = data_source_id,
        start_cursor = start_cursor,
        page_size = page_size
      )

      req <- notion_build_request(
        private$.client$request(),
        c("views"),
        "GET",
        query_params
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

#' R6 Class for Views Queries Endpoint
#'
#' @description
#' Handle all views queries operations in the Notion API
#'
#' **Note:** Access this endpoint through the client instance, e.g., `notion$views$queries`. Not to be instantiated directly.
#'
#' @param view_id Character (required). The ID of the view.
#' @param query_id Character (required). The ID of the query.
#'
#' @returns A list containing the parsed API response.
#'
#' @examplesIf notion_token_exists()
#' notion <- notion_client()
#' \dontshow{notionapi::vcr_example_start("notion-views-queries-create")}
#' # ----- Create a view query
#' notion$views$queries$create("34033ea0-c1e4-81e1-942f-000c08810f61")
#' \dontshow{notionapi::vcr_example_end()}
#' \dontshow{notionapi::vcr_example_start("notion-views-queries-results")}
#' # ----- Get view query results
#' notion$views$queries$results(
#'   "34033ea0-c1e4-81e1-942f-000c08810f61",
#'   "a966d86e-5211-47cb-8a1e-f05bc0a33494"
#' )
#' \dontshow{notionapi::vcr_example_end()}
#' \dontshow{notionapi::vcr_example_start("notion-views-queries-delete")}
#' # ----- Delete a view query
#' notion$views$queries$delete(
#'   "34033ea0-c1e4-81e1-942f-000c08810f61",
#'   "a966d86e-5211-47cb-8a1e-f05bc0a33494"
#' )
#' \dontshow{notionapi::vcr_example_end()}
ViewsQueriesEndpoint <- R6Class(
  "ViewsQueriesEndpoint",
  public = list(
    #' @description
    #' Initialise pages properties endpoint.
    #' Not to be called directly, e.g., use `notion$views$queries` instead.
    #' @param client Notion Client instance
    initialize = function(client) {
      private$.client <- client
    },

    #' @description
    #' Create a view query
    #'
    #' @param page_size Integer. Number of items to return per page (1-100). Defaults to 100.
    #' @details
    #' [Endpoint documentation](https://developers.notion.com/reference/create-view-query)
    create = function(
      view_id,
      page_size = NULL
    ) {
      check_string(view_id, TRUE)
      check_int(page_size, 100)

      body_params <- parse_body_params(
        page_size = page_size
      )

      req <- notion_build_request(
        private$.client$request(),
        c("views", view_id, "queries"),
        "POST",
        body_params = body_params
      )

      resp <- notion_perform_req(req)

      res <- notion_handle_resp(resp)

      return(res)
    },

    #' @description
    #' Get view query results
    #'
    #' @param start_cursor Character. For pagination. If provided, returns results starting from this cursor.
    #'   If NULL, returns the first page of results.
    #' @param page_size Integer. Number of items to return per page (1-100). Defaults to 100
    #'
    #' @details
    #' [Endpoint documentation](https://developers.notion.com/reference/get-view-query-results)
    results = function(
      view_id,
      query_id,
      start_cursor = NULL,
      page_size = NULL
    ) {
      check_string(view_id, TRUE)
      check_string(query_id, TRUE)
      check_string(start_cursor)
      check_int(page_size, 100)

      query_params <- parse_query_params(
        start_cursor = start_cursor,
        page_size = page_size
      )

      req <- notion_build_request(
        private$.client$request(),
        c("views", view_id, "queries", query_id),
        "GET",
        query_params = query_params
      )

      resp <- notion_perform_req(req)

      res <- notion_handle_resp(resp)

      return(res)
    },

    #' @description
    #' Delete a view query
    #'
    #' @details
    #' [Endpoint documentation](https://developers.notion.com/reference/delete-view-query)
    delete = function(
      view_id,
      query_id
    ) {
      check_string(view_id, TRUE)
      check_string(query_id, TRUE)

      req <- notion_build_request(
        private$.client$request(),
        c("views", view_id, "queries", query_id),
        "DELETE"
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

#' R6 Class for File Uploads Endpoint
#'
#' @description
#' Handle all file uploads operations in the Notion API
#'
#' **Note:** Access this endpoint through the client instance, e.g., `notion$file_uploads`. Not to be instantiated directly.
#'
#' @param file_upload_id Character (required). Identifier for a Notion file upload object.
#' @returns A list containing the parsed API response.
#'
#' @examplesIf notion_token_exists()
#' notion <- notion_client()
#' \dontshow{notionapi::vcr_example_start("notion-file-uploads-single-part")}
#' # ----- Direct upload (files <= 20MB)
#' # Step 1: Create a File Upload object
#' (resp <- notion$file_uploads$create("single_part"))
#' file_upload_id <- resp[["id"]]
#'
#' # Step 2: Upload file contents
#' #* replace with your file
#' path <- file.path(tempdir(), "test.pdf")
#' writeBin(charToRaw("placeholder"), path)
#' raw <- readBin(path, "raw", file.size(path))
#'
#' notion$file_uploads$send(
#'   file_upload_id,
#'   list(
#'     filename = basename(path),
#'     data = raw
#'   )
#' )
#'
#' # Retrieve the file upload
#' notion$file_uploads$retrieve(file_upload_id)
#' \dontshow{notionapi::vcr_example_end()}
#' \dontshow{notionapi::vcr_example_start("notion-file-uploads-multi-part")}
#' # ----- Multi-part upload (files > 20MB)
#' # Step 1: Split raw content into parts
#' #* replace with your file
#' raw <- as.raw(rep(65L, 11 * 1024 * 1024))
#' mid <- ceiling(length(raw) / 2)
#' parts <- list(raw[seq_len(mid)], raw[seq(mid + 1L, length(raw))])
#'
#' # Step 2: Create a File Upload object
#' (resp <- notion$file_uploads$create(
#'   mode = "multi_part",
#'   filename = "test-large.txt",
#'   number_of_parts = 2L
#' ))
#' file_upload_id <- resp[["id"]]
#'
#' # Step 3: Send each part
#' for (i in seq_along(parts)) {
#'   notion$file_uploads$send(
#'     file_upload_id,
#'     file = list(
#'       filename = "test-large.txt",
#'       data = parts[[i]]
#'     ),
#'     part_number = as.character(i)
#'   )
#' }
#'
#' # Step 4: Complete the upload
#' notion$file_uploads$complete(
#'   file_upload_id
#' )
#'
#' # Retrieve the file upload
#' notion$file_uploads$retrieve(
#'   file_upload_id
#' )
#' \dontshow{notionapi::vcr_example_end()}
#' \dontshow{notionapi::vcr_example_start("notion-file-uploads-external-url")}
#' # ----- Import external files
#' notion$file_uploads$create(
#'   "external_url",
#'   "dummy.pdf",
#'   content_type = "application/pdf",
#'   external_url = "https://github.com/brenwin1/notionapi/blob/main/tests/testthat/test.pdf"
#' )
#' \dontshow{notionapi::vcr_example_end()}
FileUploadsEndpoint <- R6Class(
  "FileUploadsEndpoint",

  public = list(
    #' @description
    #' Initialise file uploads endpoint.
    #' Not to be called directly, e.g., use `notion$file_uploads` instead.
    #' @param client Notion Client instance
    initialize = function(client) {
      private$.client <- client
    },

    #' @description
    #' Create a file upload
    #'
    #' @param mode Character. How the file is being sent. Use "multi_part" for
    #'   files larger than 20MB. Use "external_url" for files that are temporarily
    #'   hosted publicly elsewhere. Default is "single_part".
    #' @param filename Character. Name of the file to be created. Required when `mode`
    #'   is "multi_part". Must include an extension, or have one inferred from
    #'   the `content_type` parameter.
    #' @param content_type Character. MIME type of the file to be created.
    #' @param number_of_parts Integer. When `mode` is "multi_part", the number of parts
    #'   you are uploading.
    #' @param external_url Character. When `mode` is "external_url", provide the
    #'   HTTPS URL of a publicly accessible file to import into your workspace.
    create = function(
      mode = NULL,
      filename = NULL,
      content_type = NULL,
      number_of_parts = NULL,
      external_url = NULL
    ) {
      check_string(mode)
      check_string(filename)
      check_string(content_type)
      check_int(number_of_parts, 10000)
      check_string(external_url)

      body_params <- parse_body_params(
        mode = mode,
        filename = filename,
        content_type = content_type,
        number_of_parts = number_of_parts,
        external_url = external_url
      )

      req <- notion_build_request(
        private$.client$request(),
        c("file_uploads"),
        "POST",
        body_params = body_params
      )

      resp <- notion_perform_req(req)

      res <- notion_handle_resp(resp)

      return(res)
    },

    #' @description
    #' Upload a file
    #'
    #' @param file Named list (JSON object). The raw binary file contents to upload.
    #'   Must contain named elements:
    #'  * `filename`. Character. The name of the file, including it's extension (e.g., "report.pdf")
    #'  * `data`. Raw. The binary contents of the file, as returned by e.g., `readBin()`
    #'  * `type`. Character. Optional. The MIME type of the file (e.g., "application/pdf", "image/png").
    #'    If not supplied, the type is inferred from `filename` by `curl::form_file()`.
    #'    Supported file types are listed [here](https://developers.notion.com/guides/data-apis/working-with-files-and-media#supported-file-types).
    #' @param part_number Character. The current part number when uploading files greater
    #'   than 20MB in parts. Must be an integer between 1 and 1,000
    send = function(
      file_upload_id,
      file,
      part_number = NULL
    ) {
      check_string(file_upload_id, TRUE)
      check_json_object(file, TRUE)
      check_string(part_number)

      req <- notion_build_request(
        private$.client$request(),
        c("file_uploads", file_upload_id, "send"),
        "POST"
      )

      tmp <- tempfile(
        fileext = paste0(
          ".",
          tools::file_ext(file[["filename"]])
        )
      )

      on.exit(
        unlink(tmp)
      )

      writeBin(file[["data"]], tmp)

      multipart_params <- list(
        file = curl::form_file(
          tmp,
          file[["type"]],
          file[["filename"]]
        )
      )

      if (!is.null(part_number)) {
        multipart_params[["part_number"]] <- part_number
      }

      req <- httr2::req_body_multipart(
        req,
        !!!multipart_params
      )

      resp <- notion_perform_req(req)

      res <- notion_handle_resp(resp)

      return(res)
    },

    #' @description
    #' Complete a multi-part file upload
    #'
    #' @details
    #' [Endpoint documentation](https://developers.notion.com/reference/complete-file-upload)
    complete = function(
      file_upload_id
    ) {
      check_string(
        file_upload_id,
        TRUE
      )

      req <- notion_build_request(
        private$.client$request(),
        c("file_uploads", file_upload_id, "complete"),
        "POST"
      )

      resp <- notion_perform_req(req)

      res <- notion_handle_resp(resp)

      return(res)
    },

    #' @description
    #' Retrieve a file upload
    #'
    #' @details
    #' [Endpoint documentation](https://developers.notion.com/reference/retrieve-file-upload)
    retrieve = function(
      file_upload_id
    ) {
      check_string(
        file_upload_id,
        TRUE
      )

      req <- notion_build_request(
        private$.client$request(),
        c("file_uploads", file_upload_id)
      )

      resp <- notion_perform_req(req)

      res <- notion_handle_resp(resp)

      return(res)
    },

    #' @description
    #' List file uploads
    #'
    #' @param status Character. If supplied, the endpoint will return file uploads with the specified status.
    #'   Available options are "pending", "uploaded", "expired", "failed".
    #' @param start_cursor Character. For pagination. If provided, returns results starting from this cursor.
    #'   If NULL, returns the first page of results.
    #' @param page_size Integer. Number of items to return per page (1-100). Defaults to 100
    #'
    #' @details
    #' [Endpoint documentation](https://developers.notion.com/reference/list-file-uploads)
    list = function(
      status = NULL,
      start_cursor = NULL,
      page_size = NULL
    ) {
      check_string(status)
      check_string(start_cursor)
      check_int(page_size, 100)

      query_params <- parse_query_params(
        status = status,
        start_cursor = start_cursor,
        page_size = page_size
      )

      req <- notion_build_request(
        private$.client$request(),
        c("file_uploads"),
        "GET",
        query_params = query_params
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
#' \dontshow{notionapi::vcr_example_start("notion-comments-create")}
#' # ----- Create comment
#' notion$comments$create(
#'   parent = list(
#'     page_id = "34033ea0-c1e4-8181-a411-fcffc69c690a"
#'   ),
#'   rich_text = list(
#'     list(
#'       text = list(
#'         content = "Hello world!"
#'       )
#'     )
#'   )
#' )
#' \dontshow{notionapi::vcr_example_end()}
#' \dontshow{notionapi::vcr_example_start("notion-comments-retrieve")}
#' # ----- Retrieve comment
#' notion$comments$retrieve("34033ea0-c1e4-81a9-ba52-001d7629e201")
#' \dontshow{notionapi::vcr_example_end()}
#' \dontshow{notionapi::vcr_example_start("notion-comments-list")}
#' # ----- List un-resolved comments from a page or block
#' notion$comments$list("34033ea0-c1e4-8181-a411-fcffc69c690a")
#' \dontshow{notionapi::vcr_example_end()}
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
    #' @param rich_text List of lists (JSON array) (required). [Rich text object(s)](https://developers.notion.com/reference/rich-text) representing the content of the comment.
    #' @param parent List (JSON object). The parent of the comment. This can be a page or a block.
    #'   Required if `discussion_id` is not provided.
    #' @param discussion_id Character. The ID of the discussion to comment on.
    #'   Required if `parent` is not provided.
    #' @param attachments List of lists (JSON array). An array of files to attach to the comment. Maximum of 3 allowed.
    #' @param display_name Named list (JSON object). Display name for the comment.
    #'
    #' @details
    #' [Endpoint documentation](https://developers.notion.com/reference/create-a-comment)
    create = function(
      rich_text,
      parent = NULL,
      discussion_id = NULL,
      attachments = NULL,
      display_name = NULL
    ) {
      check_exclusive(parent, discussion_id, .require = TRUE)
      check_json_array(rich_text, TRUE)
      check_json_object(parent)
      check_string(discussion_id)
      check_json_array(attachments)
      check_json_object(display_name)

      body_params <- parse_body_params(
        rich_text = rich_text,
        parent = parent,
        discussion_id = discussion_id,
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
    #' @param comment_id Character (required). The ID of the comment to retrieve.
    #'
    #' @details
    #' [Endpoint documentation](https://developers.notion.com/reference/retrieve-a-comment)
    retrieve = function(
      comment_id
    ) {
      check_string(comment_id, TRUE)

      req <- notion_build_request(
        private$.client$request(),
        c("comments", comment_id),
        "GET"
      )

      resp <- notion_perform_req(req)

      res <- notion_handle_resp(resp)

      res
    },
    #' @description
    #' List comments
    #'
    #' @param block_id Character (required). The ID for a Notion block or page.
    #' @param start_cursor Character. For pagination. If provided, returns results starting from this cursor.
    #'   If NULL, returns the first page of results.
    #' @param page_size Integer. Number of items to return per page (1-100). Defaults to 100.
    list = function(
      block_id,
      start_cursor = NULL,
      page_size = NULL
    ) {
      check_string(block_id, TRUE)
      check_string(start_cursor, FALSE)
      check_int(page_size, 100)

      query_params <- parse_query_params(
        block_id = block_id,
        start_cursor = start_cursor,
        page_size = page_size
      )

      req <- notion_build_request(
        private$.client$request(),
        "comments",
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
#' \dontshow{notionapi::vcr_example_start("notion-users-list")}
#' # ----- List all users
#' notion$users$list()
#' \dontshow{notionapi::vcr_example_end()}
#' \dontshow{notionapi::vcr_example_start("notion-users-retrieve")}
#' # ----- Retrieve a user
#' notion$users$retrieve("fda12729-108d-4eb5-bbfb-a8f0886794d1")
#' \dontshow{notionapi::vcr_example_end()}
#' \dontshow{notionapi::vcr_example_start("notion-users-me")}
#' # ----- Retrieve the bot User associated with the API token
#' notion$users$me()
#' \dontshow{notionapi::vcr_example_end()}
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

#' R6 Class for Custom Emojis Endpoint
#'
#' @description
#' Handle all custom emojis operations in the Notion API
#'
#' **Note:** Access this endpoint through the client instance, e.g., `notion$custom_emojis`. Not to be instantiated directly.
#'
#' @returns A list containing the parsed API response.
#'
#' @examplesIf notion_token_exists()
#' notion <- notion_client()
#' \dontshow{notionapi::vcr_example_start("notion-custom-emojis-list")}
#' notion$custom_emojis$list()
#' \dontshow{notionapi::vcr_example_end()}
CustomEmojisEndpoint <- R6Class(
  "CustomEmojisEndpoint",
  public = list(
    #' @description
    #' Initialise custom emojis endpoint.
    #' Not to be called directly, e.g., use `notion$custom_emojis` instead.
    #' @param client Notion Client instance
    initialize = function(client) {
      private$.client <- client
    },

    #' @description
    #' List custom emojis
    #'
    #' @param start_cursor Character. For pagination. If provided, returns results starting from this cursor.
    #'   If NULL, returns the first page of results.
    #' @param page_size Integer. Number of items to return per page (1-100). Defaults to 100
    #' @param name Character. Filters custom emojis by exact name match.
    #'   Useful for resolving a custom emoji name to its ID.
    #'
    #' @details
    #' [Endpoint documentation](https://developers.notion.com/reference/list-custom-emojis)
    list = function(
      start_cursor = NULL,
      page_size = NULL,
      name = NULL
    ) {
      check_string(start_cursor)
      check_int(page_size, 100)
      check_string(name)

      query_params <- parse_query_params(
        start_cursor = start_cursor,
        page_size = page_size,
        name = name
      )

      req <- notion_build_request(
        private$.client$request(),
        "custom_emojis",
        "GET",
        query_params
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
