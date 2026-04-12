# R6 Class for Pages Endpoint

Handle all pages operations in the Notion API

**Note:** Access this endpoint through the client instance, e.g.,
`notion$pages`. Not to be instantiated directly.

## Value

A list containing the parsed API response.

## Public fields

- `properties`:

  Pages properties endpoint

## Methods

### Public methods

- [`PagesEndpoint$new()`](#method-PagesEndpoint-new)

- [`PagesEndpoint$create()`](#method-PagesEndpoint-create)

- [`PagesEndpoint$retrieve()`](#method-PagesEndpoint-retrieve)

- [`PagesEndpoint$move()`](#method-PagesEndpoint-move)

- [`PagesEndpoint$update()`](#method-PagesEndpoint-update)

- [`PagesEndpoint$retrieve_markdown()`](#method-PagesEndpoint-retrieve_markdown)

- [`PagesEndpoint$update_markdown()`](#method-PagesEndpoint-update_markdown)

------------------------------------------------------------------------

### Method `new()`

Initialise pages endpoint. Not to be called directly, e.g., use
`notion$pages` instead.

#### Usage

    PagesEndpoint$new(client)

#### Arguments

- `client`:

  Notion Client instance

------------------------------------------------------------------------

### Method `create()`

Create a page

#### Usage

    PagesEndpoint$create(
      parent,
      properties = NULL,
      icon = NULL,
      cover = NULL,
      content = NULL,
      children = NULL,
      markdown = NULL,
      template = NULL,
      position = NULL
    )

#### Arguments

- `parent`:

  Named list (JSON object) (required). The parent under which the new
  page is created.

- `properties`:

  Named list (JSON object). Key-value pairs representing the page's
  properties.

- `icon`:

  Named list (JSON object). The page icon.

- `cover`:

  Named list (JSON object). The page cover image.

- `content`:

  List of lists (JSON array). Block objects to append as children to the
  page.

- `children`:

  List of lists (JSON array). Block objects to append as children to the
  page.

- `markdown`:

  Character. Page content as Notion-flavored Markdown. Mutually
  exclusive with content/children.

- `template`:

  Named list (JSON object). A data source template apply to the new
  page. Cannot be combined with children.

- `position`:

  Named list (JSON object). Controls where new blocks are inserted among
  parent's children. Defaults to end of parent block's children when
  omitted.

#### Details

[Endpoint
documentation](https://developers.notion.com/reference/post-page)

------------------------------------------------------------------------

### Method `retrieve()`

Retrieve page properties

#### Usage

    PagesEndpoint$retrieve(page_id, filter_properties = NULL)

#### Arguments

- `page_id`:

  Character (required). The ID for a Notion page.

- `filter_properties`:

  Character vector. Page property value IDs to include in the response
  schema. If NULL (default), all properties are returned.

#### Details

[Endpoint
documentation](https://developers.notion.com/reference/retrieve-a-page)

------------------------------------------------------------------------

### Method `move()`

Move a page

#### Usage

    PagesEndpoint$move(page_id, parent)

#### Arguments

- `page_id`:

  Character (required). The ID of the page to move.

- `parent`:

  Named list (JSON object) (required). The new parent location for the
  page.

#### Details

[Endpoint
documentation](https://developers.notion.com/reference/move-page)

------------------------------------------------------------------------

### Method [`update()`](https://rdrr.io/r/stats/update.html)

Update attributes of a Notion page

#### Usage

    PagesEndpoint$update(
      page_id,
      properties = NULL,
      icon = NULL,
      cover = NULL,
      is_locked = NULL,
      template = NULL,
      erase_content = NULL,
      in_trash = NULL,
      is_archived = NULL
    )

#### Arguments

- `page_id`:

  Character (required). The ID for a Notion page.

- `properties`:

  Named list (JSON object). Key-value pairs representing the page's
  properties.

- `icon`:

  Named list (JSON object). The page icon.

- `cover`:

  Named list (JSON object). The page cover image.

- `is_locked`:

  Boolean. Whether the page should be locked from editing.

- `template`:

  Named list (JSON object). A template to apply to the page.

- `erase_content`:

  Boolean. Whether to erase all existing content from the page.
  Irreversible via the API.

- `in_trash`:

  Boolean. Set to TRUE to trash (delete) the page. Set to FALSE to
  restore the page.

- `is_archived`:

  Boolean. Deprecated alias for `in_trash`. Use `in_trash` for new
  integrations.

#### Details

[Endpoint
documentation](https://developers.notion.com/reference/patch-page)

------------------------------------------------------------------------

### Method `retrieve_markdown()`

Retrieve a page as markdown

#### Usage

    PagesEndpoint$retrieve_markdown(page_id, include_transcript = NULL)

#### Arguments

- `page_id`:

  Character (required). The ID of the page (or block) to to retrieve as
  markdown.

- `include_transcript`:

  Boolean. Whether to include meeting note transcripts. Defaults to
  false.

#### Details

[Endpoint
documentation](https://developers.notion.com/reference/retrieve-page-markdown)

------------------------------------------------------------------------

### Method `update_markdown()`

Update a page's content as markdown

#### Usage

    PagesEndpoint$update_markdown(
      page_id,
      type,
      update_content = NULL,
      replace_content = NULL,
      insert_content = NULL,
      replace_content_range = NULL
    )

#### Arguments

- `page_id`:

  Character (required). The ID of the page to update.

- `type`:

  Character (required). The update command type. One of
  "update_content", "replace_content", "insert_content" and
  "replace_content_range". The first two are recommended.

- `update_content`:

  Named list (JSON object). Update specific content using
  search-and-replace operations.

- `replace_content`:

  Named list (JSON object). Replace the entire page content with new
  markdown.

- `insert_content`:

  Named list (JSON object). Insert new content into the page.

- `replace_content_range`:

  Named list (JSON object). Replace a range of content in the page.

#### Details

[Endpoint
documentation](https://developers.notion.com/reference/update-page-markdown)

## Examples

``` r
notion <- notion_client()
# ----- Create a page
notion$pages$create(
  list(page_id = "22f33ea0c1e480b99c77d1ab72aedff9"),
  list(
    title = list(list(
      text = list(
        content = "Test Page for notionapi"
      )
    ))
  )
)
#> {
#>   "object": "page",
#>   "id": "34033ea0-c1e4-81c4-afa0-d1ec98de4bec",
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
#>   "cover": {},
#>   "icon": {},
#>   "parent": {
#>     "type": "page_id",
#>     "page_id": "22f33ea0-c1e4-80b9-9c77-d1ab72aedff9"
#>   },
#>   "in_trash": false,
#>   "is_archived": false,
#>   "is_locked": false,
#>   "properties": {
#>     "title": {
#>       "id": "title",
#>       "type": "title",
#>       "title": [
#>         {
#>           "type": "text",
#>           "text": {
#>             "content": "Test Page for notionapi",
#>             "link": {}
#>           },
#>           "annotations": {
#>             "bold": false,
#>             "italic": false,
#>             "strikethrough": false,
#>             "underline": false,
#>             "code": false,
#>             "color": "default"
#>           },
#>           "plain_text": "Test Page for notionapi",
#>           "href": {}
#>         }
#>       ]
#>     }
#>   },
#>   "url": "https://www.notion.so/Test-Page-for-notionapi-34033ea0c1e481c4afa0d1ec98de4bec",
#>   "public_url": {},
#>   "request_id": "27988275-4bb1-4fac-a1fd-f91935b37be4"
#> } 
# ----- Retrieve a page
notion$pages$retrieve("34033ea0-c1e4-81c4-afa0-d1ec98de4bec")
#> {
#>   "object": "page",
#>   "id": "34033ea0-c1e4-81c4-afa0-d1ec98de4bec",
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
#>   "cover": {},
#>   "icon": {},
#>   "parent": {
#>     "type": "page_id",
#>     "page_id": "22f33ea0-c1e4-80b9-9c77-d1ab72aedff9"
#>   },
#>   "in_trash": false,
#>   "is_archived": false,
#>   "is_locked": false,
#>   "properties": {
#>     "title": {
#>       "id": "title",
#>       "type": "title",
#>       "title": [
#>         {
#>           "type": "text",
#>           "text": {
#>             "content": "Test Page for notionapi",
#>             "link": {}
#>           },
#>           "annotations": {
#>             "bold": false,
#>             "italic": false,
#>             "strikethrough": false,
#>             "underline": false,
#>             "code": false,
#>             "color": "default"
#>           },
#>           "plain_text": "Test Page for notionapi",
#>           "href": {}
#>         }
#>       ]
#>     }
#>   },
#>   "url": "https://www.notion.so/Test-Page-for-notionapi-34033ea0c1e481c4afa0d1ec98de4bec",
#>   "public_url": {},
#>   "request_id": "e4154030-4256-4516-bbb5-2aa06bd63b43"
#> } 
# ----- Move page into a database
notion$pages$move(
  "34033ea0-c1e4-81c4-afa0-d1ec98de4bec",
  list(
    data_source_id = "34033ea0-c1e4-8112-bc3a-000bc940aa45"
  )
)
#> {
#>   "object": "page",
#>   "id": "34033ea0-c1e4-81c4-afa0-d1ec98de4bec",
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
#>   "cover": {},
#>   "icon": {},
#>   "parent": {
#>     "type": "data_source_id",
#>     "data_source_id": "34033ea0-c1e4-8112-bc3a-000bc940aa45",
#>     "database_id": "ffec20ee-1450-4da8-9904-f4babba0e9c0"
#>   },
#>   "in_trash": false,
#>   "is_archived": false,
#>   "is_locked": false,
#>   "properties": {
#>     "Status": {
#>       "id": "%60w%5CX",
#>       "type": "status",
#>       "status": {
#>         "id": "c8f1b3f9-4927-44c4-9901-f94d31e7c351",
#>         "name": "To do",
#>         "color": "red"
#>       }
#>     },
#>     "Title": {
#>       "id": "title",
#>       "type": "title",
#>       "title": [
#>         {
#>           "type": "text",
#>           "text": {
#>             "content": "Test Page for notionapi",
#>             "link": {}
#>           },
#>           "annotations": {
#>             "bold": false,
#>             "italic": false,
#>             "strikethrough": false,
#>             "underline": false,
#>             "code": false,
#>             "color": "default"
#>           },
#>           "plain_text": "Test Page for notionapi",
#>           "href": {}
#>         }
#>       ]
#>     }
#>   },
#>   "url": "https://www.notion.so/Test-Page-for-notionapi-34033ea0c1e481c4afa0d1ec98de4bec",
#>   "public_url": {},
#>   "request_id": "da21e900-05bd-4ba8-80f9-f777ba07d2e7"
#> } 
# ----- Update a page
notion$pages$update(
  "34033ea0-c1e4-81c4-afa0-d1ec98de4bec",
  icon = list(
    icon = list(
      name = "pizza",
      color = "blue"
    )
  )
)
#> {
#>   "object": "page",
#>   "id": "34033ea0-c1e4-81c4-afa0-d1ec98de4bec",
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
#>   "cover": {},
#>   "icon": {
#>     "type": "icon",
#>     "icon": {
#>       "name": "pizza",
#>       "color": "blue"
#>     }
#>   },
#>   "parent": {
#>     "type": "page_id",
#>     "page_id": "22f33ea0-c1e4-80b9-9c77-d1ab72aedff9"
#>   },
#>   "in_trash": false,
#>   "is_archived": false,
#>   "is_locked": false,
#>   "properties": {
#>     "title": {
#>       "id": "title",
#>       "type": "title",
#>       "title": [
#>         {
#>           "type": "text",
#>           "text": {
#>             "content": "Test Page for notionapi",
#>             "link": {}
#>           },
#>           "annotations": {
#>             "bold": false,
#>             "italic": false,
#>             "strikethrough": false,
#>             "underline": false,
#>             "code": false,
#>             "color": "default"
#>           },
#>           "plain_text": "Test Page for notionapi",
#>           "href": {}
#>         }
#>       ]
#>     }
#>   },
#>   "url": "https://www.notion.so/Test-Page-for-notionapi-34033ea0c1e481c4afa0d1ec98de4bec",
#>   "public_url": {},
#>   "request_id": "a6225487-5bf3-45ca-a5c9-a0e89c7e1e24"
#> } 
# ----- Use `NA` to send JSON `null` — below removes the page's icon
notion$pages$update(
  "34033ea0-c1e4-81c4-afa0-d1ec98de4bec",
  icon = NA
)
#> {
#>   "object": "page",
#>   "id": "34033ea0-c1e4-81c4-afa0-d1ec98de4bec",
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
#>   "cover": {},
#>   "icon": {},
#>   "parent": {
#>     "type": "page_id",
#>     "page_id": "22f33ea0-c1e4-80b9-9c77-d1ab72aedff9"
#>   },
#>   "in_trash": false,
#>   "is_archived": false,
#>   "is_locked": false,
#>   "properties": {
#>     "title": {
#>       "id": "title",
#>       "type": "title",
#>       "title": [
#>         {
#>           "type": "text",
#>           "text": {
#>             "content": "Test Page for notionapi",
#>             "link": {}
#>           },
#>           "annotations": {
#>             "bold": false,
#>             "italic": false,
#>             "strikethrough": false,
#>             "underline": false,
#>             "code": false,
#>             "color": "default"
#>           },
#>           "plain_text": "Test Page for notionapi",
#>           "href": {}
#>         }
#>       ]
#>     }
#>   },
#>   "url": "https://www.notion.so/Test-Page-for-notionapi-34033ea0c1e481c4afa0d1ec98de4bec",
#>   "public_url": {},
#>   "request_id": "f26d7cc4-7f33-42c2-8ec2-0ffa6094823d"
#> } 
# ----- Retrieve a page as markdown
notion$pages$retrieve_markdown("34033ea0-c1e4-81c4-afa0-d1ec98de4bec")
#> {
#>   "object": "page_markdown",
#>   "id": "34033ea0-c1e4-81c4-afa0-d1ec98de4bec",
#>   "markdown": "## Updated Test Heading",
#>   "truncated": false,
#>   "unknown_block_ids": [],
#>   "request_id": "c9b3fd1c-b69f-425e-b9eb-60db8ed7ac65"
#> } 
# ----- Update/replace a page content
notion$pages$update_markdown(
  "34033ea0-c1e4-81c4-afa0-d1ec98de4bec",
  "replace_content",
  replace_content = list(
    new_str = '## Updated Test Heading\nUsed markdown{color="blue"}'
  )
)
#> {
#>   "object": "page_markdown",
#>   "id": "34033ea0-c1e4-81c4-afa0-d1ec98de4bec",
#>   "markdown": "## Updated Test Heading\nUsed markdown {color=\"blue\"}",
#>   "truncated": false,
#>   "unknown_block_ids": [],
#>   "request_id": "35a2bf6b-0ac7-4088-a9a6-27421ffe06c9"
#> } 
# ----- Trash a page
notion$pages$update(
  "34033ea0-c1e4-81c4-afa0-d1ec98de4bec",
  in_trash = TRUE
)
#> {
#>   "object": "page",
#>   "id": "34033ea0-c1e4-81c4-afa0-d1ec98de4bec",
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
#>   "cover": {},
#>   "icon": {},
#>   "parent": {
#>     "type": "data_source_id",
#>     "data_source_id": "34033ea0-c1e4-8112-bc3a-000bc940aa45",
#>     "database_id": "ffec20ee-1450-4da8-9904-f4babba0e9c0"
#>   },
#>   "in_trash": true,
#>   "is_archived": false,
#>   "is_locked": false,
#>   "properties": {
#>     "Status": {
#>       "id": "%60w%5CX",
#>       "type": "status",
#>       "status": {
#>         "id": "c8f1b3f9-4927-44c4-9901-f94d31e7c351",
#>         "name": "To do",
#>         "color": "red"
#>       }
#>     },
#>     "Title": {
#>       "id": "title",
#>       "type": "title",
#>       "title": [
#>         {
#>           "type": "text",
#>           "text": {
#>             "content": "Test Page for notionapi",
#>             "link": {}
#>           },
#>           "annotations": {
#>             "bold": false,
#>             "italic": false,
#>             "strikethrough": false,
#>             "underline": false,
#>             "code": false,
#>             "color": "default"
#>           },
#>           "plain_text": "Test Page for notionapi",
#>           "href": {}
#>         }
#>       ]
#>     }
#>   },
#>   "url": "https://www.notion.so/Test-Page-for-notionapi-34033ea0c1e481c4afa0d1ec98de4bec",
#>   "public_url": {},
#>   "request_id": "076984c7-e5ec-4ced-8346-c9d13f805afe"
#> } 
```
