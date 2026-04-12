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
notion$views$queries$create("34033ea0-c1e4-81e1-942f-000c08810f61")
#> {
#>   "object": "view_query",
#>   "id": "a966d86e-5211-47cb-8a1e-f05bc0a33494",
#>   "view_id": "34033ea0-c1e4-81e1-942f-000c08810f61",
#>   "expires_at": "2026-04-12T08:26:21.052+00:00",
#>   "total_count": 1,
#>   "results": [
#>     {
#>       "object": "page",
#>       "id": "34033ea0-c1e4-8181-a411-fcffc69c690a"
#>     }
#>   ],
#>   "next_cursor": {},
#>   "has_more": false,
#>   "request_id": "06e3276d-92e6-4e33-b670-155a8d72c0b3"
#> } 
# ----- Get view query results
notion$views$queries$results(
  "34033ea0-c1e4-81e1-942f-000c08810f61",
  "a966d86e-5211-47cb-8a1e-f05bc0a33494"
)
#> {
#>   "object": "list",
#>   "results": [
#>     {
#>       "object": "page",
#>       "id": "34033ea0-c1e4-8181-a411-fcffc69c690a"
#>     }
#>   ],
#>   "next_cursor": {},
#>   "has_more": false,
#>   "type": "page",
#>   "page": {},
#>   "request_id": "9f94354e-84f9-45d3-beeb-e5f0b3abab48"
#> } 
# ----- Delete a view query
notion$views$queries$delete(
  "34033ea0-c1e4-81e1-942f-000c08810f61",
  "a966d86e-5211-47cb-8a1e-f05bc0a33494"
)
#> {
#>   "object": "view_query",
#>   "id": "a966d86e-5211-47cb-8a1e-f05bc0a33494",
#>   "deleted": true,
#>   "request_id": "2ea9dd88-3bbe-4fbc-8017-4229f5ceb8d6"
#> } 
```
