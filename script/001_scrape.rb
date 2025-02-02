require 'json'
src_path = "tmp/HNStoriesAll.json"
data = JSON.load_file(src_path)

data.drop(1).each do |row|
  values = row['hits'].map do |hit|
    ActiveRecord::Base.sanitize_sql_array(
      [
        "(?)",
        JSON.generate(hit)
      ]
    )
  end

  statement = <<~SQL
    INSERT INTO articles (data) VALUES
    #{values.join(",\n")};
  SQL

  ActiveRecord::Base.connection.execute(statement)
end
