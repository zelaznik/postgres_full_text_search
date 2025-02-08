module ArticlesHelper
  def self.search_sql(search_term, page: 1, results_per_page: 25)
    sanitized = ActiveRecord::Base.sanitize_sql(['?', search_term ])

    params = {
      search_term: search_term,
      page: page,
      results_per_page: results_per_page
    }

    sql = ActiveRecord::Base.sanitize_sql_array([<<~SQL, params])
      WITH q AS (
        SELECT
          *,
          to_tsvector('english', title) as vector,
          to_tsquery('english', :search_term) as query
        FROM
          articles
      )

      SELECT
        id,
        title,
        url,
        ts_headline(
          'english',
          escape_html(title), -- this is untrusted user input
          query,
          'MaxFragments=10, MaxWords=7, MinWords=3, StartSel=<em>, StopSel=</em>'
        ) highlighted_title

      FROM
        q

      WHERE
        vector @@ query
      ORDER BY
        ts_rank(vector, query) DESC
      LIMIT
        :results_per_page

      OFFSET
        ((:page - 1) * :results_per_page)
    SQL
  end

  def self.search(search_term, page: 1, results_per_page: 25)
    raw_sql = search_sql(search_term, page:, results_per_page:)
    ActiveRecord::Base.connection.execute(raw_sql)
  end
end
