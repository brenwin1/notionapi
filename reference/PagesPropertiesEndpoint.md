# R6 Class for Pages Properties Endpoint

Handle all pages properties operations in the Notion API

**Note:** Access this endpoint through the client instance, e.g.,
`notion$pages$properties`. Not to be instantiated directly.

## Value

A list containing the parsed API response.

## Methods

### Public methods

- [`PagesPropertiesEndpoint$new()`](#method-PagesPropertiesEndpoint-new)

- [`PagesPropertiesEndpoint$retrieve()`](#method-PagesPropertiesEndpoint-retrieve)

------------------------------------------------------------------------

### Method `new()`

Initialise pages properties endpoint. Not to be called directly, e.g.,
use `notion$pages$properties` instead.

#### Usage

    PagesPropertiesEndpoint$new(client)

#### Arguments

- `client`:

  Notion Client instance

------------------------------------------------------------------------

### Method `retrieve()`

Retrieve a page property item

#### Usage

    PagesPropertiesEndpoint$retrieve(
      page_id,
      property_id,
      start_cursor = NULL,
      page_size = NULL
    )

#### Arguments

- `page_id`:

  Character (required). The ID for a Notion page.

- `property_id`:

  Character (required). The ID of the property to retrieve.

- `start_cursor`:

  Character. For pagination. If provided, returns results starting from
  this cursor. If NULL, returns the first page of results.

- `page_size`:

  Integer. Number of items to return per page (1-100). Defaults to 100.

#### Details

[Endpoint
documentation](https://developers.notion.com/reference/retrieve-a-page-property)

## Examples

``` r
notion <- notion_client()
# ----- Retrieve a page property
notion$pages$properties$retrieve(
  "34033ea0-c1e4-8181-a411-fcffc69c690a",
  "BvMv"
)
#> {
#>   "object": "property_item",
#>   "type": "status",
#>   "id": "BvMv",
#>   "status": {
#>     "id": "d240ac03-dfab-4eb3-8a98-2330b66c38f7",
#>     "name": "To do",
#>     "color": "red"
#>   },
#>   "request_id": "b72cd44e-0352-41b6-bde8-e9eec5e64b1f"
#> } 
```
