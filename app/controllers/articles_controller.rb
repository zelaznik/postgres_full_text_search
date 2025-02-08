class ArticlesController < ApplicationController
  helper_method :articles, :truncate_middle

  def index
  end

  def articles(search_term, page: 1, page_size: 25)
    @_articles ||= Hash.new do |h,k|
      h[k] = Article
        .search(search_term)
        .limit(page_size)
        .offset((page-1) * page_size)
    end

    @_articles[search_term]
  end

  def truncate_middle(text, max_length: 60)
    if text.length < max_length
      text
    else
      "#{text[...(max_length/2)]}...#{text[-(max_length/2)...]}"
    end
  end
end
