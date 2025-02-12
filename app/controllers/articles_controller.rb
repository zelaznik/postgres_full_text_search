require 'pry'

class ArticlesController < ApplicationController
  helper_method :articles,
    :articles_error_message,
    :search_params,
    :suggestions,
    :suggestions_are_different?,
    :truncate_middle

  def index
  end

  def article_query
    @_article_query ||= begin
      results = ArticlesHelper
        .search(
          search_params[:search],
          advanced: search_params[:advanced]
        )

      { success: true, results: results }
    rescue StandardError => e
      { error: true, error_message: e.message, results: [] }
    end
  end

  def articles_error_message
    article_query[:error_message]
  end

  def articles
    article_query[:results]
  end

  def suggestions_are_different?
    search_params[:search].present? && \
    CGI.escapeHTML(search_params[:search]) != suggestions
  end

  def suggestions
    @_suggestions ||= begin
      ArticlesHelper
        .formatted_suggestions(search_params[:search])
    end
  end

  def truncate_middle(text, max_length: 60)
    ellipsis_length = 3
    if text.length < max_length - ellipsis_length
      text
    else
      "#{text[...(max_length/2)]}...#{text[-(max_length/2)...]}"
    end
  end

  def search_params
    params
      .permit(:search, :advanced)
  end
end
