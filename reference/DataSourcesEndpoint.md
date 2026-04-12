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
    database_id = "ffec20ee-1450-4da8-9904-f4babba0e9c0"
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
#>   "id": "34033ea0-c1e4-8112-bc3a-000bc940aa45",
#>   "cover": {},
#>   "icon": {},
#>   "created_time": "2026-04-12T21:18:00.000Z",
#>   "created_by": {
#>     "object": "user",
#>     "id": "6b786605-e456-4237-9c61-5efaff23c081"
#>   },
#>   "last_edited_by": {
#>     "object": "user",
#>     "id": "6b786605-e456-4237-9c61-5efaff23c081"
#>   },
#>   "last_edited_time": "2026-04-12T21:18:00.000Z",
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
#>     "database_id": "ffec20ee-1450-4da8-9904-f4babba0e9c0"
#>   },
#>   "database_parent": {
#>     "type": "page_id",
#>     "page_id": "22f33ea0-c1e4-80b9-9c77-d1ab72aedff9"
#>   },
#>   "url": "https://www.notion.so/ffec20ee14504da89904f4babba0e9c0",
#>   "public_url": {},
#>   "in_trash": false,
#>   "request_id": "9e3c8632-8dd5-49de-b94a-d288b45ef015"
#> } 
# ----- Update data source
notion$data_sources$update(
  "34033ea0-c1e4-8112-bc3a-000bc940aa45",
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
#>   "id": "34033ea0-c1e4-8112-bc3a-000bc940aa45",
#>   "cover": {},
#>   "icon": {},
#>   "created_time": "2026-04-12T21:18:00.000Z",
#>   "created_by": {
#>     "object": "user",
#>     "id": "6b786605-e456-4237-9c61-5efaff23c081"
#>   },
#>   "last_edited_by": {
#>     "object": "user",
#>     "id": "6b786605-e456-4237-9c61-5efaff23c081"
#>   },
#>   "last_edited_time": "2026-04-12T21:18:00.000Z",
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
#>       "id": "%60w%5CX",
#>       "name": "Status",
#>       "description": {},
#>       "type": "status",
#>       "status": {
#>         "options": [
#>           {
#>             "id": "c8f1b3f9-4927-44c4-9901-f94d31e7c351",
#>             "name": "To do",
#>             "color": "red",
#>             "description": {}
#>           },
#>           {
#>             "id": "2aaeb7fd-e8fd-460c-8706-4dc0c76f42b0",
#>             "name": "Done",
#>             "color": "green",
#>             "description": {}
#>           }
#>         ],
#>         "groups": [
#>           {
#>             "id": "dce53bc5-e097-47f9-a9ad-8cd0ff8398c2",
#>             "name": "To-do",
#>             "color": "gray",
#>             "option_ids": [
#>               "c8f1b3f9-4927-44c4-9901-f94d31e7c351",
#>               "2aaeb7fd-e8fd-460c-8706-4dc0c76f42b0"
#>             ]
#>           },
#>           {
#>             "id": "254fc129-7492-43ee-a3ce-31a08d9f5169",
#>             "name": "In progress",
#>             "color": "blue",
#>             "option_ids": []
#>           },
#>           {
#>             "id": "1ee6424f-428e-4670-839f-c2b69f973883",
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
#>     "database_id": "ffec20ee-1450-4da8-9904-f4babba0e9c0"
#>   },
#>   "database_parent": {
#>     "type": "page_id",
#>     "page_id": "22f33ea0-c1e4-80b9-9c77-d1ab72aedff9"
#>   },
#>   "url": "https://www.notion.so/ffec20ee14504da89904f4babba0e9c0",
#>   "public_url": {},
#>   "in_trash": false,
#>   "request_id": "1b26e9fe-ce3e-4d97-b9c2-3443c2f0fdad"
#> } 
# ----- Retrieve a data source
notion$data_sources$retrieve("34033ea0-c1e4-8112-bc3a-000bc940aa45")
#> {
#>   "object": "data_source",
#>   "id": "34033ea0-c1e4-8112-bc3a-000bc940aa45",
#>   "cover": {},
#>   "icon": {},
#>   "created_time": "2026-04-12T21:18:00.000Z",
#>   "created_by": {
#>     "object": "user",
#>     "id": "6b786605-e456-4237-9c61-5efaff23c081"
#>   },
#>   "last_edited_by": {
#>     "object": "user",
#>     "id": "6b786605-e456-4237-9c61-5efaff23c081"
#>   },
#>   "last_edited_time": "2026-04-12T21:18:00.000Z",
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
#>       "id": "%60w%5CX",
#>       "name": "Status",
#>       "description": {},
#>       "type": "status",
#>       "status": {
#>         "options": [
#>           {
#>             "id": "c8f1b3f9-4927-44c4-9901-f94d31e7c351",
#>             "name": "To do",
#>             "color": "red",
#>             "description": {}
#>           },
#>           {
#>             "id": "2aaeb7fd-e8fd-460c-8706-4dc0c76f42b0",
#>             "name": "Done",
#>             "color": "green",
#>             "description": {}
#>           }
#>         ],
#>         "groups": [
#>           {
#>             "id": "dce53bc5-e097-47f9-a9ad-8cd0ff8398c2",
#>             "name": "To-do",
#>             "color": "gray",
#>             "option_ids": [
#>               "c8f1b3f9-4927-44c4-9901-f94d31e7c351",
#>               "2aaeb7fd-e8fd-460c-8706-4dc0c76f42b0"
#>             ]
#>           },
#>           {
#>             "id": "254fc129-7492-43ee-a3ce-31a08d9f5169",
#>             "name": "In progress",
#>             "color": "blue",
#>             "option_ids": []
#>           },
#>           {
#>             "id": "1ee6424f-428e-4670-839f-c2b69f973883",
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
#>     "database_id": "ffec20ee-1450-4da8-9904-f4babba0e9c0"
#>   },
#>   "database_parent": {
#>     "type": "page_id",
#>     "page_id": "22f33ea0-c1e4-80b9-9c77-d1ab72aedff9"
#>   },
#>   "url": "https://www.notion.so/ffec20ee14504da89904f4babba0e9c0",
#>   "public_url": {},
#>   "in_trash": false,
#>   "request_id": "ff0ad355-21a4-4077-9540-c48694de4c84"
#> } 
# ----- List data source templates
notion$data_sources$list_templates("34033ea0-c1e4-8112-bc3a-000bc940aa45")
#> {
#>   "templates": [],
#>   "has_more": false,
#>   "next_cursor": {}
#> } 
# ----- Query a data source
notion$data_sources$query(
  "34033ea0-c1e4-8112-bc3a-000bc940aa45",
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
#>       "id": "34033ea0-c1e4-81c4-afa0-d1ec98de4bec",
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
#>       "cover": {},
#>       "icon": {},
#>       "parent": {
#>         "type": "data_source_id",
#>         "data_source_id": "34033ea0-c1e4-8112-bc3a-000bc940aa45",
#>         "database_id": "ffec20ee-1450-4da8-9904-f4babba0e9c0"
#>       },
#>       "in_trash": false,
#>       "is_archived": false,
#>       "is_locked": false,
#>       "properties": {
#>         "Status": {
#>           "id": "%60w%5CX",
#>           "type": "status",
#>           "status": {
#>             "id": "c8f1b3f9-4927-44c4-9901-f94d31e7c351",
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
#>       "url": "https://www.notion.so/Test-Page-for-notionapi-34033ea0c1e481c4afa0d1ec98de4bec",
#>       "public_url": {}
#>     }
#>   ],
#>   "next_cursor": {},
#>   "has_more": false,
#>   "type": "page_or_data_source",
#>   "page_or_data_source": {},
#>   "request_id": "bb6fd9bd-1358-4c06-806b-32b79a79f6f3"
#> } 
```
