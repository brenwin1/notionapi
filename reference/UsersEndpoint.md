# R6 Class for Users Endpoint

Handle all users operations in the Notion API

**Note:** Access this endpoint through the client instance, e.g.,
`notion$users`. Not to be instantiated directly.

## Value

A list containing the parsed API response.

## Methods

### Public methods

- [`UsersEndpoint$new()`](#method-UsersEndpoint-new)

- [`UsersEndpoint$list()`](#method-UsersEndpoint-list)

- [`UsersEndpoint$retrieve()`](#method-UsersEndpoint-retrieve)

- [`UsersEndpoint$me()`](#method-UsersEndpoint-me)

------------------------------------------------------------------------

### Method `new()`

Initialise users endpoint. Not to be called directly, e.g., use
`notion$users` instead.

#### Usage

    UsersEndpoint$new(client)

#### Arguments

- `client`:

  Notion Client instance

------------------------------------------------------------------------

### Method [`list()`](https://rdrr.io/r/base/list.html)

List all users

#### Usage

    UsersEndpoint$list(start_cursor = NULL, page_size = NULL)

#### Arguments

- `start_cursor`:

  Character. For pagination. If provided, returns results starting from
  this cursor. If NULL, returns the first page of results.

- `page_size`:

  Integer. Number of items to return per page (1-100). Defaults to 100.

#### Details

[Endpoint
documentation](https://developers.notion.com/reference/get-users)

------------------------------------------------------------------------

### Method `retrieve()`

Retrieve a user

#### Usage

    UsersEndpoint$retrieve(user_id)

#### Arguments

- `user_id`:

  Character (required). The ID of the user to retrieve.

#### Details

[Endpoint
documentation](https://developers.notion.com/reference/get-user)

------------------------------------------------------------------------

### Method `me()`

Retrieve the bot User associated with the API token

#### Usage

    UsersEndpoint$me()

#### Details

[Endpoint
documentation](https://developers.notion.com/reference/get-self)

## Examples

``` r
notion <- notion_client()
# ----- List all users
notion$users$list()
#> {
#>   "object": "list",
#>   "results": [
#>     {
#>       "object": "user",
#>       "id": "fda12729-108d-4eb5-bbfb-a8f0886794d1",
#>       "name": "Brenwin",
#>       "avatar_url": {},
#>       "type": "person",
#>       "person": {}
#>     },
#>     {
#>       "object": "user",
#>       "id": "6b786605-e456-4237-9c61-5efaff23c081",
#>       "name": "brenwin-internal",
#>       "avatar_url": {},
#>       "type": "bot",
#>       "bot": {
#>         "owner": {
#>           "type": "workspace",
#>           "workspace": true
#>         },
#>         "workspace_name": "Brenwin's Notion",
#>         "workspace_id": "8c95f187-450c-4f67-a013-54f17e298330",
#>         "workspace_limits": {
#>           "max_file_upload_size_in_bytes": 5368709120
#>         }
#>       }
#>     }
#>   ],
#>   "next_cursor": {},
#>   "has_more": false,
#>   "type": "user",
#>   "user": {},
#>   "request_id": "51455bfd-248a-473d-9934-61a0e620adcd"
#> } 
# ----- Retrieve a user
notion$users$retrieve("fda12729-108d-4eb5-bbfb-a8f0886794d1")
#> {
#>   "object": "user",
#>   "id": "fda12729-108d-4eb5-bbfb-a8f0886794d1",
#>   "name": "Brenwin",
#>   "avatar_url": {},
#>   "type": "person",
#>   "person": {},
#>   "request_id": "4b9c365b-111b-4953-8001-62ed473f5d25"
#> } 
# ----- Retrieve the bot User associated with the API token
notion$users$me()
#> {
#>   "object": "user",
#>   "id": "6b786605-e456-4237-9c61-5efaff23c081",
#>   "name": "brenwin-internal",
#>   "avatar_url": {},
#>   "type": "bot",
#>   "bot": {
#>     "owner": {
#>       "type": "workspace",
#>       "workspace": true
#>     },
#>     "workspace_name": "Brenwin's Notion",
#>     "workspace_id": "8c95f187-450c-4f67-a013-54f17e298330",
#>     "workspace_limits": {
#>       "max_file_upload_size_in_bytes": 5368709120
#>     }
#>   },
#>   "request_id": "1fbcf654-9565-4142-a863-c4ab23392e5d"
#> } 
```
