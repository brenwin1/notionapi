# Changelog

## notionapi 0.2.0

**Updated to support Notion API version 2026-03-11** (previously
2022-06-28). All changes below reflect updates made to comply with the
latest Notion API.

### Breaking changes

- `DatabasesEndpoint$create()` no longer accepts `properties` parameter
  per API changes. Use `DataSourcesEndpoint` to create databases with
  properties.

- `DatabasesEndpoint$query()` removed following API deprecation. Use
  `DataSourcesEndpoint$query()` instead.

- `PagesPropertiesEndpoint$update()` removed as the endpoint was
  deprecated in the Notion API.

### New endpoints (per API additions)

- `DataSourcesEndpoint`: Manage data sources (table views of databases)
  with `$create()`, `$retrieve()`, `$update()`, `$query()`, and
  `$list_templates()`. Supports full property configuration.

- `FileUploadsEndpoint`: Upload files to Notion with `$create()`,
  `$send()`, `$complete()`, `$retrieve()`, and `$list()`. Supports
  single-part (≤20MB), multi-part (\>20MB), and external URL imports.

- `ViewsEndpoint`: Manage database views with `$create()`,
  `$retrieve()`, `$update()`, `$delete()`, and `$list()`.

- `ViewsQueriesEndpoint`: Execute view queries with `$create()`,
  `$results()`, and `$delete()`.

- `CustomEmojisEndpoint`: Access workspace custom emojis via `$list()`.

### Enhanced endpoints (per API updates)

#### Pages

- `$create()` gains `content`, `markdown`, `template`, and `position`
  parameters.

- `$update()` gains `is_locked`, `template`, and `erase_content`
  parameters.

- `$retrieve_markdown()`: New method to retrieve page content as
  Notion-flavored Markdown.

- `$update_markdown()`: New method to update page content using Markdown
  with `update_content`, `replace_content`, `insert_content`, and
  `replace_content_range` operations.

- `$move()`: New method to move pages between parents.

#### Blocks

- `BlocksChildrenEndpoint$append()` gains `position` parameter (replaces
  deprecated `after`).

#### General

- All applicable endpoints now use `in_trash` argument for trash
  operations (replaces deprecated `archived` and `is_archived`
  parameters).

### Deprecations (per API changes)

- `BlocksChildrenEndpoint$append()`: `after` parameter deprecated in
  favor of `position`.

- `archived` and `is_archived` parameters deprecated across all
  endpoints in favor of `in_trash`.

## notionapi 0.1.0

CRAN release: 2025-09-02

- Initial CRAN submission.
