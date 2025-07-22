# API error messages are formatted properly

    Code
      notion$blocks$retrieve(block_id = "12345ea0c1e4808c95d2c6b376c4fe2f")
    Condition
      Error in `notion$blocks$retrieve()`:
      ! Notion API error (404): object_not_found
      i Could not find block with ID: 12345ea0-c1e4-808c-95d2-c6b376c4fe2f. Make sure the relevant pages and databases are shared with your integration.

# API error multiline messages are formatted properly

    Code
      notion$databases$query("22833ea0c1e481178e9cf1dcba79dbca", filter = list(orr = list(
        list(property = "In stock", checkbox = list(equals = TRUE)))))
    Condition
      Error in `notion$databases$query()`:
      ! Notion API error (400): validation_error
      i body failed validation. Fix one:
      i body.filter.or should be defined, instead was `undefined`.
      i body.filter.and should be defined, instead was `undefined`.
      i body.filter.title should be defined, instead was `undefined`.
      i body.filter.rich_text should be defined, instead was `undefined`.
      i body.filter.number should be defined, instead was `undefined`.
      i body.filter.checkbox should be defined, instead was `undefined`.
      i body.filter.select should be defined, instead was `undefined`.
      i body.filter.multi_select should be defined, instead was `undefined`.
      i body.filter.status should be defined, instead was `undefined`.
      i body.filter.date should be defined, instead was `undefined`.
      i body.filter.people should be defined, instead was `undefined`.
      i body.filter.files should be defined, instead was `undefined`.
      i body.filter.url should be defined, instead was `undefined`.
      i body.filter.email should be defined, instead was `undefined`.
      i body.filter.phone_number should be defined, instead was `undefined`.
      i body.filter.relation should be defined, instead was `undefined`.
      i body.filter.created_by should be defined, instead was `undefined`.
      i body.filter.created_time should be defined, instead was `undefined`.
      i body.filter.last_edited_by should be defined, instead was `undefined`.
      i body.filter.last_edited_time should be defined, instead was `undefined`.
      i body.filter.formula should be defined, instead was `undefined`.
      i body.filter.unique_id should be defined, instead was `undefined`.
      i body.filter.rollup should be defined, instead was `undefined`.

