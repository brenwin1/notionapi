# R6 Class for Blocks children endpoint

Handle all block children operations in the Notion API

**Note:** Access this endpoint through the client instance, e.g.,
`notion$blocks$children`. Not to be instantiated directly.

## Value

A list containing the parsed API response.

## Methods

### Public methods

- [`BlocksChildrenEndpoint$new()`](#method-BlocksChildrenEndpoint-new)

- [`BlocksChildrenEndpoint$list()`](#method-BlocksChildrenEndpoint-list)

- [`BlocksChildrenEndpoint$append()`](#method-BlocksChildrenEndpoint-append)

------------------------------------------------------------------------

### Method `new()`

Initialise block children endpoint. Not to be called directly, e.g., use
`notion$pages$children` instead.

#### Usage

    BlocksChildrenEndpoint$new(client)

#### Arguments

- `client`:

  Notion Client instance

------------------------------------------------------------------------

### Method [`list()`](https://rdrr.io/r/base/list.html)

Retrieve a block's children

#### Usage

    BlocksChildrenEndpoint$list(block_id, start_cursor = NULL, page_size = NULL)

#### Arguments

- `block_id`:

  String (required). The ID for a Notion block.

- `start_cursor`:

  Character. For pagination. If provided, returns results starting from
  this cursor. If NULL, returns the first page of results.

- `page_size`:

  Integer. Number of items to return per page (1-100). Defaults to 100.

#### Details

[Endpoint
documentation](https://developers.notion.com/reference/get-block-children)

------------------------------------------------------------------------

### Method [`append()`](https://rdrr.io/r/base/append.html)

Append block children

#### Usage

    BlocksChildrenEndpoint$append(block_id, children, position = NULL)

#### Arguments

- `block_id`:

  String (required). The ID for a Notion block.

- `children`:

  List of lists (JSON array) (required). Block objects to append as
  children to the block.

- `position`:

  Named list (JSON object). Controls where new blocks are inserted among
  parent's children. Defaults to end of parent block's children when
  omitted.

#### Details

[Endpoint
documentation](https://developers.notion.com/reference/patch-block-children)

## Examples

``` r
notion <- notion_client()
# ----- Append children to a block
notion$blocks$children$append(
  "34033ea0-c1e4-81c4-afa0-d1ec98de4bec",
  list(
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
#> {
#>   "object": "list",
#>   "results": [
#>     {
#>       "object": "block",
#>       "id": "34033ea0-c1e4-8123-be95-e77dcc78e47d",
#>       "parent": {
#>         "type": "page_id",
#>         "page_id": "34033ea0-c1e4-81c4-afa0-d1ec98de4bec"
#>       },
#>       "created_time": "2026-04-12T21:18:00.000Z",
#>       "last_edited_time": "2026-04-12T21:18:00.000Z",
#>       "created_by": {
#>         "object": "user",
#>         "id": "6b786605-e456-4237-9c61-5efaff23c081"
#>       },
#>       "last_edited_by": {
#>         "object": "user",
#>         "id": "6b786605-e456-4237-9c61-5efaff23c081"
#>       },
#>       "has_children": false,
#>       "in_trash": false,
#>       "type": "heading_2",
#>       "heading_2": {
#>         "rich_text": [
#>           {
#>             "type": "text",
#>             "text": {
#>               "content": "Test Heading",
#>               "link": {}
#>             },
#>             "annotations": {
#>               "bold": false,
#>               "italic": false,
#>               "strikethrough": false,
#>               "underline": false,
#>               "code": false,
#>               "color": "default"
#>             },
#>             "plain_text": "Test Heading",
#>             "href": {}
#>           }
#>         ],
#>         "is_toggleable": false,
#>         "color": "default"
#>       }
#>     }
#>   ],
#>   "next_cursor": {},
#>   "has_more": false,
#>   "type": "block",
#>   "block": {},
#>   "request_id": "a84673e4-c0c6-4f23-b579-4b93eae2ef3d"
#> } 
# ----- Retrieve children of a block
notion$blocks$children$list("34033ea0-c1e4-81c4-afa0-d1ec98de4bec")
#> {
#>   "object": "list",
#>   "results": [
#>     {
#>       "object": "block",
#>       "id": "34033ea0-c1e4-8123-be95-e77dcc78e47d",
#>       "parent": {
#>         "type": "page_id",
#>         "page_id": "34033ea0-c1e4-81c4-afa0-d1ec98de4bec"
#>       },
#>       "created_time": "2026-04-12T21:18:00.000Z",
#>       "last_edited_time": "2026-04-12T21:18:00.000Z",
#>       "created_by": {
#>         "object": "user",
#>         "id": "6b786605-e456-4237-9c61-5efaff23c081"
#>       },
#>       "last_edited_by": {
#>         "object": "user",
#>         "id": "6b786605-e456-4237-9c61-5efaff23c081"
#>       },
#>       "has_children": false,
#>       "in_trash": false,
#>       "type": "heading_2",
#>       "heading_2": {
#>         "rich_text": [
#>           {
#>             "type": "text",
#>             "text": {
#>               "content": "Test Heading",
#>               "link": {}
#>             },
#>             "annotations": {
#>               "bold": false,
#>               "italic": false,
#>               "strikethrough": false,
#>               "underline": false,
#>               "code": false,
#>               "color": "default"
#>             },
#>             "plain_text": "Test Heading",
#>             "href": {}
#>           }
#>         ],
#>         "is_toggleable": false,
#>         "color": "default"
#>       }
#>     }
#>   ],
#>   "next_cursor": {},
#>   "has_more": false,
#>   "type": "block",
#>   "block": {},
#>   "request_id": "4ba0ee62-19b9-4bca-88cb-095118508e71"
#> } 
# ----- Iterate through paginated results
if (FALSE) { # \dontrun{
start_cursor <- NULL
has_more <- FALSE
resps <- list()
i <- 1

while (has_more) {
  resps[[i]] <- notion$blocks$children$list(
    "2926b407e3c44b49a1830609abe6744f",
    start_cursor
  )
  has_more <- resps[[i]][["has_more"]]
  start_cursor <- resps[[i]][["next_cursor"]]
  i <- i + 1
}
} # }
```
