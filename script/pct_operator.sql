SELECT
  a,
  b,
  a % b AS a_pct_b,
  b % a AS b_pct_a,
  word_similarity(a, b) AS a_sim_b,
  word_similarity(b, a) AS b_sim_a,
  show_limit()

FROM (VALUES
  ('abcdefghijk', 'abcdefghijk'),
  ('abcdefghijk', 'abcdefghij'),
  ('abcdefghijk', 'abcdefghi'),
  ('abcdefghijk', 'abcdefgh'),
  ('abcdefghijk', 'abcdefg'),
  ('abcdefghijk', 'abcdef'),
  ('abcdefghijk', 'abcde'),
  ('abcdefghijk', 'abcd'),
  ('abcdefghijk', 'abc'),
  ('abcdefghijk', 'ab'),
  ('abcdefghijk', 'a'),
  ('abcdefghijk', '')
) AS words(a, b);
