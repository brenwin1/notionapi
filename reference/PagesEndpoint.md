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
#>   "id": "34033ea0-c1e4-8181-a411-fcffc69c690a",
#>   "created_time": "2026-04-12T08:10:00.000Z",
#>   "last_edited_time": "2026-04-12T08:10:00.000Z",
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
#>   "url": "https://www.notion.so/Test-Page-for-notionapi-34033ea0c1e48181a411fcffc69c690a",
#>   "public_url": {},
#>   "request_id": "6c1f40b5-5d1b-46a8-908a-77c36853ee67"
#> } 
# ----- Retrieve a page
notion$pages$retrieve("34033ea0-c1e4-8181-a411-fcffc69c690a")
#> {
#>   "object": "page",
#>   "id": "34033ea0-c1e4-8181-a411-fcffc69c690a",
#>   "created_time": "2026-04-12T08:10:00.000Z",
#>   "last_edited_time": "2026-04-12T08:10:00.000Z",
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
#>   "url": "https://www.notion.so/Test-Page-for-notionapi-34033ea0c1e48181a411fcffc69c690a",
#>   "public_url": {},
#>   "request_id": "a46700f7-201f-42ba-91eb-737e90ce0e19"
#> } 
# ----- Move page into a database
notion$pages$move(
  "34033ea0-c1e4-8181-a411-fcffc69c690a",
  list(
    data_source_id = "34033ea0-c1e4-81a2-aaf4-000b260f79c9"
  )
)
#> {
#>   "object": "page",
#>   "id": "34033ea0-c1e4-8181-a411-fcffc69c690a",
#>   "created_time": "2026-04-12T08:10:00.000Z",
#>   "last_edited_time": "2026-04-12T08:11:00.000Z",
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
#>     "data_source_id": "34033ea0-c1e4-81a2-aaf4-000b260f79c9",
#>     "database_id": "efab1bec-0094-4afe-a90c-c9b72d538b4b"
#>   },
#>   "in_trash": false,
#>   "is_archived": false,
#>   "is_locked": false,
#>   "properties": {
#>     "Status": {
#>       "id": "BvMv",
#>       "type": "status",
#>       "status": {
#>         "id": "d240ac03-dfab-4eb3-8a98-2330b66c38f7",
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
#>   "url": "https://www.notion.so/Test-Page-for-notionapi-34033ea0c1e48181a411fcffc69c690a",
#>   "public_url": {},
#>   "request_id": "14c4f563-c698-45ee-b2c6-5db0b27b3176"
#> } 
# ----- Update a page
notion$pages$update(
  "34033ea0-c1e4-8181-a411-fcffc69c690a",
  icon = list(
    emoji = "🐶"
  )
)
#> {
#>   "object": "page",
#>   "id": "34033ea0-c1e4-8181-a411-fcffc69c690a",
#>   "created_time": "2026-04-12T08:10:00.000Z",
#>   "last_edited_time": "2026-04-12T08:10:00.000Z",
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
#>     "type": "emoji",
#>     "emoji": "🐶"
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
#>   "url": "https://www.notion.so/Test-Page-for-notionapi-34033ea0c1e48181a411fcffc69c690a",
#>   "public_url": {},
#>   "request_id": "d4920b91-f85e-49ff-ba30-8573b8784ebb"
#> } 
# ----- Use `NA` to send JSON `null` — below removes the page's icon
notion$pages$update(
  "34033ea0-c1e4-8181-a411-fcffc69c690a",
  icon = NA
)
#> {
#>   "object": "page",
#>   "id": "34033ea0-c1e4-8181-a411-fcffc69c690a",
#>   "created_time": "2026-04-12T08:10:00.000Z",
#>   "last_edited_time": "2026-04-12T08:10:00.000Z",
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
#>   "url": "https://www.notion.so/Test-Page-for-notionapi-34033ea0c1e48181a411fcffc69c690a",
#>   "public_url": {},
#>   "request_id": "493613d8-e089-40c5-a1d9-45866fed19a1"
#> } 
# ----- Retrieve a page as markdown
notion$pages$retrieve_markdown("34033ea0-c1e4-8181-a411-fcffc69c690a")
#> {
#>   "object": "page_markdown",
#>   "id": "34033ea0-c1e4-8181-a411-fcffc69c690a",
#>   "markdown": "## Updated Test Heading",
#>   "truncated": false,
#>   "unknown_block_ids": [],
#>   "request_id": "644d1b20-faa9-41b6-b9eb-dc6d3b14d51a"
#> } 
# ----- Update/replace a page content
notion$pages$update_markdown(
  "34033ea0-c1e4-8181-a411-fcffc69c690a",
  "replace_content",
  replace_content = list(
    new_str = '## Updated Test Heading\nUsed markdown{color="blue"}'
  )
)
#> {
#>   "object": "page_markdown",
#>   "id": "34033ea0-c1e4-8181-a411-fcffc69c690a",
#>   "markdown": "## Updated Test Heading\nUsed markdown {color=\"blue\"}",
#>   "truncated": false,
#>   "unknown_block_ids": [],
#>   "request_id": "068f9057-33d2-4ee2-be77-c0a43f75ac58"
#> } 
# ----- Trash a page
notion$pages$update(
  "34033ea0-c1e4-8181-a411-fcffc69c690a",
  in_trash = TRUE
)
#> {
#>   "object": "page",
#>   "id": "34033ea0-c1e4-8181-a411-fcffc69c690a",
#>   "created_time": "2026-04-12T08:10:00.000Z",
#>   "last_edited_time": "2026-04-12T08:11:00.000Z",
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
#>     "data_source_id": "34033ea0-c1e4-81a2-aaf4-000b260f79c9",
#>     "database_id": "efab1bec-0094-4afe-a90c-c9b72d538b4b"
#>   },
#>   "in_trash": true,
#>   "is_archived": false,
#>   "is_locked": false,
#>   "properties": {
#>     "Status": {
#>       "id": "BvMv",
#>       "type": "status",
#>       "status": {
#>         "id": "d240ac03-dfab-4eb3-8a98-2330b66c38f7",
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
#>   "url": "https://www.notion.so/Test-Page-for-notionapi-34033ea0c1e48181a411fcffc69c690a",
#>   "public_url": {},
#>   "request_id": "4341af17-7de4-45da-9741-9da796127da5"
#> } 
```
