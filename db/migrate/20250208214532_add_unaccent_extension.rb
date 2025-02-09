class AddUnaccentExtension < ActiveRecord::Migration[8.0]
  def up
    execute <<~SQL
      CREATE EXTENSION unaccent;
    SQL
  end

  def down
    execute <<~SQL
      DROP EXTENSION unaccent;
    SQL
  end
end
