# R6 Class for Databases Endpoint

Handle all databases operations in the Notion API

**Note:** Access this endpoint through the client instance, e.g.,
`notion$databases`. Not to be instantiated directly.

## Value

A list containing the parsed API response.

## Methods

### Public methods

- [`DatabasesEndpoint$new()`](#method-DatabasesEndpoint-new)

- [`DatabasesEndpoint$create()`](#method-DatabasesEndpoint-create)

- [`DatabasesEndpoint$retrieve()`](#method-DatabasesEndpoint-retrieve)

- [`DatabasesEndpoint$update()`](#method-DatabasesEndpoint-update)

------------------------------------------------------------------------

### Method `new()`

Initialise databases endpoint. Not to be called directly, e.g., use
`notion$databases` instead.

#### Usage

    DatabasesEndpoint$new(client)

#### Arguments

- `client`:

  Notion Client instance

------------------------------------------------------------------------

### Method `create()`

Create a database

#### Usage

    DatabasesEndpoint$create(
      parent,
      title = NULL,
      description = NULL,
      is_inline = NULL,
      initial_data_source = NULL,
      icon = NULL,
      cover = NULL
    )

#### Arguments

- `parent`:

  Named list (JSON object) (required). The parent page or workspace
  where the database will be created.

- `title`:

  List of lists (JSON array). The title of the database.

- `description`:

  List of lists (JSON array). The description of the database.

- `is_inline`:

  Boolean. Whether the database should be displayed inline in the parent
  page. Defaults to false.

- `initial_data_source`:

  Named list (JSON object). Initial data source configuration for the
  database

- `icon`:

  Named list (JSON object). The icon for the database.

- `cover`:

  Named list (JSON object). The cover image for the database.

#### Details

[Endpoint
documentation](https://developers.notion.com/reference/create-database)

------------------------------------------------------------------------

### Method `retrieve()`

Retrieve a database

#### Usage

    DatabasesEndpoint$retrieve(database_id)

#### Arguments

- `database_id`:

  String (required). The ID of a Notion database.

#### Details

[Endpoint
documentation](https://developers.notion.com/reference/retrieve-database)

------------------------------------------------------------------------

### Method [`update()`](https://rdrr.io/r/stats/update.html)

Update a database

#### Usage

    DatabasesEndpoint$update(
      database_id,
      parent = NULL,
      title = NULL,
      description = NULL,
      is_inline = NULL,
      icon = NULL,
      cover = NULL,
      in_trash = NULL,
      is_locked = NULL
    )

#### Arguments

- `database_id`:

  String (required). The ID of a Notion database.

- `parent`:

  Named list (JSON object). The parent page or workspace to move the
  database to. If not provided, the database will not be moved.

- `title`:

  List of lists (JSON array). The updated title of the database.

- `description`:

  List of lists (JSON array). The updated description of the database.

- `is_inline`:

  Boolean. Whether the database should be displayed in the parent page.

- `icon`:

  Named list (JSON object). The updated icon for the database.

- `cover`:

  Named list (JSON object). The updated cover image for the database.

- `in_trash`:

  Boolean. Whether the database should be moved to or from the trash.

- `is_locked`:

  Boolean. Whether the database should be locked from editing.

#### Details

[Endpoint
documentation](https://developers.notion.com/reference/update-database)

## Examples

``` r
notion <- notion_client()
# ----- Create a database
notion$databases$create(
  list(
    type = "page_id",
    page_id = "22f33ea0c1e480b99c77d1ab72aedff9"
  ),
  title = list(list(
    text = list(
      content = "Test Database"
    )
  ))
)
#> {
#>   "object": "database",
#>   "id": "efab1bec-0094-4afe-a90c-c9b72d538b4b",
#>   "title": [
#>     {
#>       "type": "text",
#>       "text": {
#>         "content": "Test Database",
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
#>       "plain_text": "Test Database",
#>       "href": {}
#>     }
#>   ],
#>   "description": [],
#>   "parent": {
#>     "type": "page_id",
#>     "page_id": "22f33ea0-c1e4-80b9-9c77-d1ab72aedff9"
#>   },
#>   "is_inline": false,
#>   "in_trash": false,
#>   "is_locked": false,
#>   "created_time": "2026-04-12T08:11:07.514+00:00",
#>   "last_edited_time": "2026-04-12T08:11:07.514+00:00",
#>   "data_sources": [
#>     {
#>       "id": "4b00477f-d3cf-4c86-a677-a10075c11fd2",
#>       "name": "Test Database"
#>     }
#>   ],
#>   "icon": {},
#>   "cover": {},
#>   "url": "https://www.notion.so/efab1bec00944afea90cc9b72d538b4b",
#>   "public_url": {},
#>   "request_id": "a38576d0-12fa-4266-9e14-49373e12fd99"
#> } 
# ----- Retrieve a database
notion$databases$retrieve("efab1bec-0094-4afe-a90c-c9b72d538b4b")
#> {
#>   "object": "database",
#>   "id": "efab1bec-0094-4afe-a90c-c9b72d538b4b",
#>   "title": [
#>     {
#>       "type": "text",
#>       "text": {
#>         "content": "Test Database",
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
#>       "plain_text": "Test Database",
#>       "href": {}
#>     }
#>   ],
#>   "description": [],
#>   "parent": {
#>     "type": "page_id",
#>     "page_id": "22f33ea0-c1e4-80b9-9c77-d1ab72aedff9"
#>   },
#>   "is_inline": false,
#>   "in_trash": false,
#>   "is_locked": false,
#>   "created_time": "2026-04-12T08:11:07.514+00:00",
#>   "last_edited_time": "2026-04-12T08:11:07.514+00:00",
#>   "data_sources": [
#>     {
#>       "id": "4b00477f-d3cf-4c86-a677-a10075c11fd2",
#>       "name": "Test Database"
#>     }
#>   ],
#>   "icon": {},
#>   "cover": {},
#>   "url": "https://www.notion.so/efab1bec00944afea90cc9b72d538b4b",
#>   "public_url": {},
#>   "request_id": "e3ea8198-6336-42e9-bffe-76746fc3a309"
#> } 
# ----- Update a database
notion$databases$update(
  "efab1bec-0094-4afe-a90c-c9b72d538b4b",
  description = list(list(
    text = list(
      content = "For testing purposes"
    )
  )),
  icon = list(
    emoji = "🤩"
  )
)
#> {
#>   "object": "database",
#>   "id": "efab1bec-0094-4afe-a90c-c9b72d538b4b",
#>   "title": [
#>     {
#>       "type": "text",
#>       "text": {
#>         "content": "Test Database",
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
#>       "plain_text": "Test Database",
#>       "href": {}
#>     }
#>   ],
#>   "description": [
#>     {
#>       "type": "text",
#>       "text": {
#>         "content": "For testing purposes",
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
#>       "plain_text": "For testing purposes",
#>       "href": {}
#>     }
#>   ],
#>   "parent": {
#>     "type": "page_id",
#>     "page_id": "22f33ea0-c1e4-80b9-9c77-d1ab72aedff9"
#>   },
#>   "is_inline": false,
#>   "in_trash": false,
#>   "is_locked": false,
#>   "created_time": "2026-04-12T08:11:07.514+00:00",
#>   "last_edited_time": "2026-04-12T08:11:07.514+00:00",
#>   "data_sources": [
#>     {
#>       "id": "4b00477f-d3cf-4c86-a677-a10075c11fd2",
#>       "name": "Test Database"
#>     }
#>   ],
#>   "icon": {
#>     "type": "emoji",
#>     "emoji": "🤩"
#>   },
#>   "cover": {},
#>   "url": "https://www.notion.so/efab1bec00944afea90cc9b72d538b4b",
#>   "public_url": {},
#>   "request_id": "59b336e3-8e9e-4935-b56c-f7d1e2293657"
#> } 
```
