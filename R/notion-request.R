#' Get Notion API token from environment
#' @noRd
#' @keywords internal
.notion_token <- function(auth = NULL) {
  token <- auth %||% Sys.getenv("NOTION_TOKEN")

  if (!nzchar(token)) {
    if (is_testing() && is.null(auth)) {
      testthat::skip("Notion token not set")
    }
    notionapi_error(
      c(
        "Notion integration token not found.",
        i = "Set it with `NOTION_TOKEN` environment variable (recommended)",
        i = "or pass it directly with `auth` argument"
      ),
      call = NULL,
      class = "notionapi_auth_error"
    )
  }

  token
}

notion_build_request <- function(
  req,
  path,
  method = "GET",
  query_params = NULL,
  body_params = NULL
) {
  req <- httr2::req_url_path_append(req, path)

  req <- httr2::req_method(req, method)

  if (!is.null(query_params)) {
    req <- httr2::req_url_query(req, !!!query_params, .multi = "explode")
  }

  if (!is.null(body_params)) {
    req <- httr2::req_body_json(req, body_params)
  }

  return(req)
}

parse_repeated_query_params <- function(values, nm) {
  if (!is.null(values)) {
    set_names(
      values,
      rep_len(nm, length(values))
    )
  }
}

parse_query_params <- function(...) {
  parse_body_params(...)
}

parse_body_params <- function(...) {
  x <- list2(...)

  if (!has_names(x)) {
    notionapi_error("All body parameters must be named.")
  }

  drop_named_nulls(x)
}

#' Perform Notion API request
#'
#' throws an error with failed status code
#' @noRd
#' @keywords internal
notion_perform_req <- function(req) {
  UseMethod("notion_perform_req")
}

#' @noRd
#' @keywords internal
notion_perform_req.notion_req <- function(req) {
  resp <- httr2::req_perform(req)

  if (httr2::resp_status(resp) >= 400) {
    notion_handle_api_error(
      resp,
      error_call = caller_env()
    )
  }

  resp
}

#' @noRd
#' @keywords internal
notion_perform_req.notion_async_req <- function(req) {
  resp <- httr2::req_perform_promise(req)

  resp <- promises::then(resp, function(resp) {
    if (httr2::resp_status(resp) >= 400) {
      notion_handle_api_error(
        resp,
        caller_env()
      )
    }
    resp
  })

  resp
}

notion_handle_resp <- function(resp) {
  UseMethod("notion_handle_resp")
}

#' Process Notion API response
#'
#' @noRd
#' @keywords internal
notion_handle_resp.httr2_response <- function(resp) {
  res <- httr2::resp_body_json(resp)
  class(res) <- c("notion_response", class(res))

  res
}


#' Process Notion API response
#'
#' @noRd
#' @keywords internal
notion_handle_resp.promise <- function(resp) {
  res <- promises::then(resp, function(resp) {
    resp <- httr2::resp_body_json(resp)
    class(resp) <- c("notion_response", class(resp))

    resp
  })

  res
}

#' Handle Notion API errors
#'
#' @seealso [https://developers.notion.com/reference/status-codes]
#' @noRd
#' @keywords internal
notion_handle_api_error <- function(resp, error_call = rlang::caller_env()) {
  headers <- httr2::resp_headers(resp)
  bod <- httr2::resp_body_json(resp)
  status <- httr2::resp_status(resp)

  message <- bod$message
  heading <- "Notion API error ({status}): {.field {bod$code}}"

  msg <- strsplit(message, "\n")[[1]]
  msg <- gsub("\\{", "{{", msg)
  msg <- gsub("\\}", "}}", msg)
  msg <- set_names(
    msg,
    rep_len("i", length(msg))
  )
  msg <- c(heading, msg)

  notionapi_error(
    msg,
    class = "notionapi_api_error",
    call = error_call,
    response_headers = headers,
    response_content = bod
  )
}

#' Create base Notion API request
#' @param auth Authentication token (optional)
#' @param base_url Base URL for Notion API
#' @param version Notion API version
#' @returns httr2 request object
#' @noRd
#' @keywords internal
notion_request <- function(
  auth = NULL,
  base_url = "https://api.notion.com/v1/",
  version = getOption("notionapi.version"),
  timeout = NULL,
  class = NULL
) {
  token <- auth %||% .notion_token()

  req <- httr2::request(base_url)
  req <- httr2::req_auth_bearer_token(req, token)
  req <- httr2::req_headers(req, "Notion-Version" = version)
  # handle error separately
  req <- httr2::req_error(req, function(resp) {
    FALSE
  })

  if (!is.null(timeout)) {
    req <- httr2::req_timeout(req, timeout)
  }

  class(req) <- c(class, class(req))

  req
}
