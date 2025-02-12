SELECT 
  to_tsvector(
  	'simple',
    t.first_name
    || ' ' ||
    t.middle_name
    || ' ' ||
    t.last_name
  )

FROM (VALUES
  ('Steven', 'Kisselburgh', 'Zelaznik')
) as t(first_name, middle_name, last_name);
