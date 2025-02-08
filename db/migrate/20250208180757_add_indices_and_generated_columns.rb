class AddIndicesAndGeneratedColumns < ActiveRecord::Migration[8.0]
  def up
    execute <<~SQL
      ALTER TABLE articles
      ADD COLUMN title text
      GENERATED ALWAYS AS ((data ->> 'title'::text)) STORED;

      ALTER TABLE articles
      ADD COLUMN url text
      GENERATED ALWAYS AS ((data ->> 'url'::text)) STORED;

      CREATE INDEX idx_fts_articles_title ON articles USING GIN (to_tsvector('english', title));

      CREATE INDEX idx_trigram_articles_title ON articles USING GIST (title gist_trgm_ops);
    SQL
  end

  def down
    execute <<~SQL
      DROP INDEX idx_trigram_articles_title;
      DROP INDEX idx_fts_articles_title;
      ALTER TABLE articles DROP COLUMN title;
      ALTER TABLE articles DROP COLUMN url;
    SQL
  end
end
