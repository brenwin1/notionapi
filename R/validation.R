# Validate arguments --------------------------------------------------

# --- check required argument is present

is_present <- function(x) {
  (!is_missing(x) && !is.null(x))
}

check_required <- function(
  x,
  arg = caller_arg(x),
  call = caller_env()
) {
  if (!is_present(x)) {
    notionapi_error(
      "Required argument `{arg}` is missing",
      "notionapi_validation_error",
      call
    )
  }
}

is_string <- function(x, multiple = FALSE) {
  valid <- if (!multiple) {
    rlang::is_string(x)
  } else {
    rlang::is_character(x)
  }

  valid && all(x != "")
}

check_string <- function(
  x,
  required = FALSE,
  multiple = FALSE,
  arg = caller_arg(x),
  call = caller_env()
) {
  if (
    is_present(x) &&
      !is_string(x, multiple)
  ) {
    what <- if (multiple) {
      "a character vector with non-empty strings"
    } else {
      "a non-empty character vector"
    }

    notionapi_error(
      "`{arg}` must be {what}",
      class = "notionapi_validation_error",
      call = call
    )
  }

  if (required) {
    check_required(x, arg, call)
  }
}

is_bool <- function(x) {
  rlang::is_bool(x)
}

check_bool <- function(
  x,
  required = FALSE,
  arg = caller_arg(x),
  call = caller_env()
) {
  if (is_present(x) && !is_bool(x)) {
    notionapi_error(
      "`{arg}` must be a boolean.",
      class = "notionapi_validation_error",
      call = call
    )
  }

  if (required) {
    check_required(x, arg, call)
  }
}

is_int <- function(x) {
  is_integerish(x, 1, TRUE)
}

check_int <- function(
  x,
  max = NULL,
  required = FALSE,
  arg = rlang::caller_arg(arg = x),
  call = rlang::caller_env()
) {
  if (is_present(x) && !is_int(x)) {
    notionapi_error(
      message = "`{arg}` must be a single integer.",
      class = "notionapi_validation_error",
      call = call
    )
  }

  if (is_present(x) && !is.null(max) && x > max) {
    notionapi_error(
      "`{arg}` must be less than or equal to {max}.",
      class = "notionapi_validation_error",
      call = call
    )
  }

  if (required) {
    check_required(x, arg, call)
  }
}

is_json_array <- function(x) {
  (is.list(x) &&
    length(x) > 0 &&
    is.null(names(x)) &&
    all(
      vapply(
        x,
        function(property) {
          (is.list(property) && !is.null(names(property)))
        },
        logical(1)
      )
    ))
}

check_json_array <- function(
  x,
  required = FALSE,
  arg = caller_arg(x),
  call = caller_env()
) {
  if (is_present(x) && !is_json_array(x)) {
    notionapi_error(
      "`{arg}` must be list of lists (JSON array of object(s)).",
      class = "notionapi_validation_error",
      call = call
    )
  }

  if (required) {
    check_required(x, arg, call)
  }
}


is_json_object <- function(x) {
  (is.list(x) && !is.null(names(x)))
}

check_json_object <- function(
  x,
  required = FALSE,
  arg = caller_arg(arg = x),
  call = caller_env()
) {
  if (is_present(x) && !is_json_object(x)) {
    notionapi_error(
      "`{arg}` must be a named list (JSON object).",
      class = "notionapi_validation_error",
      call = call
    )
  }

  if (required) {
    check_required(x, arg, call)
  }
}
