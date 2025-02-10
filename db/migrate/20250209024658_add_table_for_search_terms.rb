class AddTableForSearchTerms < ActiveRecord::Migration[8.0]
  def up
    execute <<~SQL
      CREATE TABLE search_terms (
        id SERIAL PRIMARY KEY,
        term TEXT NOT NULL,
        frequency INTEGER NOT NULL
      );

      CREATE UNIQUE INDEX idx_uniq_search_terms ON search_terms
      USING BTREE (LOWER(term));

      CREATE INDEX idx_search_terms ON search_terms
      USING GIST (term gist_trgm_ops);
    SQL
  end

  def down
    execute <<~SQL
      DROP INDEX idx_search_terms;
      DROP INDEX idx_uniq_search_terms;
      DROP TABLE search_terms;
    SQL
  end
end
