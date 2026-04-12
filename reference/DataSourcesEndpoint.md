# R6 Class for DataSources Endpoint

Handle all data sources operations in the Notion API

**Note:** Access this endpoint through the client instance, e.g.,
`notion$datas_ources`. Not to be instantiated directly.

## Value

A list containing the parsed API response.

## Methods

### Public methods

- [`DataSourcesEndpoint$new()`](#method-DataSourcesEndpoint-new)

- [`DataSourcesEndpoint$create()`](#method-DataSourcesEndpoint-create)

- [`DataSourcesEndpoint$retrieve()`](#method-DataSourcesEndpoint-retrieve)

- [`DataSourcesEndpoint$list_templates()`](#method-DataSourcesEndpoint-list_templates)

- [`DataSourcesEndpoint$update()`](#method-DataSourcesEndpoint-update)

- [`DataSourcesEndpoint$query()`](#method-DataSourcesEndpoint-query)

------------------------------------------------------------------------

### Method `new()`

Initialise data sources endpoint. Not to be called directly, e.g., use
`notion$datasources` instead.

#### Usage

    DataSourcesEndpoint$new(client)

#### Arguments

- `client`:

  Notion Client instance

------------------------------------------------------------------------

### Method `create()`

Create a data source

#### Usage

    DataSourcesEndpoint$create(parent, properties, title = NULL, icon = NULL)

#### Arguments

- `parent`:

  Named list (JSON object) (required). An object specifying the parent
  of the new data source to be created.

- `properties`:

  Named list (JSON object) (required). Property schema of data source.

- `title`:

  List of lists (JSON array). Title of data source.

- `icon`:

  Named list (JSON object). Page icon.

#### Details

[Endpoint
documentation](https://developers.notion.com/reference/create-a-data-source)

------------------------------------------------------------------------

### Method `retrieve()`

Retrieve a data source

#### Usage

    DataSourcesEndpoint$retrieve(data_source_id)

#### Arguments

- `data_source_id`:

  Character (required). ID of a Notion data source.

#### Details

[Endpoint
documentation](https://developers.notion.com/reference/retrieve-a-data-source)

------------------------------------------------------------------------

### Method `list_templates()`

List page templates available for a data source

#### Usage

    DataSourcesEndpoint$list_templates(
      data_source_id,
      name = NULL,
      start_cursor = NULL,
      page_size = NULL
    )

#### Arguments

- `data_source_id`:

  Character (required). ID of a Notion data source.

- `name`:

  Character. Name to filter templates by.

- `start_cursor`:

  Character. For pagination. If provided, returns results starting from
  this cursor. If NULL, returns the first page of results.

- `page_size`:

  Integer. Number of items to return per page (1-100). Defaults to 100

------------------------------------------------------------------------

### Method [`update()`](https://rdrr.io/r/stats/update.html)

Update a data source

#### Usage

    DataSourcesEndpoint$update(
      data_source_id,
      title = NULL,
      icon = NULL,
      properties = NULL,
      in_trash = NULL,
      parent = NULL
    )

#### Arguments

- `data_source_id`:

  Character (required). ID of a Notion data source.

- `title`:

  List of lists (JSON array). Title of data source.

- `icon`:

  Named list (JSON object). Page icon.'

- `properties`:

  Named list (JSON object). Key-value pairs representing the data
  source's properties.

- `in_trash`:

  Boolean. Whether the database should be moved to or from the trash.

- `parent`:

  Named list (JSON object). The parent of the data source, when moving
  it to a different database.

------------------------------------------------------------------------

### Method `query()`

Query a data source

#### Usage

    DataSourcesEndpoint$query(
      data_source_id,
      filter_properties = NULL,
      sorts = NULL,
      filter = NULL,
      start_cursor = NULL,
      page_size = NULL,
      in_trash = NULL,
      result_type = NULL
    )

#### Arguments

- `data_source_id`:

  Character (required). ID of a Notion data source.

- `filter_properties`:

  Character vector. Page property value IDs to include in the response
  schema. If NULL (default), all properties are returned.

- `sorts`:

  List of lists (JSON array). [Sort
  conditions](https://developers.notion.com/reference/sort-data-source-entries)
  to apply to the query

- `filter`:

  List of lists (JSON array). [Filter
  conditions](https://developers.notion.com/reference/filter-data-source-entries)
  to apply. to the query

- `start_cursor`:

  Character. For pagination. If provided, returns results starting from
  this cursor. If NULL, returns the first page of results.

- `page_size`:

  Integer. Number of items to return per page (1-100). Defaults to 100

- `in_trash`:

  Boolean. If `TRUE`, trashed pages are included in the results
  alongside non-trashed pages. If `FALSE` or `NULL` (default), only
  non-trashed pages are returned.

- `result_type`:

  Character. Filter results by type. Available options are "page" and
  "data_source". If `NULL` (default), all result types are returned.

## Examples

``` r
notion <- notion_client()
# ----- Create a data source
notion$data_sources$create(
  list(
    database_id = "efab1bec-0094-4afe-a90c-c9b72d538b4b"
  ),
  properties = list(
    Title = list(
      title = no_config()
    )
  ),
  title = list(list(
    text = list(
      content = "Test data source"
    )
  ))
)
#> {
#>   "object": "data_source",
#>   "id": "34033ea0-c1e4-81a2-aaf4-000b260f79c9",
#>   "cover": {},
#>   "icon": {},
#>   "created_time": "2026-04-12T08:11:00.000Z",
#>   "created_by": {
#>     "object": "user",
#>     "id": "6b786605-e456-4237-9c61-5efaff23c081"
#>   },
#>   "last_edited_by": {
#>     "object": "user",
#>     "id": "6b786605-e456-4237-9c61-5efaff23c081"
#>   },
#>   "last_edited_time": "2026-04-12T08:11:00.000Z",
#>   "title": [
#>     {
#>       "type": "text",
#>       "text": {
#>         "content": "Test data source",
#>         "link": {}
#>       },
#>       "annotations": {
#>         "bold": false,
#>         "italic": false,
#>         "strikethrough": false,
#>         "underline": false,
#>         "code": false,
#>         "color": "default"
#>       },
#>       "plain_text": "Test data source",
#>       "href": {}
#>     }
#>   ],
#>   "description": [],
#>   "is_inline": false,
#>   "properties": {
#>     "Title": {
#>       "id": "title",
#>       "name": "Title",
#>       "description": {},
#>       "type": "title",
#>       "title": {}
#>     }
#>   },
#>   "parent": {
#>     "type": "database_id",
#>     "database_id": "efab1bec-0094-4afe-a90c-c9b72d538b4b"
#>   },
#>   "database_parent": {
#>     "type": "page_id",
#>     "page_id": "22f33ea0-c1e4-80b9-9c77-d1ab72aedff9"
#>   },
#>   "url": "https://www.notion.so/efab1bec00944afea90cc9b72d538b4b",
#>   "public_url": {},
#>   "in_trash": false,
#>   "request_id": "f2eae437-5c2f-4682-bf1d-bd60097c37bd"
#> } 
# ----- Update data source
notion$data_sources$update(
  "34033ea0-c1e4-81a2-aaf4-000b260f79c9",
  properties = list(
    Status = list(
      status = list(
        options = list(
          list(
            name = "To do",
            color = "red"
          ),
          list(
            name = "Done",
            color = "green"
          )
        )
      )
    )
  )
)
#> {
#>   "object": "data_source",
#>   "id": "34033ea0-c1e4-81a2-aaf4-000b260f79c9",
#>   "cover": {},
#>   "icon": {},
#>   "created_time": "2026-04-12T08:11:00.000Z",
#>   "created_by": {
#>     "object": "user",
#>     "id": "6b786605-e456-4237-9c61-5efaff23c081"
#>   },
#>   "last_edited_by": {
#>     "object": "user",
#>     "id": "6b786605-e456-4237-9c61-5efaff23c081"
#>   },
#>   "last_edited_time": "2026-04-12T08:11:00.000Z",
#>   "title": [
#>     {
#>       "type": "text",
#>       "text": {
#>         "content": "Test data source",
#>         "link": {}
#>       },
#>       "annotations": {
#>         "bold": false,
#>         "italic": false,
#>         "strikethrough": false,
#>         "underline": false,
#>         "code": false,
#>         "color": "default"
#>       },
#>       "plain_text": "Test data source",
#>       "href": {}
#>     }
#>   ],
#>   "description": [],
#>   "is_inline": false,
#>   "properties": {
#>     "Status": {
#>       "id": "BvMv",
#>       "name": "Status",
#>       "description": {},
#>       "type": "status",
#>       "status": {
#>         "options": [
#>           {
#>             "id": "d240ac03-dfab-4eb3-8a98-2330b66c38f7",
#>             "name": "To do",
#>             "color": "red",
#>             "description": {}
#>           },
#>           {
#>             "id": "5ded4a97-d895-468f-bc34-04dc08d7858f",
#>             "name": "Done",
#>             "color": "green",
#>             "description": {}
#>           }
#>         ],
#>         "groups": [
#>           {
#>             "id": "104e2ae2-fc22-4731-bd28-96135ba3454d",
#>             "name": "To-do",
#>             "color": "gray",
#>             "option_ids": [
#>               "d240ac03-dfab-4eb3-8a98-2330b66c38f7",
#>               "5ded4a97-d895-468f-bc34-04dc08d7858f"
#>             ]
#>           },
#>           {
#>             "id": "c6ec5f45-a708-478b-9f62-b45082f5c111",
#>             "name": "In progress",
#>             "color": "blue",
#>             "option_ids": []
#>           },
#>           {
#>             "id": "fe31f3b0-2c64-4b20-9266-681b11fbede2",
#>             "name": "Complete",
#>             "color": "green",
#>             "option_ids": []
#>           }
#>         ]
#>       }
#>     },
#>     "Title": {
#>       "id": "title",
#>       "name": "Title",
#>       "description": {},
#>       "type": "title",
#>       "title": {}
#>     }
#>   },
#>   "parent": {
#>     "type": "database_id",
#>     "database_id": "efab1bec-0094-4afe-a90c-c9b72d538b4b"
#>   },
#>   "database_parent": {
#>     "type": "page_id",
#>     "page_id": "22f33ea0-c1e4-80b9-9c77-d1ab72aedff9"
#>   },
#>   "url": "https://www.notion.so/efab1bec00944afea90cc9b72d538b4b",
#>   "public_url": {},
#>   "in_trash": false,
#>   "request_id": "3629a270-d451-4600-9a3a-f77dd42fe716"
#> } 
# ----- Retrieve a data source
notion$data_sources$retrieve("34033ea0-c1e4-81a2-aaf4-000b260f79c9")
#> {
#>   "object": "data_source",
#>   "id": "34033ea0-c1e4-81a2-aaf4-000b260f79c9",
#>   "cover": {},
#>   "icon": {},
#>   "created_time": "2026-04-12T08:11:00.000Z",
#>   "created_by": {
#>     "object": "user",
#>     "id": "6b786605-e456-4237-9c61-5efaff23c081"
#>   },
#>   "last_edited_by": {
#>     "object": "user",
#>     "id": "6b786605-e456-4237-9c61-5efaff23c081"
#>   },
#>   "last_edited_time": "2026-04-12T08:11:00.000Z",
#>   "title": [
#>     {
#>       "type": "text",
#>       "text": {
#>         "content": "Test data source",
#>         "link": {}
#>       },
#>       "annotations": {
#>         "bold": false,
#>         "italic": false,
#>         "strikethrough": false,
#>         "underline": false,
#>         "code": false,
#>         "color": "default"
#>       },
#>       "plain_text": "Test data source",
#>       "href": {}
#>     }
#>   ],
#>   "description": [],
#>   "is_inline": false,
#>   "properties": {
#>     "Status": {
#>       "id": "BvMv",
#>       "name": "Status",
#>       "description": {},
#>       "type": "status",
#>       "status": {
#>         "options": [
#>           {
#>             "id": "d240ac03-dfab-4eb3-8a98-2330b66c38f7",
#>             "name": "To do",
#>             "color": "red",
#>             "description": {}
#>           },
#>           {
#>             "id": "5ded4a97-d895-468f-bc34-04dc08d7858f",
#>             "name": "Done",
#>             "color": "green",
#>             "description": {}
#>           }
#>         ],
#>         "groups": [
#>           {
#>             "id": "104e2ae2-fc22-4731-bd28-96135ba3454d",
#>             "name": "To-do",
#>             "color": "gray",
#>             "option_ids": [
#>               "d240ac03-dfab-4eb3-8a98-2330b66c38f7",
#>               "5ded4a97-d895-468f-bc34-04dc08d7858f"
#>             ]
#>           },
#>           {
#>             "id": "c6ec5f45-a708-478b-9f62-b45082f5c111",
#>             "name": "In progress",
#>             "color": "blue",
#>             "option_ids": []
#>           },
#>           {
#>             "id": "fe31f3b0-2c64-4b20-9266-681b11fbede2",
#>             "name": "Complete",
#>             "color": "green",
#>             "option_ids": []
#>           }
#>         ]
#>       }
#>     },
#>     "Title": {
#>       "id": "title",
#>       "name": "Title",
#>       "description": {},
#>       "type": "title",
#>       "title": {}
#>     }
#>   },
#>   "parent": {
#>     "type": "database_id",
#>     "database_id": "efab1bec-0094-4afe-a90c-c9b72d538b4b"
#>   },
#>   "database_parent": {
#>     "type": "page_id",
#>     "page_id": "22f33ea0-c1e4-80b9-9c77-d1ab72aedff9"
#>   },
#>   "url": "https://www.notion.so/efab1bec00944afea90cc9b72d538b4b",
#>   "public_url": {},
#>   "in_trash": false,
#>   "request_id": "6eb66514-adc9-4ce5-983a-d04cbffb2843"
#> } 
# ----- List data source templates
notion$data_sources$list_templates("34033ea0-c1e4-81a2-aaf4-000b260f79c9")
#> {
#>   "templates": [],
#>   "has_more": false,
#>   "next_cursor": {}
#> } 
# ----- Query a data source
notion$data_sources$query(
  "34033ea0-c1e4-81a2-aaf4-000b260f79c9",
  filter = list(
    property = "Status",
    status = list(
      equals = "To do"
    )
  )
)
#> {
#>   "object": "list",
#>   "results": [
#>     {
#>       "object": "page",
#>       "id": "34033ea0-c1e4-8181-a411-fcffc69c690a",
#>       "created_time": "2026-04-12T08:10:00.000Z",
#>       "last_edited_time": "2026-04-12T08:11:00.000Z",
#>       "created_by": {
#>         "object": "user",
#>         "id": "6b786605-e456-4237-9c61-5efaff23c081"
#>       },
#>       "last_edited_by": {
#>         "object": "user",
#>         "id": "6b786605-e456-4237-9c61-5efaff23c081"
#>       },
#>       "cover": {},
#>       "icon": {},
#>       "parent": {
#>         "type": "data_source_id",
#>         "data_source_id": "34033ea0-c1e4-81a2-aaf4-000b260f79c9",
#>         "database_id": "efab1bec-0094-4afe-a90c-c9b72d538b4b"
#>       },
#>       "in_trash": false,
#>       "is_archived": false,
#>       "is_locked": false,
#>       "properties": {
#>         "Status": {
#>           "id": "BvMv",
#>           "type": "status",
#>           "status": {
#>             "id": "d240ac03-dfab-4eb3-8a98-2330b66c38f7",
#>             "name": "To do",
#>             "color": "red"
#>           }
#>         },
#>         "Title": {
#>           "id": "title",
#>           "type": "title",
#>           "title": [
#>             {
#>               "type": "text",
#>               "text": {
#>                 "content": "Test Page for notionapi",
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
#>               "plain_text": "Test Page for notionapi",
#>               "href": {}
#>             }
#>           ]
#>         }
#>       },
#>       "url": "https://www.notion.so/Test-Page-for-notionapi-34033ea0c1e48181a411fcffc69c690a",
#>       "public_url": {}
#>     }
#>   ],
#>   "next_cursor": {},
#>   "has_more": false,
#>   "type": "page_or_data_source",
#>   "page_or_data_source": {},
#>   "request_id": "53ec7339-c4ab-4cb1-875f-9d72c6750911"
#> } 
```
