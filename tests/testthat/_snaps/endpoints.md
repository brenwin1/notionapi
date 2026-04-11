# API error messages are formatted properly

    Code
      notion$blocks$retrieve(block_id = "12345ea0c1e4808c95d2c6b376c4fe2f")
    Condition
      Error in `notion$blocks$retrieve()`:
      ! Notion API error (404): object_not_found
      i Could not find block with ID: 12345ea0-c1e4-808c-95d2-c6b376c4fe2f. Make sure the relevant pages and databases are shared with your integration "brenwin-internal".

# API error multiline messages are formatted properly

    Code
      notion$comments$create(list(list(tetx = list(content = "hello world"))), list(
        page_id = test_ids[["page_id"]]))
    Condition
      Error in `notion$comments$create()`:
      ! Notion API error (400): validation_error
      i body failed validation. Fix one:
      i body.rich_text[0].text should be defined, instead was `undefined`.
      i body.rich_text[0].mention should be defined, instead was `undefined`.
      i body.rich_text[0].equation should be defined, instead was `undefined`.

