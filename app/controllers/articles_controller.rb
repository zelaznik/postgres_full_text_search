require 'pry'

class ArticlesController < ApplicationController
  helper_method :articles,
    :search_params,
    :suggestions,
    :suggestions_are_different?,
    :truncate_middle

  def index
  end

  def articles
    @_articles ||= begin
      ArticlesHelper
        .search(
          search_params[:search],
          advanced: search_params[:advanced]
        )
    end
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
