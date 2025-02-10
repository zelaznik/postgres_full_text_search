WITH

parsed_query AS (
  SELECT
    row_number() OVER() as token_id,
    *
  FROM
    ts_debug('jython <-> vs <-> javascript')
),

nearby_words AS (
  SELECT
    *,
    levenshtein(
      LOWER(TRIM(search_terms.term)),
      LOWER(TRIM(parsed_query.token))
    ) as distance

  FROM
    parsed_query,
    search_terms

  WHERE search_terms.term % parsed_query.token
  AND parsed_query.alias = 'asciiword'
),

ranked_words AS (
  SELECT
    *,
    (distance + 1) / LOG(frequency + 2) as factor
  FROM nearby_words
),

suggestions AS (
  SELECT DISTINCT ON (token_id) *
  FROM ranked_words
  ORDER BY token_id, factor
)

SELECT
  parsed_query.token_id,
  parsed_query.alias,
  parsed_query.token,
  suggestions.term,
  (
    parsed_query.alias = 'asciiword'
    AND
    LOWER(TRIM(parsed_query.token)) != LOWER(TRIM(suggestions.term)
  ) is_replacement

FROM parsed_query
LEFT JOIN suggestions ON parsed_query.token_id = suggestions.token_id

ORDER BY parsed_query.token_id;
