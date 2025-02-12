WITH words AS (
  SELECT
    'hello' as left,
    'hi' as right
),

words_with_trigrams AS (
  SELECT
    words.left left_word,
    words.right right_word,
    show_trgm(words.left) left_trigrams,
    show_trgm(words.right) right_trigrams

FROM
    words
),

words_with_trigram_counts AS (
  SELECT
    *,
    (SELECT COUNT(*) FROM unnest(left_trigrams)) as left_trigram_count,
    (SELECT COUNT(*) FROM unnest(right_trigrams)) as right_trigram_count,
    (
      SELECT COUNT(*)
      FROM (
        SELECT unnest(left_trigrams)
        INTERSECT
        SELECT unnest(right_trigrams)
      ) as q
    ) as joint_trigram_count

  FROM
    words_with_trigrams
)

SELECT
  *,
  round(1.0 * joint_trigram_count / left_trigram_count, 3) AS similarity_left_to_right,
  round(1.0 * joint_trigram_count / right_trigram_count, 3) AS similarity_right_to_left

FROM
  words_with_trigram_counts
