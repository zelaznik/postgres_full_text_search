class AddFuzzystrmatchExtension < ActiveRecord::Migration[8.0]
  def up
    execute <<~SQL
      CREATE EXTENSION fuzzystrmatch;
    SQL
  end

  def down
    execute <<~SQL
      DROP EXTENSION fuzzystrmatch;
    SQL
  end
end
