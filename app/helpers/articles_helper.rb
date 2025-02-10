module ArticlesHelper
  def self.suggestions_sql(search_term)
    sql = ActiveRecord::Base.sanitize_sql_array([<<~SQL, { search_term: }])
      WITH parsed_query AS (
        SELECT
          row_number() OVER() as token_id,
          *
        FROM
          ts_debug(:search_term)
      ),

      nearby_words AS (
        SELECT
          *,
          levenshtein(
            LOWER(TRIM(search_terms.term)),
            LOWER(TRIM(parsed_query.token))
          ) as distance

        FROM
          parsed_query,
          search_terms

        WHERE search_terms.term % parsed_query.token
        AND parsed_query.alias = 'asciiword'
      ),

      ranked_words AS (
        SELECT
          *,
          (distance + 1) / LOG(frequency + 2) as factor
        FROM nearby_words
      ),

      suggestions AS (
        SELECT DISTINCT ON (token_id) *
        FROM ranked_words
        ORDER BY token_id, factor
      )

      SELECT
        parsed_query.token_id,
        parsed_query.alias,
        parsed_query.token,
        suggestions.term,
        (
          parsed_query.alias = 'asciiword'
          AND
          suggestions.distance > 0
        ) is_replacement

      FROM parsed_query
      LEFT JOIN suggestions ON parsed_query.token_id = suggestions.token_id

      ORDER BY parsed_query.token_id;

    SQL
  end

  def self.suggestions(search_term)
    raw_sql = suggestions_sql(search_term)
    ActiveRecord::Base.connection.execute(raw_sql)
  end

  def self.formatted_suggestions(search_term, start_tag: "<b>", end_tag: "</b>")
    results = suggestions(search_term)

    results.map do |r|
      if r['is_replacement']
        "#{start_tag}#{CGI.escapeHTML(r['term'])}#{end_tag}"
      else
        CGI.escapeHTML(r['token'])
      end
    end.join
  end

  def self.search_sql(search_term, advanced: false, page: 1, results_per_page: 25)
    params = {
      search_term: search_term,
      page: page,
      results_per_page: results_per_page
    }

    querier = advanced ? 'to_tsquery' : 'websearch_to_tsquery'

    sql = ActiveRecord::Base.sanitize_sql_array([<<~SQL, params])
      WITH q AS (
        SELECT
          *,
          to_tsvector('english', title) as vector,
          #{querier}('english', :search_term) as query
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
        ) highlighted_title,
        ts_rank(vector, query) AS rank

      FROM
        q

      WHERE
        vector @@ query
      ORDER BY
        rank DESC
      LIMIT
        :results_per_page

      OFFSET
        ((:page - 1) * :results_per_page)
    SQL
  end

  def self.search(search_term, advanced: false, page: 1, results_per_page: 25)
    raw_sql = search_sql(search_term, page:, results_per_page:, advanced:)
    ActiveRecord::Base.connection.execute(raw_sql)
  end
end
