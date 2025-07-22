#' @rdname NotionClient
#'
#' @export
notion_client <- function(
  auth = NULL,
  base_url = getOption("notionapi.base_url"),
  version = getOption("notionapi.version"),
  timeout = 60000
) {
  NotionClient$new(
    auth,
    base_url,
    version,
    timeout
  )
}


#' @rdname NotionClient
#'
#' @export
async_notion_client <- function(
  auth = NULL,
  base_url = getOption("notionapi.base_url"),
  version = getOption("notionapi.version"),
  timeout = 60000
) {
  AsyncNotionClient$new(
    auth,
    base_url,
    version,
    timeout
  )
}

#' Notion API client
#'
#' @description
#' Main client for interacting with Notion API. This R6 class provides
#' access to all Notion API endpoints through organised sub-objects.
#'
#' ## Client Types
#'
#' - `notion_client()`: Create a synchronous client (blocks until requests complete)
#' - `async_notion_client()`: Create an asynchronous client (non-blocking)
#'
#' Both clients provide identical interfaces, with the async client inheriting all methods from synchronous client.
#' The only difference is that async methods return [`promises`](https://rstudio.github.io/promises/) instead of results directly.
#'
#' # Configuration fields
#'
#' - `auth`: Authentication token. Defaults to NOTION_TOKEN environment variable
#' - `base_url`: Base URL for Notion API (defaults to `getOption("notionapi.base_url")`)
#' - `version`: Notion API version (defaults to `getOption("notionapi.version")`)
#' - `timeout`: Timeout for requests in milliseconds (defaults to 60000, or 60 seconds)
#'
#' # Endpoints
#'
#' - `blocks`: Blocks endpoint object ([BlocksEndpoint])
#'   - `blocks$children`: Blocks children endpoint object ([BlocksChildrenEndpoint])
#' - `pages`: Pages endpoint object ([PagesEndpoint])
#'   - `pages$properties`: Pages properties endpoint object ([PagesPropertiesEndpoint])
#' - `databases`: Databases endpoint object ([DatabasesEndpoint])
#' - `comments`: Comments endpoint object ([CommentsEndpoint])
# #' - `file_uploads`: File Uploads endpoint object (not implemented (yet))
#' - `search`: Search endpoint (see `NotionClient$search()` method below)
#' - `users`: Users endpoint object ([UsersEndpoint])
#'
#' @seealso [Notion API documentation](https://developers.notion.com/reference)
#' @export
#'
#' @examples
#' # ----- Create a Notion client with default configuration
#' notion <- notion_client()
#'
#' # search for pages and databases
#' \dontshow{notionapi:::vcr_example_start("notion-search")}
#' notion$search(
#'   "Test Page 2025-07-15",
#'   page_size = 1,
#'   filter = list(
#'     value = "page",
#'     property = "object"
#'   ),
#'   sort = list(
#'     direction = "descending",
#'     timestamp = "last_edited_time"
#'   )
#' )
#' \dontshow{notionapi:::vcr_example_end()}
#'
#' # ----- Async client
#' \dontrun{
#' library(promises)
#' async_notion <- async_notion_client()
#'
#' # Start multiple requests simultaneously (non-blocking)
#' p1 <- async_notion$search(
#'   query = "Testing",
#'   page_size = 1
#' )
#'
#' p2 <- async_notion$users$me()
#'
#' # Returns a promise object, not particularly useful on its own
#' p1
#' p2
#'
#' # Use promise chaining functions to process results as they complete
#' p1 %...>%
#'   print()
#'
#' p2 %...>%
#'   print()
#'
#' # See the [promises package documentation](https://rstudio.github.io/promises/)
#' # for more information on working with promises
#' }
NotionClient <- R6Class(
  "NotionClient",

  list(
    #' @field base_url Base URL for Notion API
    base_url = NULL,
    #' @field version Notion API version
    version = NULL,

    #' @field blocks Blocks endpoint object
    blocks = NULL,
    #' @field pages Pages endpoint object
    pages = NULL,
    #' @field databases Databases endpoint object
    databases = NULL,
    #' @field comments Comments endpoint object
    comments = NULL,

    # #' @field file_uploads File Uploads endpoint object
    # file_uploads = NULL,

    #' @field users Users endpoint object
    users = NULL,

    #' @description
    #' Initialise Notion Client
    #' @param auth Authentication token. Uses NOTION_TOKEN environment variable by default.
    #' @param base_url Character. Base URL for Notion API.
    #' @param version Character. Notion API version.
    #' @param timeout Numeric. Number of milliseconds to wait before timing out a request.
    #' @keywords internal
    initialize = function(
      auth = NULL,
      base_url = "https://api.notion.com/v1/",
      version = getOption("notionapi.version"),
      timeout = 60000
    ) {
      private$.auth <- .notion_token(auth)
      self$base_url <- base_url
      self$version <- version
      private$.timeout <- timeout / 1000

      self$blocks <- BlocksEndpoint$new(self)
      self$pages <- PagesEndpoint$new(self)
      self$databases <- DatabasesEndpoint$new(self)
      self$comments <- CommentsEndpoint$new(self)
      # self$file_uploads <- FileUploadsEndpoint$new(self)
      self$users <- UsersEndpoint$new(self)
    },

    #' @description
    #' Create a base `httr2` request object for the Notion API.
    #'
    #' This method is primarily for advanced users who want to make custom API calls
    #' or for debugging purposes. Most users should use the endpoint methods instead.
    #' @return httr2 request object
    request = function() {
      req <- notion_request(
        private$.auth,
        self$base_url,
        self$version,
        private$.timeout,
        "notion_req"
      )

      req
    },

    #' @description
    #' Print basic details of Notion Client
    print = function() {
      cat("Notion Client\n")
      cat("  Base URL: ", self$base_url, "\n")
      cat("  Version: ", self$version, "\n")

      invisible(self)
    },

    #' @description
    #' Search all parent or child pages and databases shared with an integration
    #'
    #' @param query Character. The search query string.
    #' @param sort Named list (JSON object). Sort condition to apply to the search results.
    #' @param filter List (JSON object). Filter condition to apply to the search results.
    #' @param page_size Integer. Number of items to return per page (1-100). Defaults to 100.
    #' @param start_cursor Character. For pagination. If provided, returns results starting from this cursor.
    #'   If NULL, returns the first page of results.
    search = function(
      query = NULL,
      sort = NULL,
      filter = NULL,
      start_cursor = NULL,
      page_size = NULL
    ) {
      check_string(query, FALSE, FALSE)
      check_json_object(sort, required = FALSE)
      check_json_object(filter, FALSE)
      check_string(start_cursor, FALSE)
      check_int(page_size, 100, FALSE)

      body_params <- parse_body_params(
        query = query,
        sort = sort,
        filter = filter,
        start_cursor = start_cursor,
        page_size = page_size
      )

      req <- notion_build_request(
        self$request(),
        "search",
        "POST",
        body_params = body_params
      )

      resp <- notion_perform_req(req)

      res <- notion_handle_resp(resp)

      return(res)
    }
  ),
  list(
    .auth = NULL,
    .timeout = NULL
  ),
  cloneable = FALSE
)

