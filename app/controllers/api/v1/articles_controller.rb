class Api::V1::ArticlesController < ApplicationController
  def index
    articles = Article.order(updated_at: :desc)
    render json: articles, each_serializer: Api::V1::ArticlePreviewSerializer
  end

  def show
    article = Article.find(params[:id])
    render json: article, each_serializer: Api::V1::ArticlePreviewSerializer
  end
end