# R6 Class for Comments Endpoint

Handle all comments operations in the Notion API

**Note:** Access this endpoint through the client instance, e.g.,
`notion$comments`. Not to be instantiated directly.

## Value

A list containing the parsed API response.

## Methods

### Public methods

- [`CommentsEndpoint$new()`](#method-CommentsEndpoint-new)

- [`CommentsEndpoint$create()`](#method-CommentsEndpoint-create)

- [`CommentsEndpoint$retrieve()`](#method-CommentsEndpoint-retrieve)

- [`CommentsEndpoint$list()`](#method-CommentsEndpoint-list)

------------------------------------------------------------------------

### Method `new()`

Initialise comments endpoint. Not to be called directly, e.g., use
`notion$comments` instead.

#### Usage

    CommentsEndpoint$new(client)

#### Arguments

- `client`:

  Notion Client instance

------------------------------------------------------------------------

### Method `create()`

Create a comment

#### Usage

    CommentsEndpoint$create(
      rich_text,
      parent = NULL,
      discussion_id = NULL,
      attachments = NULL,
      display_name = NULL
    )

#### Arguments

- `rich_text`:

  List of lists (JSON array) (required). [Rich text
  object(s)](https://developers.notion.com/reference/rich-text)
  representing the content of the comment.

- `parent`:

  List (JSON object). The parent of the comment. This can be a page or a
  block. Required if `discussion_id` is not provided.

- `discussion_id`:

  Character. The ID of the discussion to comment on. Required if
  `parent` is not provided.

- `attachments`:

  List of lists (JSON array). An array of files to attach to the
  comment. Maximum of 3 allowed.

- `display_name`:

  Named list (JSON object). Display name for the comment.

#### Details

[Endpoint
documentation](https://developers.notion.com/reference/create-a-comment)

------------------------------------------------------------------------

### Method `retrieve()`

Retrieve comments for a block

#### Usage

    CommentsEndpoint$retrieve(comment_id)

#### Arguments

- `comment_id`:

  Character (required). The ID of the comment to retrieve.

#### Details

[Endpoint
documentation](https://developers.notion.com/reference/retrieve-comment)

------------------------------------------------------------------------

### Method [`list()`](https://rdrr.io/r/base/list.html)

List comments

#### Usage

    CommentsEndpoint$list(block_id, start_cursor = NULL, page_size = NULL)

#### Arguments

- `block_id`:

  Character (required). The ID for a Notion block or page.

- `start_cursor`:

  Character. For pagination. If provided, returns results starting from
  this cursor. If NULL, returns the first page of results.

- `page_size`:

  Integer. Number of items to return per page (1-100). Defaults to 100.

## Examples

``` r
notion <- notion_client()
# ----- Create comment
notion$comments$create(
  parent = list(
    page_id = "34033ea0-c1e4-8181-a411-fcffc69c690a"
  ),
  rich_text = list(
    list(
      text = list(
        content = "Hello world!"
      )
    )
  )
)
#> {
#>   "object": "comment",
#>   "id": "34033ea0-c1e4-81a9-ba52-001d7629e201",
#>   "parent": {
#>     "type": "page_id",
#>     "page_id": "34033ea0-c1e4-8181-a411-fcffc69c690a"
#>   },
#>   "discussion_id": "34033ea0-c1e4-8128-ac6c-001c0bc74a7f",
#>   "created_time": "2026-04-12T08:11:00.000Z",
#>   "last_edited_time": "2026-04-12T08:11:00.000Z",
#>   "created_by": {
#>     "object": "user",
#>     "id": "6b786605-e456-4237-9c61-5efaff23c081"
#>   },
#>   "rich_text": [
#>     {
#>       "type": "text",
#>       "text": {
#>         "content": "Hello world!",
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
#>       "plain_text": "Hello world!",
#>       "href": {}
#>     }
#>   ],
#>   "display_name": {
#>     "type": "integration",
#>     "resolved_name": "brenwin-internal"
#>   },
#>   "request_id": "74ba3c45-2841-4ba2-be0a-81b0445ac1f3"
#> } 
# ----- Retrieve comment
notion$comments$retrieve("34033ea0-c1e4-81a9-ba52-001d7629e201")
#> {
#>   "object": "comment",
#>   "id": "34033ea0-c1e4-81a9-ba52-001d7629e201",
#>   "parent": {
#>     "type": "page_id",
#>     "page_id": "34033ea0-c1e4-8181-a411-fcffc69c690a"
#>   },
#>   "discussion_id": "34033ea0-c1e4-8128-ac6c-001c0bc74a7f",
#>   "created_time": "2026-04-12T08:11:00.000Z",
#>   "last_edited_time": "2026-04-12T08:11:00.000Z",
#>   "created_by": {
#>     "object": "user",
#>     "id": "6b786605-e456-4237-9c61-5efaff23c081"
#>   },
#>   "rich_text": [
#>     {
#>       "type": "text",
#>       "text": {
#>         "content": "Hello world!",
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
#>       "plain_text": "Hello world!",
#>       "href": {}
#>     }
#>   ],
#>   "display_name": {
#>     "type": "integration",
#>     "resolved_name": "brenwin-internal"
#>   },
#>   "request_id": "af640bea-f6f7-43b4-9e7a-f73d1a7bce81"
#> } 
# ----- List un-resolved comments from a page or block
notion$comments$list("34033ea0-c1e4-8181-a411-fcffc69c690a")
#> {
#>   "object": "list",
#>   "results": [
#>     {
#>       "object": "comment",
#>       "id": "34033ea0-c1e4-81a9-ba52-001d7629e201",
#>       "parent": {
#>         "type": "page_id",
#>         "page_id": "34033ea0-c1e4-8181-a411-fcffc69c690a"
#>       },
#>       "discussion_id": "34033ea0-c1e4-8128-ac6c-001c0bc74a7f",
#>       "created_time": "2026-04-12T08:11:00.000Z",
#>       "last_edited_time": "2026-04-12T08:11:00.000Z",
#>       "created_by": {
#>         "object": "user",
#>         "id": "6b786605-e456-4237-9c61-5efaff23c081"
#>       },
#>       "rich_text": [
#>         {
#>           "type": "text",
#>           "text": {
#>             "content": "Hello world!",
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
#>           "plain_text": "Hello world!",
#>           "href": {}
#>         }
#>       ],
#>       "display_name": {
#>         "type": "integration",
#>         "resolved_name": "brenwin-internal"
#>       }
#>     }
#>   ],
#>   "next_cursor": {},
#>   "has_more": false,
#>   "type": "comment",
#>   "comment": {},
#>   "request_id": "897af6ef-a7d4-42a3-88c7-5ea9b538c19a"
#> } 
```
