class ArticlesController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  before_action :article_view_page_views

  def index
    articles = Article.all.includes(:user).order(created_at: :desc)
    render json: articles, each_serializer: ArticleListSerializer
  end

  def show
    session[:page_views] = session[:page_views].to_i + 1
    if session[:page_views].to_i < 4
      article = Article.find(params[:id])
      render json: article
    else
      render json: {error: "Maximum pageview limit reached"}, status: :unauthorized
    end
  end

  private

  def record_not_found
    render json: { error: "Article not found" }, status: :not_found
  end

  def article_view_page_views
    session[:page_views] ||= 0
  end

end
