# R6 Class for Views Queries Endpoint

Handle all views queries operations in the Notion API

**Note:** Access this endpoint through the client instance, e.g.,
`notion$views$queries`. Not to be instantiated directly.

## Value

A list containing the parsed API response.

## Methods

### Public methods

- [`ViewsQueriesEndpoint$new()`](#method-ViewsQueriesEndpoint-new)

- [`ViewsQueriesEndpoint$create()`](#method-ViewsQueriesEndpoint-create)

- [`ViewsQueriesEndpoint$results()`](#method-ViewsQueriesEndpoint-results)

- [`ViewsQueriesEndpoint$delete()`](#method-ViewsQueriesEndpoint-delete)

------------------------------------------------------------------------

### Method `new()`

Initialise pages properties endpoint. Not to be called directly, e.g.,
use `notion$views$queries` instead.

#### Usage

    ViewsQueriesEndpoint$new(client)

#### Arguments

- `client`:

  Notion Client instance

------------------------------------------------------------------------

### Method `create()`

Create a view query

#### Usage

    ViewsQueriesEndpoint$create(view_id, page_size = NULL)

#### Arguments

- `view_id`:

  Character (required). The ID of the view.

- `page_size`:

  Integer. Number of items to return per page (1-100). Defaults to 100.

#### Details

[Endpoint
documentation](https://developers.notion.com/reference/create-view-query)

------------------------------------------------------------------------

### Method `results()`

Get view query results

#### Usage

    ViewsQueriesEndpoint$results(
      view_id,
      query_id,
      start_cursor = NULL,
      page_size = NULL
    )

#### Arguments

- `view_id`:

  Character (required). The ID of the view.

- `query_id`:

  Character (required). The ID of the query.

- `start_cursor`:

  Character. For pagination. If provided, returns results starting from
  this cursor. If NULL, returns the first page of results.

- `page_size`:

  Integer. Number of items to return per page (1-100). Defaults to 100

#### Details

[Endpoint
documentation](https://developers.notion.com/reference/get-view-query-results)

------------------------------------------------------------------------

### Method `delete()`

Delete a view query

#### Usage

    ViewsQueriesEndpoint$delete(view_id, query_id)

#### Arguments

- `view_id`:

  Character (required). The ID of the view.

- `query_id`:

  Character (required). The ID of the query.

#### Details

[Endpoint
documentation](https://developers.notion.com/reference/delete-view-query)

## Examples

``` r
notion <- notion_client()
# ----- Create a view query
notion$views$queries$create("34033ea0-c1e4-8192-ac14-000cdad096ce")
#> {
#>   "object": "view_query",
#>   "id": "9af03bd1-ed79-4842-a57c-0bc04fb61be2",
#>   "view_id": "34033ea0-c1e4-8192-ac14-000cdad096ce",
#>   "expires_at": "2026-04-12T21:34:01.702+00:00",
#>   "total_count": 1,
#>   "results": [
#>     {
#>       "object": "page",
#>       "id": "34033ea0-c1e4-81c4-afa0-d1ec98de4bec"
#>     }
#>   ],
#>   "next_cursor": {},
#>   "has_more": false,
#>   "request_id": "b1c06f37-06d3-4633-9df2-a87eb48b8222"
#> } 
# ----- Get view query results
notion$views$queries$results(
  "34033ea0-c1e4-8192-ac14-000cdad096ce",
  "9af03bd1-ed79-4842-a57c-0bc04fb61be2"
)
#> {
#>   "object": "list",
#>   "results": [
#>     {
#>       "object": "page",
#>       "id": "34033ea0-c1e4-81c4-afa0-d1ec98de4bec"
#>     }
#>   ],
#>   "next_cursor": {},
#>   "has_more": false,
#>   "type": "page",
#>   "page": {},
#>   "request_id": "ae56e2b0-35d2-407c-9622-687618c03bb5"
#> } 
# ----- Delete a view query
notion$views$queries$delete(
  "34033ea0-c1e4-8192-ac14-000cdad096ce",
  "9af03bd1-ed79-4842-a57c-0bc04fb61be2"
)
#> {
#>   "object": "view_query",
#>   "id": "9af03bd1-ed79-4842-a57c-0bc04fb61be2",
#>   "deleted": true,
#>   "request_id": "ce52ec95-7257-4372-b08f-0fca3da2e0f1"
#> } 
```
