module ArticlesHelper
  def self.sql(search_term, page: 1, results_per_page: 25)
    sanitized = ActiveRecord::Base.sanitize_sql(['?', search_term ])

    sql = Arel.sql(<<~SQL)
      WITH q AS (
        SELECT
          *,
          to_tsvector('english', title) as vector,
          to_tsquery('english', #{sanitized}) as query
        FROM
          articles
      )

      SELECT
        id,
        title,
        url,
        vector,
        query

      FROM
        q

      WHERE
        vector @@ query
      ORDER BY
        ts_rank(vector, query) DESC
      LIMIT
        #{results_per_page}
      OFFSET
        #{(page - 1) * results_per_page}
    SQL
  end

  def self.search(search_term, page: 1, results_per_page: 25)
    raw_sql = sql(search_term, page:, results_per_page:)
    ActiveRecord::Base.connection.execute(raw_sql)
  end
end
