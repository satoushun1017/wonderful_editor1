module Api::V1
  class Current::ArticlesController < BaseApiController
    before_action :authenticate_user!
    def index
      articles = Article.order(updated_at: :desc)
      render json: articles, each_serializer: Api::V1::ArticlePreviewSerializer
    end
  end
end
