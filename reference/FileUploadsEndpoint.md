# R6 Class for File Uploads Endpoint

Handle all file uploads operations in the Notion API

**Note:** Access this endpoint through the client instance, e.g.,
`notion$file_uploads`. Not to be instantiated directly.

## Value

A list containing the parsed API response.

## Methods

### Public methods

- [`FileUploadsEndpoint$new()`](#method-FileUploadsEndpoint-new)

- [`FileUploadsEndpoint$create()`](#method-FileUploadsEndpoint-create)

- [`FileUploadsEndpoint$send()`](#method-FileUploadsEndpoint-send)

- [`FileUploadsEndpoint$complete()`](#method-FileUploadsEndpoint-complete)

- [`FileUploadsEndpoint$retrieve()`](#method-FileUploadsEndpoint-retrieve)

- [`FileUploadsEndpoint$list()`](#method-FileUploadsEndpoint-list)

------------------------------------------------------------------------

### Method `new()`

Initialise file uploads endpoint. Not to be called directly, e.g., use
`notion$file_uploads` instead.

#### Usage

    FileUploadsEndpoint$new(client)

#### Arguments

- `client`:

  Notion Client instance

------------------------------------------------------------------------

### Method `create()`

Create a file upload

#### Usage

    FileUploadsEndpoint$create(
      mode = NULL,
      filename = NULL,
      content_type = NULL,
      number_of_parts = NULL,
      external_url = NULL
    )

#### Arguments

- `mode`:

  Character. How the file is being sent. Use "multi_part" for files
  larger than 20MB. Use "external_url" for files that are temporarily
  hosted publicly elsewhere. Default is "single_part".

- `filename`:

  Character. Name of the file to be created. Required when `mode` is
  "multi_part". Must include an extension, or have one inferred from the
  `content_type` parameter.

- `content_type`:

  Character. MIME type of the file to be created.

- `number_of_parts`:

  Integer. When `mode` is "multi_part", the number of parts you are
  uploading.

- `external_url`:

  Character. When `mode` is "external_url", provide the HTTPS URL of a
  publicly accessible file to import into your workspace.

------------------------------------------------------------------------

### Method `send()`

Upload a file

#### Usage

    FileUploadsEndpoint$send(file_upload_id, file, part_number = NULL)

#### Arguments

- `file_upload_id`:

  Character (required). Identifier for a Notion file upload object.

- `file`:

  Named list (JSON object). The raw binary file contents to upload. Must
  contain named elements:

  - `filename`. Character. The name of the file, including it's
    extension (e.g., "report.pdf")

  - `data`. Raw. The binary contents of the file, as returned by e.g.,
    [`readBin()`](https://rdrr.io/r/base/readBin.html)

  - `type`. Character. Optional. The MIME type of the file (e.g.,
    "application/pdf", "image/png"). If not supplied, the type is
    inferred from `filename` by
    [`curl::form_file()`](https://jeroen.r-universe.dev/curl/reference/multipart.html).
    Supported file types are listed
    [here](https://developers.notion.com/guides/data-apis/working-with-files-and-media#supported-file-types).

- `part_number`:

  Character. The current part number when uploading files greater than
  20MB in parts. Must be an integer between 1 and 1,000

------------------------------------------------------------------------

### Method `complete()`

Complete a multi-part file upload

#### Usage

    FileUploadsEndpoint$complete(file_upload_id)

#### Arguments

- `file_upload_id`:

  Character (required). Identifier for a Notion file upload object.

#### Details

[Endpoint
documentation](https://developers.notion.com/reference/complete-file-upload)

------------------------------------------------------------------------

### Method `retrieve()`

Retrieve a file upload

#### Usage

    FileUploadsEndpoint$retrieve(file_upload_id)

#### Arguments

- `file_upload_id`:

  Character (required). Identifier for a Notion file upload object.

#### Details

[Endpoint
documentation](https://developers.notion.com/reference/retrieve-file-upload)

------------------------------------------------------------------------

### Method [`list()`](https://rdrr.io/r/base/list.html)

List file uploads

#### Usage

    FileUploadsEndpoint$list(status = NULL, start_cursor = NULL, page_size = NULL)

#### Arguments

- `status`:

  Character. If supplied, the endpoint will return file uploads with the
  specified status. Available options are "pending", "uploaded",
  "expired", "failed".

- `start_cursor`:

  Character. For pagination. If provided, returns results starting from
  this cursor. If NULL, returns the first page of results.

- `page_size`:

  Integer. Number of items to return per page (1-100). Defaults to 100

#### Details

[Endpoint
documentation](https://developers.notion.com/reference/list-file-uploads)

## Examples

``` r
notion <- notion_client()
# ----- Direct upload (files <= 20MB)
# Step 1: Create a File Upload object
(resp <- notion$file_uploads$create("single_part"))
#> {
#>   "object": "file_upload",
#>   "id": "34033ea0-c1e4-818c-93d0-00b215647918",
#>   "created_time": "2026-04-12T08:11:00.000Z",
#>   "created_by": {
#>     "id": "6b786605-e456-4237-9c61-5efaff23c081",
#>     "type": "bot"
#>   },
#>   "last_edited_time": "2026-04-12T08:11:00.000Z",
#>   "expiry_time": "2026-04-12T09:11:00.000Z",
#>   "upload_url": "https://api.notion.com/v1/file_uploads/34033ea0-c1e4-818c-93d0-00b215647918/send",
#>   "in_trash": false,
#>   "status": "pending",
#>   "filename": {},
#>   "content_type": {},
#>   "content_length": {},
#>   "request_id": "faa76351-7492-4eb5-b6bc-8765d8fe13ae"
#> } 
file_upload_id <- resp[["id"]]

# Step 2: Upload file contents
#* replace with your file
path <- file.path(tempdir(), "test.pdf")
writeBin(charToRaw("placeholder"), path)
raw <- readBin(path, "raw", file.size(path))

notion$file_uploads$send(
  file_upload_id,
  list(
    filename = basename(path),
    data = raw
  )
)
#> {
#>   "object": "file_upload",
#>   "id": "34033ea0-c1e4-818c-93d0-00b215647918",
#>   "created_time": "2026-04-12T08:11:00.000Z",
#>   "created_by": {
#>     "id": "6b786605-e456-4237-9c61-5efaff23c081",
#>     "type": "bot"
#>   },
#>   "last_edited_time": "2026-04-12T08:11:00.000Z",
#>   "expiry_time": "2026-04-12T09:11:00.000Z",
#>   "in_trash": false,
#>   "status": "uploaded",
#>   "filename": "test.pdf",
#>   "content_type": "application/pdf",
#>   "content_length": 40666,
#>   "request_id": "7fe6964c-79de-4e20-85ef-f374ca038b6b"
#> } 

# Retrieve the file upload
notion$file_uploads$retrieve(file_upload_id)
#> {
#>   "object": "file_upload",
#>   "id": "34033ea0-c1e4-818c-93d0-00b215647918",
#>   "created_time": "2026-04-12T08:11:00.000Z",
#>   "created_by": {
#>     "id": "6b786605-e456-4237-9c61-5efaff23c081",
#>     "type": "bot"
#>   },
#>   "last_edited_time": "2026-04-12T08:11:00.000Z",
#>   "expiry_time": "2026-04-12T09:11:00.000Z",
#>   "in_trash": false,
#>   "status": "uploaded",
#>   "filename": "test.pdf",
#>   "content_type": "application/pdf",
#>   "content_length": 40666,
#>   "request_id": "e1614ebc-a66f-419f-8323-79ab382bb691"
#> } 
# ----- Multi-part upload (files > 20MB)
# Step 1: Split raw content into parts
#* replace with your file
raw <- as.raw(rep(65L, 11 * 1024 * 1024))
mid <- ceiling(length(raw) / 2)
parts <- list(raw[seq_len(mid)], raw[seq(mid + 1L, length(raw))])

# Step 2: Create a File Upload object
(resp <- notion$file_uploads$create(
  mode = "multi_part",
  filename = "test-large.txt",
  number_of_parts = 2L
))
#> {
#>   "object": "file_upload",
#>   "id": "34033ea0-c1e4-812d-9565-00b219008b06",
#>   "created_time": "2026-04-12T08:11:00.000Z",
#>   "created_by": {
#>     "id": "6b786605-e456-4237-9c61-5efaff23c081",
#>     "type": "bot"
#>   },
#>   "last_edited_time": "2026-04-12T08:11:00.000Z",
#>   "expiry_time": "2026-04-12T09:11:00.000Z",
#>   "upload_url": "https://api.notion.com/v1/file_uploads/34033ea0-c1e4-812d-9565-00b219008b06/send",
#>   "in_trash": false,
#>   "status": "pending",
#>   "filename": "test-large.txt",
#>   "content_type": "text/plain; charset=utf-8",
#>   "content_length": {},
#>   "number_of_parts": {
#>     "total": 2,
#>     "sent": 0
#>   },
#>   "request_id": "ff5b7545-01fa-4b2d-a9d9-28c1634979db"
#> } 
file_upload_id <- resp[["id"]]

# Step 3: Send each part
for (i in seq_along(parts)) {
  notion$file_uploads$send(
    file_upload_id,
    file = list(
      filename = "test-large.txt",
      data = parts[[i]]
    ),
    part_number = as.character(i)
  )
}

# Step 4: Complete the upload
notion$file_uploads$complete(
  file_upload_id
)
#> {
#>   "object": "file_upload",
#>   "id": "34033ea0-c1e4-812d-9565-00b219008b06",
#>   "created_time": "2026-04-12T08:11:00.000Z",
#>   "created_by": {
#>     "id": "6b786605-e456-4237-9c61-5efaff23c081",
#>     "type": "bot"
#>   },
#>   "last_edited_time": "2026-04-12T08:11:00.000Z",
#>   "expiry_time": "2026-04-12T09:11:00.000Z",
#>   "in_trash": false,
#>   "status": "uploaded",
#>   "filename": "test-large.txt",
#>   "content_type": "text/plain; charset=utf-8",
#>   "content_length": 11534336,
#>   "number_of_parts": {
#>     "total": 2,
#>     "sent": 2
#>   },
#>   "request_id": "b1bea9d5-20bb-4117-b06c-ae650a6e0b1a"
#> } 

# Retrieve the file upload
notion$file_uploads$retrieve(
  file_upload_id
)
#> {
#>   "object": "file_upload",
#>   "id": "34033ea0-c1e4-812d-9565-00b219008b06",
#>   "created_time": "2026-04-12T08:11:00.000Z",
#>   "created_by": {
#>     "id": "6b786605-e456-4237-9c61-5efaff23c081",
#>     "type": "bot"
#>   },
#>   "last_edited_time": "2026-04-12T08:11:00.000Z",
#>   "expiry_time": "2026-04-12T09:11:00.000Z",
#>   "in_trash": false,
#>   "status": "uploaded",
#>   "filename": "test-large.txt",
#>   "content_type": "text/plain; charset=utf-8",
#>   "content_length": 11534336,
#>   "number_of_parts": {
#>     "total": 2,
#>     "sent": 2
#>   },
#>   "request_id": "9e291c04-a262-4ed9-9fa9-f1dcb5d56f8b"
#> } 
# ----- Import external files
notion$file_uploads$create(
  "external_url",
  "dummy.pdf",
  content_type = "application/pdf",
  external_url = "https://github.com/brenwin1/notionapi/blob/main/tests/testthat/test.pdf"
)
#> {
#>   "object": "file_upload",
#>   "id": "34033ea0-c1e4-81cf-a859-00b21dd260e6",
#>   "created_time": "2026-04-12T08:11:00.000Z",
#>   "created_by": {
#>     "id": "6b786605-e456-4237-9c61-5efaff23c081",
#>     "type": "bot"
#>   },
#>   "last_edited_time": "2026-04-12T08:11:00.000Z",
#>   "expiry_time": "2026-04-12T09:11:00.000Z",
#>   "upload_url": "https://api.notion.com/v1/file_uploads/34033ea0-c1e4-81cf-a859-00b21dd260e6/send",
#>   "in_trash": false,
#>   "status": "pending",
#>   "filename": "dummy.pdf",
#>   "content_type": "application/pdf",
#>   "content_length": {},
#>   "request_id": "db0b6358-7cdf-4e5a-9f3b-e716f02cc8c0"
#> } 
```
