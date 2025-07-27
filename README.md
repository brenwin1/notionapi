
<!-- README.md is generated from README.Rmd. Please edit that file -->

# notionapi

<!-- badges: start -->

[![R-CMD-check](https://github.com/brenwin1/notionapi/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/brenwin1/notionapi/actions/workflows/R-CMD-check.yaml)
[![Codecov test
coverage](https://codecov.io/gh/brenwin1/notionapi/graph/badge.svg)](https://app.codecov.io/gh/brenwin1/notionapi)
<!-- badges: end -->

notionapi is an R client library for [Notion
API](https://developers.notion.com/), enabling users to programmatically
interact with their Notion workspaces. The package provides complete API
coverage for managing pages and databases, managing content blocks,
handling comments and retrieving user information.

The package is designed to mirror the [Official Notion JavaScript
Client](https://github.com/makenotion/notion-sdk-js), using R6 classes
to provide a familiar object-oriented interface and consistent API
structure.

## Installation

Install the package from CRAN:

``` r
install.packages("notionapi")
```

Or install the development version from GitHub:

``` r
pak::pak("brenwin1/notionapi")
```

## Authentication

To initialise the Notion client, you need a Notion integration token.

1.  **Create an integration** in your Notion workspace following [these
    instructions](https://developers.notion.com/docs/authorization#internal-integration-auth-flow-set-up).

2.  **Copy the integration token** from your integration settings.

3.  **Set the token** as an environment variable:

``` r
usethis::edit_r_environ()
# add NOTION_TOKEN=<your_integration_token>
```

4.  [Share
    pages/databases](https://developers.notion.com/docs/authorization#integration-permissions)
    with your integration in Notion.

5.  **Restart your R session** to load the environment variable.

## Usage

Use `notion_client()` or `async_notion_client()` to create a client
instance for accessing the API endpoints:

The client organises methods into logical endpoint groups like pages,
databases, and blocks. Each method maps directly to an endpoint, with
parameters available as function arguments.

See the [Notion API
reference](https://developers.notion.com/reference/intro) for complete
endpoint documentation.

``` r
library(notionapi)

# Create a Notion client instance
notion <- notion_client()

# Access the users endpoint to list all users in your Notion workspace
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
#>   "request_id": "7d7ccc1b-6c83-4c6c-b832-2297f4b68a79"
#> }
```

API resonses are automatically converted from JSON to R lists.

### Serialisation

R data structures are automatically converted to the JSON format
expected by the Notion API:

- `lists` → JSON object
- `list of lists` → JSON array

Examples are provided throughout the [reference
documentation](https://brenwin1.github.io/notionapi/reference/index.html).
See [CommentsEndpoint
create()](https://brenwin1.github.io/notionapi/reference/CommentsEndpoint.html#ref-examples)
method for an example.

### Pagination

See
[Pagination](https://developers.notion.com/reference/intro#pagination)
section in Notion API documentation for supported endpoints and
implementation details.

Pagination parameters (`page_size` and `start_cursor`) are exposed as
function arguments.

For an example, see [BlocksChildrenEndpoint
retrieve()](https://brenwin1.github.io/notionapi/reference/BlocksChildrenEndpoint.html#ref-examples)
method.
