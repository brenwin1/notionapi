# Notion API client

Main client for interacting with Notion API. This R6 class provides
access to all Notion API endpoints through organised sub-objects.

### Client Types

- `notion_client()`: Create a synchronous client (blocks until requests
  complete)

- `async_notion_client()`: Create an asynchronous client (non-blocking)

Both clients provide identical interfaces, with the async client
inheriting all methods from synchronous client. The only difference is
that async methods return
[`promises`](https://rstudio.github.io/promises/) instead of results
directly.

## Usage

``` r
notion_client(
  auth = NULL,
  base_url = getOption("notionapi.base_url"),
  version = getOption("notionapi.version"),
  timeout = 60000
)

async_notion_client(
  auth = NULL,
  base_url = getOption("notionapi.base_url"),
  version = getOption("notionapi.version"),
  timeout = 60000
)
```

## Value

A Notion API client instance

## Configuration fields

- `auth`: Authentication token. Defaults to NOTION_TOKEN environment
  variable

- `base_url`: Base URL for Notion API (defaults to
  `getOption("notionapi.base_url")`)

- `version`: Notion API version (defaults to
  `getOption("notionapi.version")`)

- `timeout`: Timeout for requests in milliseconds (defaults to 60000, or
  60 seconds)

## Endpoints

- `blocks`: Blocks endpoint object
  ([BlocksEndpoint](https://brenwin1.github.io/notionapi/reference/BlocksEndpoint.md))

  - `blocks$children`: Blocks children endpoint object
    ([BlocksChildrenEndpoint](https://brenwin1.github.io/notionapi/reference/BlocksChildrenEndpoint.md))

- `pages`: Pages endpoint object
  ([PagesEndpoint](https://brenwin1.github.io/notionapi/reference/PagesEndpoint.md))

  - `pages$properties`: Pages properties endpoint object
    ([PagesPropertiesEndpoint](https://brenwin1.github.io/notionapi/reference/PagesPropertiesEndpoint.md))

- `databases`: Databases endpoint object
  ([DatabasesEndpoint](https://brenwin1.github.io/notionapi/reference/DatabasesEndpoint.md))

- `data_sources`: Data sources endpoint object
  ([DataSourcesEndpoint](https://brenwin1.github.io/notionapi/reference/DataSourcesEndpoint.md))

- `views`: Views endpoint object
  ([ViewsEndpoint](https://brenwin1.github.io/notionapi/reference/ViewsEndpoint.md))

  - `views$queries`: Views queries endpoint object
    ([ViewsQueriesEndpoint](https://brenwin1.github.io/notionapi/reference/ViewsQueriesEndpoint.md))

- `file_uploads`: File uploads endpoint object
  ([FileUploadsEndpoint](https://brenwin1.github.io/notionapi/reference/FileUploadsEndpoint.md))

- `comments`: Comments endpoint object
  ([CommentsEndpoint](https://brenwin1.github.io/notionapi/reference/CommentsEndpoint.md))

- `search`: Search endpoint (see `NotionClient$search()` method below)

- `users`: Users endpoint object
  ([UsersEndpoint](https://brenwin1.github.io/notionapi/reference/UsersEndpoint.md))

- `custom_emojis`: Custom emojis endpoint object
  ([CustomEmojisEndpoint](https://brenwin1.github.io/notionapi/reference/CustomEmojisEndpoint.md))

## See also

[Notion API documentation](https://developers.notion.com/reference)

## Public fields

- `base_url`:

  Base URL for Notion API

- `version`:

  Notion API version

- `blocks`:

  Blocks endpoint object

- `pages`:

  Pages endpoint object

- `databases`:

  Databases endpoint object

- `data_sources`:

  Data sources endpoint object

- `views`:

  Views endpoint object

- `file_uploads`:

  File uploads endpoint object

- `comments`:

  Comments endpoint object

- `users`:

  Users endpoint object

- `custom_emojis`:

  Custom emojis endpoint object

## Methods

### Public methods

- [`NotionClient$new()`](#method-NotionClient-new)

- [`NotionClient$request()`](#method-NotionClient-request)

- [`NotionClient$print()`](#method-NotionClient-print)

- [`NotionClient$search()`](#method-NotionClient-search)

------------------------------------------------------------------------

### Method `new()`

Initialise Notion Client

#### Usage

    NotionClient$new(
      auth = NULL,
      base_url = getOption("notionapi.base_url"),
      version = getOption("notionapi.version"),
      timeout = 60000
    )

#### Arguments

- `auth`:

  Authentication token. Uses NOTION_TOKEN environment variable by
  default.

- `base_url`:

  Character. Base URL for Notion API.

- `version`:

  Character. Notion API version.

- `timeout`:

  Numeric. Number of milliseconds to wait before timing out a request.

------------------------------------------------------------------------

### Method `request()`

Create a base `httr2` request object for the Notion API.

This method is primarily for advanced users who want to make custom API
calls or for debugging purposes. Most users should use the endpoint
methods instead.

#### Usage

    NotionClient$request()

#### Returns

httr2 request object

------------------------------------------------------------------------

### Method [`print()`](https://rdrr.io/r/base/print.html)

Print basic details of Notion Client

#### Usage

    NotionClient$print()

------------------------------------------------------------------------

### Method [`search()`](https://rdrr.io/r/base/search.html)

Search all parent or child pages and databases shared with an
integration

#### Usage

    NotionClient$search(
      sort = NULL,
      query = NULL,
      start_cursor = NULL,
      page_size = NULL,
      filter = NULL
    )

#### Arguments

- `sort`:

  Named list (JSON object). Sort condition to apply to the search
  results.

- `query`:

  Character. The search query string.

- `start_cursor`:

  Character. For pagination. If provided, returns results starting from
  this cursor. If NULL, returns the first page of results.

- `page_size`:

  Integer. Number of items to return per page (1-100). Defaults to 100.

- `filter`:

  List (JSON object). Filter condition to apply to the search results.

#### Details

[Endpoint
documentation](https://developers.notion.com/reference/post-search)

## Super class

`notionapi::NotionClient` -\> `AsyncNotionClient`

## Methods

### Public methods

- [`AsyncNotionClient$new()`](#method-AsyncNotionClient-new)

- [`AsyncNotionClient$request()`](#method-AsyncNotionClient-request)

- [`AsyncNotionClient$print()`](#method-AsyncNotionClient-print)

Inherited methods

- [`notionapi::NotionClient$search()`](https://brenwin1.github.io/notionapi/reference/NotionClient.html#method-search)

------------------------------------------------------------------------

### Method `new()`

Initialise Async Notion Client

#### Usage

    AsyncNotionClient$new(
      auth = NULL,
      base_url = getOption("notionapi.base_url"),
      version = getOption("notionapi.version"),
      timeout = 60000
    )

#### Arguments

- `auth`:

  Authentication token. Uses NOTION_TOKEN environment variable by
  default.

- `base_url`:

  Character. Base URL for Notion API.

- `version`:

  Character. Notion API version.

- `timeout`:

  Numeric. Number of milliseconds to wait before timing out a request.

------------------------------------------------------------------------

### Method `request()`

Create a base `httr2` request object for the Notion API.

This method is primarily for advanced users who want to make custom API
calls or for debugging purposes. Most users should use the endpoint
methods instead.

#### Usage

    AsyncNotionClient$request()

#### Returns

httr2 request object

------------------------------------------------------------------------

### Method [`print()`](https://rdrr.io/r/base/print.html)

Print basic details of Notion Client

#### Usage

    AsyncNotionClient$print()

## Examples

``` r
# ----- Create a Notion client with default configuration
notion <- notion_client()
# ----- Search for pages and databases
notion$search(
  query = "Test Page for notionapi",
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
#> {
#>   "object": "list",
#>   "results": [
#>     {
#>       "object": "page",
#>       "id": "22f33ea0-c1e4-80b9-9c77-d1ab72aedff9",
#>       "created_time": "2025-07-13T12:29:00.000Z",
#>       "last_edited_time": "2026-04-12T08:11:00.000Z",
#>       "created_by": {
#>         "object": "user",
#>         "id": "fda12729-108d-4eb5-bbfb-a8f0886794d1"
#>       },
#>       "last_edited_by": {
#>         "object": "user",
#>         "id": "6b786605-e456-4237-9c61-5efaff23c081"
#>       },
#>       "cover": {},
#>       "icon": {
#>         "type": "emoji",
#>         "emoji": "#️⃣"
#>       },
#>       "parent": {
#>         "type": "block_id",
#>         "block_id": "21e33ea0-c1e4-8014-963b-cc5ecf889b84"
#>       },
#>       "in_trash": false,
#>       "is_archived": false,
#>       "is_locked": false,
#>       "properties": {
#>         "title": {
#>           "id": "title",
#>           "type": "title",
#>           "title": [
#>             {
#>               "type": "text",
#>               "text": {
#>                 "content": "Test Page Parent",
#>                 "link": {}
#>               },
#>               "annotations": {
#>                 "bold": false,
#>                 "italic": false,
#>                 "strikethrough": false,
#>                 "underline": false,
#>                 "code": false,
#>                 "color": "default"
#>               },
#>               "plain_text": "Test Page Parent",
#>               "href": {}
#>             }
#>           ]
#>         }
#>       },
#>       "url": "https://www.notion.so/Test-Page-Parent-22f33ea0c1e480b99c77d1ab72aedff9",
#>       "public_url": {}
#>     }
#>   ],
#>   "next_cursor": "34033ea0-c1e4-8181-a411-fcffc69c690a",
#>   "has_more": true,
#>   "type": "page_or_data_source",
#>   "page_or_data_source": {},
#>   "request_id": "9a1e7078-93ef-41b2-8975-cc28feb8155e"
#> } 

# ----- Async client
if (FALSE) { # \dontrun{
library(promises)
async_notion <- async_notion_client()

# Start multiple requests simultaneously (non-blocking)
p1 <- async_notion$search(
  query = "Testing",
  page_size = 1
)

p2 <- async_notion$users$me()

# Returns a promise object, not particularly useful on its own
p1
p2

# Use promise chaining functions to process results as they complete
p1 %...>%
  print()

p2 %...>%
  print()

# See the [promises package documentation](https://rstudio.github.io/promises/)
# for more information on working with promises
} # }
```
