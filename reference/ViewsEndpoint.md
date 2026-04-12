# R6 Class for Views Endpoint

Handle all views operations in the Notion API

**Note:** Access this endpoint through the client instance, e.g.,
`notion$views`. Not to be instantiated directly.

## Value

A list containing the parsed API response.

## Public fields

- `queries`:

  Views Queries Endpoint

## Methods

### Public methods

- [`ViewsEndpoint$new()`](#method-ViewsEndpoint-new)

- [`ViewsEndpoint$create()`](#method-ViewsEndpoint-create)

- [`ViewsEndpoint$retrieve()`](#method-ViewsEndpoint-retrieve)

- [`ViewsEndpoint$update()`](#method-ViewsEndpoint-update)

- [`ViewsEndpoint$delete()`](#method-ViewsEndpoint-delete)

- [`ViewsEndpoint$list()`](#method-ViewsEndpoint-list)

------------------------------------------------------------------------

### Method `new()`

Initialise views endpoint. Not to be called directly, e.g., use
`notion$views` instead.

#### Usage

    ViewsEndpoint$new(client)

#### Arguments

- `client`:

  Notion Client instance

------------------------------------------------------------------------

### Method `create()`

Create a view

#### Usage

    ViewsEndpoint$create(
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
    )

#### Arguments

- `data_source_id`:

  Character (required). The ID of the data source this view is scoped
  to.

- `name`:

  Character (required). The name of the view.

- `type`:

  Character (required). The type of view to create.

- `database_id`:

  Character. The ID of the database to create a view in. Mutually
  exclusive with `view_id` and `create_database`

- `view_id`:

  Character. The ID of a dashboard view to add this view to as a widget.
  Mutually exclusive with `database_id` and `create_database`.

- `filter`:

  Named list (JSON object). Filter to apply to the view.

- `sorts`:

  List of lists (JSON array). Sorts to apply to the view.

- `quick_filters`:

  Named list (JSON object). Key-value pairs of quick filters to pin in
  the view's filter bar.

- `create_database`:

  Named list (JSON object). Create a new linked database block and add
  the view to it. Mutually exclusive with `database_id` and `view_id`

- `configuration`:

  Named list (JSON object). View presentation configuration.

- `position`:

  Named list (JSON object). Where to place the new view in the
  database's view tab bar. Only applicable when `database_id` is
  provided. Defaults to "end" (append).

- `placement`:

  Named list (JSON object). Where to place the new widget in a dashboard
  view. Only applicable when `view_id` is provided. Defaults to creating
  a new row at the end.

#### Details

[Endpoint
documentation](https://developers.notion.com/reference/create-view)

------------------------------------------------------------------------

### Method `retrieve()`

Retrieve a view

#### Usage

    ViewsEndpoint$retrieve(view_id)

#### Arguments

- `view_id`:

  ID of a Notion view.

#### Details

[Endpoint
documentation](https://developers.notion.com/reference/retrieve-a-view)

------------------------------------------------------------------------

### Method [`update()`](https://rdrr.io/r/stats/update.html)

Update a view

#### Usage

    ViewsEndpoint$update(
      view_id,
      name = NULL,
      filter = NULL,
      sorts = NULL,
      quick_filters = NULL,
      configuration = NULL
    )

#### Arguments

- `view_id`:

  ID of a Notion view.

- `name`:

  Character. New name for the view.

- `filter`:

  Named list (JSON object). Filter to apply to the view.

- `sorts`:

  List of lists (JSON array). Property sorts to apply to the view.

- `quick_filters`:

  Named list (JSON object). Key-value pairs of quick filters to
  add/update.

- `configuration`:

  Named list (JSON object). View presentation configuration.

#### Details

[Endpoint
documentation](https://developers.notion.com/reference/update-a-view)

------------------------------------------------------------------------

### Method `delete()`

Delete a view

#### Usage

    ViewsEndpoint$delete(view_id)

#### Arguments

- `view_id`:

  ID of a Notion view.

#### Details

[Endpoint
documentation](https://developers.notion.com/reference/delete-view)

------------------------------------------------------------------------

### Method [`list()`](https://rdrr.io/r/base/list.html)

List all views in a database

#### Usage

    ViewsEndpoint$list(
      database_id = NULL,
      data_source_id = NULL,
      start_cursor = NULL,
      page_size = NULL
    )

#### Arguments

- `database_id`:

  Character. ID of a Notion database to list views for. At least one of
  `database_id` or `data_source_id` is required.

- `data_source_id`:

  Character. ID of a data source to list all views for, including linked
  views across the workspace. At least one of `database_id` or
  `data_source_id` is required.

- `start_cursor`:

  Character. For pagination. If provided, returns results starting from
  this cursor. If NULL, returns the first page of results.

- `page_size`:

  Integer. Number of items to return per page (1-100). Defaults to 100

#### Details

[Endpoint
documentation](https://developers.notion.com/reference/list-views)

## Examples

``` r
notion <- notion_client()
# ----- Create a view
notion$views$create(
  "34033ea0-c1e4-81a2-aaf4-000b260f79c9",
  "Test view",
  "table",
  "efab1bec-0094-4afe-a90c-c9b72d538b4b"
)
#> {
#>   "object": "view",
#>   "id": "34033ea0-c1e4-81e1-942f-000c08810f61",
#>   "parent": {
#>     "type": "database_id",
#>     "database_id": "efab1bec-0094-4afe-a90c-c9b72d538b4b"
#>   },
#>   "data_source_id": "34033ea0-c1e4-81a2-aaf4-000b260f79c9",
#>   "name": "Test view",
#>   "type": "table",
#>   "created_time": "2026-04-12T08:11:18.760+00:00",
#>   "created_by": {
#>     "object": "user",
#>     "id": "6b786605-e456-4237-9c61-5efaff23c081"
#>   },
#>   "last_edited_time": "2026-04-12T08:11:18.760+00:00",
#>   "last_edited_by": {
#>     "object": "user",
#>     "id": "6b786605-e456-4237-9c61-5efaff23c081"
#>   },
#>   "url": "https://www.notion.so/efab1bec00944afea90cc9b72d538b4b?v=34033ea0c1e481e1942f000c08810f61",
#>   "filter": {},
#>   "sorts": {},
#>   "quick_filters": {},
#>   "configuration": {
#>     "type": "table"
#>   },
#>   "request_id": "0e7ffe44-e3c0-4b17-9e70-6eb7e890de2f"
#> } 
# ----- Retrieve a view
notion$views$retrieve("34033ea0-c1e4-81e1-942f-000c08810f61")
#> {
#>   "object": "view",
#>   "id": "34033ea0-c1e4-81e1-942f-000c08810f61",
#>   "parent": {
#>     "type": "database_id",
#>     "database_id": "efab1bec-0094-4afe-a90c-c9b72d538b4b"
#>   },
#>   "data_source_id": "34033ea0-c1e4-81a2-aaf4-000b260f79c9",
#>   "name": "Test view",
#>   "type": "table",
#>   "created_time": "2026-04-12T08:11:18.760+00:00",
#>   "created_by": {
#>     "object": "user",
#>     "id": "6b786605-e456-4237-9c61-5efaff23c081"
#>   },
#>   "last_edited_time": "2026-04-12T08:11:18.760+00:00",
#>   "last_edited_by": {
#>     "object": "user",
#>     "id": "6b786605-e456-4237-9c61-5efaff23c081"
#>   },
#>   "url": "https://www.notion.so/efab1bec00944afea90cc9b72d538b4b?v=34033ea0c1e481e1942f000c08810f61",
#>   "filter": {},
#>   "sorts": {},
#>   "quick_filters": {},
#>   "configuration": {
#>     "type": "table"
#>   },
#>   "request_id": "968184bf-37da-4160-9347-f555ca05836c"
#> } 
# ----- List views
notion$views$list(data_source_id = "34033ea0-c1e4-81a2-aaf4-000b260f79c9")
#> {
#>   "object": "list",
#>   "results": [
#>     {
#>       "object": "view",
#>       "id": "34033ea0-c1e4-8198-bd0c-000c97c2d0bf"
#>     },
#>     {
#>       "object": "view",
#>       "id": "34033ea0-c1e4-81e1-942f-000c08810f61"
#>     }
#>   ],
#>   "next_cursor": {},
#>   "has_more": false,
#>   "type": "view",
#>   "view": {},
#>   "request_id": "fe2d429e-e976-43fa-96e3-0f274913ee05"
#> } 
# ----- Update a view
notion$views$update("34033ea0-c1e4-81e1-942f-000c08810f61", "Updated view name")
#> {
#>   "object": "view",
#>   "id": "34033ea0-c1e4-81e1-942f-000c08810f61",
#>   "parent": {
#>     "type": "database_id",
#>     "database_id": "efab1bec-0094-4afe-a90c-c9b72d538b4b"
#>   },
#>   "data_source_id": "34033ea0-c1e4-81a2-aaf4-000b260f79c9",
#>   "name": "Updated view name",
#>   "type": "table",
#>   "created_time": "2026-04-12T08:11:18.760+00:00",
#>   "created_by": {
#>     "object": "user",
#>     "id": "6b786605-e456-4237-9c61-5efaff23c081"
#>   },
#>   "last_edited_time": "2026-04-12T08:11:19.830+00:00",
#>   "last_edited_by": {
#>     "object": "user",
#>     "id": "6b786605-e456-4237-9c61-5efaff23c081"
#>   },
#>   "url": "https://www.notion.so/efab1bec00944afea90cc9b72d538b4b?v=34033ea0c1e481e1942f000c08810f61",
#>   "filter": {},
#>   "sorts": {},
#>   "quick_filters": {},
#>   "configuration": {
#>     "type": "table"
#>   },
#>   "request_id": "58536839-aea8-4698-b2cd-edc31c4f50d6"
#> } 
# ----- Delete a view
notion$views$delete("34033ea0-c1e4-81e1-942f-000c08810f61")
#> {
#>   "object": "view",
#>   "id": "34033ea0-c1e4-81e1-942f-000c08810f61",
#>   "parent": {
#>     "type": "database_id",
#>     "database_id": "efab1bec-0094-4afe-a90c-c9b72d538b4b"
#>   },
#>   "type": "table",
#>   "request_id": "d83da7a4-f8a9-4591-8e7e-84040da1659f"
#> } 
```
