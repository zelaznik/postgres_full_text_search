INSERT INTO search_terms (term, frequency)
WITH q AS (
  SELECT unnest(
    regexp_split_to_array(
    lower(
      trim(
        unaccent(title)
      )
    ),
    '\s+'
  )
  ) as search_term
  FROM articles
), r AS (
  SELECT *
  FROM q
  WHERE regexp_replace(unaccent(search_term), '[A-Z|a-z]+', '', 'gi') = ''
  AND search_term != ''
)

SELECT search_term, COUNT(*) as term_count
FROM r
GROUP BY search_term
ORDER BY COUNT(*) DESC;


-- Remove stop words:
DELETE FROM search_terms WHERE id IN (
  SELECT id
  FROM search_terms
  WHERE to_tsvector('english', term)::text = ''
);
