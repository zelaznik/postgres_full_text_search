WITH

original_table(id, title, body) AS (VALUES
  (1, 'postgres full-text-search', 'is better than elastic'),
  (2, 'elastic full-text-search', 'is better than postgres'),
  (3, 'apache lucene full-text-search', 'is something I haven''t used directly')
),

indexed_table AS (
  SELECT
    id,
    title,
    body,
    (
      setweight(to_tsvector('english', original_table.title), 'A')
      ||
      setweight(to_tsvector('english', original_table.body), 'B')
    ) as weighted_search_vector

  FROM
    original_table
)

SELECT
  *,
  ts_rank(weighted_search_vector, query) AS rank
FROM indexed_table, to_tsquery('english', 'postgres') AS query
WHERE weighted_search_vector @@ query
ORDER BY rank DESC;
