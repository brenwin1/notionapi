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
```
