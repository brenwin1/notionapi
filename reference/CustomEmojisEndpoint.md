# R6 Class for Custom Emojis Endpoint

Handle all custom emojis operations in the Notion API

**Note:** Access this endpoint through the client instance, e.g.,
`notion$custom_emojis`. Not to be instantiated directly.

## Value

A list containing the parsed API response.

## Methods

### Public methods

- [`CustomEmojisEndpoint$new()`](#method-CustomEmojisEndpoint-new)

- [`CustomEmojisEndpoint$list()`](#method-CustomEmojisEndpoint-list)

------------------------------------------------------------------------

### Method `new()`

Initialise custom emojis endpoint. Not to be called directly, e.g., use
`notion$custom_emojis` instead.

#### Usage

    CustomEmojisEndpoint$new(client)

#### Arguments

- `client`:

  Notion Client instance

------------------------------------------------------------------------

### Method [`list()`](https://rdrr.io/r/base/list.html)

List custom emojis

#### Usage

    CustomEmojisEndpoint$list(start_cursor = NULL, page_size = NULL, name = NULL)

#### Arguments

- `start_cursor`:

  Character. For pagination. If provided, returns results starting from
  this cursor. If NULL, returns the first page of results.

- `page_size`:

  Integer. Number of items to return per page (1-100). Defaults to 100

- `name`:

  Character. Filters custom emojis by exact name match. Useful for
  resolving a custom emoji name to its ID.

#### Details

[Endpoint
documentation](https://developers.notion.com/reference/list-custom-emojis)

## Examples

``` r
notion <- notion_client()
notion$custom_emojis$list()
#> {
#>   "object": "list",
#>   "type": "custom_emoji",
#>   "results": [],
#>   "has_more": false,
#>   "next_cursor": {},
#>   "request_id": "fa11b3ad-2fae-4a5e-9d0d-46bb45120924"
#> } 
```
