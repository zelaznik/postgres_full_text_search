class Article < ApplicationRecord
  scope :search, -> (query) {
    sanitized = Arel.sql(ActiveRecord::Base.sanitize_sql_array(['?', query]))

    self
      .where(Arel.sql(<<~SQL.strip.squish))
        to_tsvector('english', articles.title)
        @@
        to_tsquery('english', #{sanitized})
      SQL
      .order(Arel.sql(<<~SQL.strip.squish))
        ts_rank(
          to_tsvector('english', articles.title),
          to_tsquery('english', #{sanitized})
        ) DESC
      SQL
  }
end