#' @rdname NotionClient
#'
#' @export
AsyncNotionClient <- R6Class(
  "AsyncNotionClient",
  inherit = NotionClient,
  public = list(
    #' @description
    #' Initialise Async Notion Client
    #' @param auth Authentication token. Uses NOTION_TOKEN environment variable by default.
    #' @param base_url Character. Base URL for Notion API.
    #' @param version Character. Notion API version.
    #' @param timeout Numeric. Number of milliseconds to wait before timing out a request.
    #' @keywords internal
    initialize = function(
      auth = NULL,
      base_url = "https://api.notion.com/v1/",
      version = getOption("notionapi.version"),
      timeout = 60000
    ) {
      check_installed("promises")

      super$initialize(
        auth,
        base_url,
        version,
        timeout
      )
    },

    #' @description
    #' Create a base `httr2` request object for the Notion API.
    #'
    #' This method is primarily for advanced users who want to make custom API calls
    #' or for debugging purposes. Most users should use the endpoint methods instead.
    #' @return httr2 request object
    request = function() {
      req <- notion_request(
        private$.auth,
        self$base_url,
        self$version,
        private$.timeout,
        "notion_async_req"
      )

      req
    },

    #' @description
    #' Print basic details of Notion Client
    print = function() {
      cat("Async Notion Client\n")
      cat("  Base URL: ", self$base_url, "\n")
      cat("  Version: ", self$version, "\n")

      invisible(self)
    }
  ),
  cloneable = FALSE
)
