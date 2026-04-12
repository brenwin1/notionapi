# R6 Class for Blocks Endpoint

Handle all block operations in the Notion API

**Note:** Access this endpoint through the client instance, e.g.,
`notion$blocks`. Not to be instantiated directly.

## Value

A list containing the parsed API response.

## Public fields

- `children`:

  Block children endpoint

## Methods

### Public methods

- [`BlocksEndpoint$new()`](#method-BlocksEndpoint-new)

- [`BlocksEndpoint$retrieve()`](#method-BlocksEndpoint-retrieve)

- [`BlocksEndpoint$update()`](#method-BlocksEndpoint-update)

- [`BlocksEndpoint$delete()`](#method-BlocksEndpoint-delete)

------------------------------------------------------------------------

### Method `new()`

Initialise block endpoint. Not to be called directly, e.g., use
`notion$blocks` instead.

#### Usage

    BlocksEndpoint$new(client)

#### Arguments

- `client`:

  Notion Client instance

------------------------------------------------------------------------

### Method `retrieve()`

Retrieve a block

#### Usage

    BlocksEndpoint$retrieve(block_id)

#### Arguments

- `block_id`:

  Character (required). The ID for a Notion block.

#### Details

[Endpoint
documentation](https://developers.notion.com/reference/retrieve-a-block)

------------------------------------------------------------------------

### Method [`update()`](https://rdrr.io/r/stats/update.html)

Update a block

#### Usage

    BlocksEndpoint$update(block_id, in_trash = NULL, ...)

#### Arguments

- `block_id`:

  Character (required). The ID for a Notion block.

- `in_trash`:

  Boolean. Set to TRUE to trash (delete) a block. Set to FALSE to
  restore a block.

- `...`:

  \<[`dynamic-dots`](https://rlang.r-lib.org/reference/dyn-dots.html)\>
  Block-specific properties to update. Each argument should be named
  after a [block type](https://developers.notion.com/reference/block)
  (e.g., `heading_1`, `paragraph`) with a named list value containing
  the block configuration.

#### Details

[Endpoint
documentation](https://developers.notion.com/reference/update-a-block)

------------------------------------------------------------------------

### Method `delete()`

Delete a block

#### Usage

    BlocksEndpoint$delete(block_id)

#### Arguments

- `block_id`:

  Character (required). The ID for a Notion block.

#### Details

[Endpoint
documentation](https://developers.notion.com/reference/delete-a-block)

## Examples

``` r
notion <- notion_client()
# ----- Retrieve a block
notion$blocks$retrieve("34033ea0-c1e4-8123-be95-e77dcc78e47d")
#> {
#>   "object": "block",
#>   "id": "34033ea0-c1e4-8123-be95-e77dcc78e47d",
#>   "parent": {
#>     "type": "page_id",
#>     "page_id": "34033ea0-c1e4-81c4-afa0-d1ec98de4bec"
#>   },
#>   "created_time": "2026-04-12T21:18:00.000Z",
#>   "last_edited_time": "2026-04-12T21:18:00.000Z",
#>   "created_by": {
#>     "object": "user",
#>     "id": "6b786605-e456-4237-9c61-5efaff23c081"
#>   },
#>   "last_edited_by": {
#>     "object": "user",
#>     "id": "6b786605-e456-4237-9c61-5efaff23c081"
#>   },
#>   "has_children": false,
#>   "in_trash": false,
#>   "type": "heading_2",
#>   "heading_2": {
#>     "rich_text": [
#>       {
#>         "type": "text",
#>         "text": {
#>           "content": "Test Heading",
#>           "link": {}
#>         },
#>         "annotations": {
#>           "bold": false,
#>           "italic": false,
#>           "strikethrough": false,
#>           "underline": false,
#>           "code": false,
#>           "color": "default"
#>         },
#>         "plain_text": "Test Heading",
#>         "href": {}
#>       }
#>     ],
#>     "is_toggleable": false,
#>     "color": "default"
#>   },
#>   "request_id": "07e66343-4493-4f39-b6bd-d8b85878d17c"
#> } 
# ----- Update a block
notion$blocks$update(
  "34033ea0-c1e4-8123-be95-e77dcc78e47d",
  heading_2 = list(
    rich_text = list(list(
      text = list(
        content = "Updated Test Heading"
      )
    ))
  )
)
#> {
#>   "object": "block",
#>   "id": "34033ea0-c1e4-8123-be95-e77dcc78e47d",
#>   "parent": {
#>     "type": "page_id",
#>     "page_id": "34033ea0-c1e4-81c4-afa0-d1ec98de4bec"
#>   },
#>   "created_time": "2026-04-12T21:18:00.000Z",
#>   "last_edited_time": "2026-04-12T21:18:00.000Z",
#>   "created_by": {
#>     "object": "user",
#>     "id": "6b786605-e456-4237-9c61-5efaff23c081"
#>   },
#>   "last_edited_by": {
#>     "object": "user",
#>     "id": "6b786605-e456-4237-9c61-5efaff23c081"
#>   },
#>   "has_children": false,
#>   "in_trash": false,
#>   "type": "heading_2",
#>   "heading_2": {
#>     "rich_text": [
#>       {
#>         "type": "text",
#>         "text": {
#>           "content": "Updated Test Heading",
#>           "link": {}
#>         },
#>         "annotations": {
#>           "bold": false,
#>           "italic": false,
#>           "strikethrough": false,
#>           "underline": false,
#>           "code": false,
#>           "color": "default"
#>         },
#>         "plain_text": "Updated Test Heading",
#>         "href": {}
#>       }
#>     ],
#>     "is_toggleable": false,
#>     "color": "default"
#>   },
#>   "request_id": "fc039cff-8ef4-40a7-a6e0-8a289e5aa104"
#> } 
# ----- Delete a block
notion$blocks$delete(
  "34033ea0-c1e4-8123-be95-e77dcc78e47d"
)
#> {
#>   "object": "block",
#>   "id": "34033ea0-c1e4-8123-be95-e77dcc78e47d",
#>   "parent": {
#>     "type": "page_id",
#>     "page_id": "34033ea0-c1e4-81c4-afa0-d1ec98de4bec"
#>   },
#>   "created_time": "2026-04-12T21:18:00.000Z",
#>   "last_edited_time": "2026-04-12T21:19:00.000Z",
#>   "created_by": {
#>     "object": "user",
#>     "id": "6b786605-e456-4237-9c61-5efaff23c081"
#>   },
#>   "last_edited_by": {
#>     "object": "user",
#>     "id": "6b786605-e456-4237-9c61-5efaff23c081"
#>   },
#>   "has_children": false,
#>   "in_trash": true,
#>   "type": "heading_2",
#>   "heading_2": {
#>     "rich_text": [
#>       {
#>         "type": "text",
#>         "text": {
#>           "content": "Updated Test Heading",
#>           "link": {}
#>         },
#>         "annotations": {
#>           "bold": false,
#>           "italic": false,
#>           "strikethrough": false,
#>           "underline": false,
#>           "code": false,
#>           "color": "default"
#>         },
#>         "plain_text": "Updated Test Heading",
#>         "href": {}
#>       }
#>     ],
#>     "is_toggleable": false,
#>     "color": "default"
#>   },
#>   "request_id": "87b68305-aec0-4047-8d58-ccf10945cfea"
#> } 
```
