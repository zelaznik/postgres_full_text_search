class CreateArticlesTable < ActiveRecord::Migration[8.0]
  def up
    execute <<~SQL
      CREATE TABLE articles (
        id SERIAL PRIMARY KEY,
        data JSON NOT NULL
      )
    SQL
  end

  def down
    execute <<~SQL
      DROP TABLE articles;
    SQL
  end
end
