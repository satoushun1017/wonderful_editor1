require "rails_helper"

RSpec.describe "Api::V1::Articles", type: :request do
  describe "GET /index" do
    subject { get(api_v1_articles_path) }

    let!(:article1) { create(:article, updated_at: 1.days.ago) }
    let!(:article2) { create(:article, updated_at: 2.days.ago) }
    let!(:article3) { create(:article, :published) }
    before { create(:article, :draft) }
    # create(:article, :published, updated_at: 1.days.ago)
    # create(:article, :published, updated_at: 2.days.ago)
    # create(:article, :published)

    it "記事の一覧が取得できる" do
      subject
      res = JSON.parse(response.body)
      expect(response).to have_http_status(:ok)
      expect(res.length).to eq 4
      expect(res[0].keys).to eq ["id", "title", "updated_at", "user"]
      expect(res[0]["user"].keys).to eq ["id", "name", "email"]
      # expect(res[0]["status"]).to eq "draft"
      # binding.pry
    end
  end

  describe "GET /articles/:id" do
    subject { get(api_v1_article_path(article_id)) }

    context "指定したidの記事が存在するとき" do
      let(:article_id) { article.id }
      context "対象の記事が公開中" do
        let(:article) { create(:article, :published) }
        it "任意の記事を取得できる" do
          # binding.pry
          subject
          res = JSON.parse(response.body)
          # binding.pry
          expect(res.length).to eq 6
          expect(res["title"]).to eq article.title
          expect(res["body"]).to eq article.body
          expect(res["updated_at"]).to be_present
          expect(res["user"]["id"]).to eq article.user.id
          expect(res["user"].keys).to eq ["id", "name", "email"]
          # expect(res["status"]).to eq "draft"
        end
      end

      context "対象が下書き" do
        let(:article) { create(:article, :draft) }
        it "記事が見つからない" do
          # binding.pry
          expect { subject }.to raise_error(ActiveRecord::RecordNotFound)
        end
      end
    end

    context "指定した記事が見つからないとき" do
      let(:article_id) { 99_999_999 }
      it "その記事が見つからない" do
        # binding.pry
        # subject
        expect { subject }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end

  describe "POST /articles" do
    subject { post(api_v1_articles_path, params: params, headers: headers) }

    # let(:params) { { article: attributes_for(:article) } }
    let(:current_user) { create(:user) }
    let(:headers) { current_user.create_new_auth_token }

    context "記事が公開中の時作成できる" do
      # before { allow_any_instance_of(Api::V1::BaseApiController).to receive(:current_user).and_return(current_user) }
      # let(:headers) { current_user.create_new_auth_token }
      let(:params) { { article: attributes_for(:article, :published) } }
      it "記事のレコードが作成できる" do
        expect { subject }.to change { Article.where(user_id: current_user.id).count }.by(1)
        res = JSON.parse(response.body)
        expect(res["title"]).to eq params[:article][:title]
        expect(res["body"]).to eq params[:article][:body]
        expect(response).to have_http_status(:ok)
      end
    end

    context "下書きの時" do
      let(:params) { { article: attributes_for(:article, :draft) } }
      it "作成できる" do
        expect { subject }.to change { Article.where(user_id: current_user.id).count }.by(1)
        # binding.pry
        res = JSON.parse(response.body)
        expect(res["status"]).to eq "draft"
        expect(response).to have_http_status(:ok)
      end
    end

    context "てきとうな下書きの時" do
      let(:params) { { article: attributes_for(:article, status: :foo) } }
      it "失敗" do
        # binding.pry
        expect { subject }.to raise_error(ArgumentError)
      end
    end
  end

  describe "PATCH /articles/:id" do
    subject { patch(api_v1_article_path(article.id), params: params, headers: headers) }

    let(:params) { { article: attributes_for(:article, :published) } }
    let(:current_user) { create(:user) }
    # before { allow_any_instance_of(Api::V1::BaseApiController).to receive(:current_user).and_return(current_user) }
    let(:headers) { current_user.create_new_auth_token }

    context "自分が所持する記事を更新" do
      let(:article) { create(:article, :draft, user: current_user) }

      it "レコードを更新できる" do
        # binding.pry
        expect { subject }.to change { article.reload.title }.from(article.title).to(params[:article][:title]) & change {
                                                                                                                   article.reload.body
                                                                                                                 }.from(article.body).to(params[:article][:body])
        # binding.pry
        expect(response).to have_http_status(:ok)
        # expect { subject }.to change { article.reload.body }.from(article.body).to(params[:article][:body])
        # expect { subject }.not_to change { Article.find(article_id).article.updated_at }　
      end
    end

    context "所持していない記事を更新するとき" do
      let(:other_user) { create(:user) }
      let(:article) { create(:article, user: other_user) }
      it "更新できない" do
        expect { subject }.to raise_error(ActiveRecord::RecordNotFound) and change { Article.count }.by(0)
        # binding.pry
      end
    end
  end

  describe "DELETE /articles/:id" do
    subject { delete(api_v1_article_path(article_id, headers)) }

    # let(:params) { { article: attributes_for(:article) } }
    let(:current_user) { create(:user) }
    let(:article_id) { article.id }
    # before { allow_any_instance_of(Api::V1::BaseApiController).to receive(:current_user).and_return(current_user) }
    let(:headers) { current_user.create_new_auth_token }

    context "自分が所持するレコードを削除するとき" do
      let!(:article) { create(:article, user: current_user) }

      it "削除できる" do
        # expect { subject }.to change { Article.where(user_id: current_user.id).count }.by(0)
        # binding.pry
        expect { subject }.to change { Article.count }.by(-1)
        expect(response).to have_http_status(:no_content)
        # binding.pry
      end
    end

    context "自分が所持しないレコードを削除するとき" do
      let(:other_user) { create(:user) }
      let(:article) { create(:article, user: other_user) }
      it "削除できない" do
        # binding.pry
        expect { subject }.to raise_error(ActiveRecord::RecordNotFound) and change { Article.count }.by(0)
      end
    end
  end
end
