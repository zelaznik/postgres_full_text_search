WITH

original_table(id, body) AS (VALUES
  (1, 'postgres full-text-search is better than elastic.'),
  (2, 'postgres full-text-search is better than elastic.  postgres postgres postgres'),
  (3, 'apache lucene full-text-search is something I haven''t used directly')
),

indexed_table AS (
  SELECT
    id,
    body,
    to_tsvector('english', original_table.body) as search_vector
  FROM
    original_table
)

SELECT
  *,
  ts_rank(search_vector, query) AS rank
FROM indexed_table, to_tsquery('english', 'postgres') AS query
WHERE search_vector @@ query
ORDER BY rank DESC;
