class ArticlesController < ApplicationController
  helper_method :articles

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
end
