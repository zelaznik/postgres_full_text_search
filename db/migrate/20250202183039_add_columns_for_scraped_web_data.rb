class AddColumnsForScrapedWebData < ActiveRecord::Migration[8.0]
  def up
    execute <<~SQL
      ALTER TABLE articles ADD COLUMN http_status INTEGER;
      ALTER TABLE articles ADD COLUMN body TEXT;
      ALTER TABLE articles ADD COLUMN error TEXT;
    SQL
  end

  def down
    execute <<~SQL
      ALTER TABLE articles DROP COLUMN http_status;
      ALTER TABLE articles DROP COLUMN body;
      ALTER TABLE articles DROP COLUMN error;
    SQL
  end
end
