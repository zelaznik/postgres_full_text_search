class AddTrigramExtension < ActiveRecord::Migration[8.0]
  def up
    execute <<~SQL
      CREATE EXTENSION IF NOT EXISTS pg_trgm;
    SQL
  end

  def down
    execute <<~SQL
      DROP EXTENSION IF EXISTS pg_trgm;
    SQL
  end
end
