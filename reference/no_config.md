# Create empty property configuration

Helper function that creates an empty named list for property
configurations that require no additional settings.

Many [database
properties](https://developers.notion.com/reference/property-object)
like text, checkbox and date do not need configuration settings. This
function returns the empty configuration
([`{}`](https://rdrr.io/r/base/Paren.html) in JSON) that these
properties expect.

## Usage

``` r
no_config()
```

## Value

An empty `named list` that serialises to
[`{}`](https://rdrr.io/r/base/Paren.html) in JSON

## Examples

``` r
notion <- notion_client()
# ----- Create a data source
notion$data_sources$create(
  list(
    database_id = "5f9759b2-ad71-4b66-880f-d0306614227b"
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
```
