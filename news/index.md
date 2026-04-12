# Changelog

## notionapi (development version)

### Breaking changes

- Notion API version updated to `2025-09-03` (previously `2022-06-28`).

### New features

- `BlocksChildrenEndpoint$append()` gains `position` parameter to
  control block insertion placement.

- `BlocksEndpoint` methods gain `in_trash` argument.

### Deprecations

- `BlocksChildrenEndpoint$append()`: `after` parameter deprecated by
  Notion API in favor of `position`.

- `BlocksEndpoint`: `archived` parameter deprecated in favor of
  `in_trash`.

## notionapi 0.1.0

CRAN release: 2025-09-02

- Initial CRAN submission.
