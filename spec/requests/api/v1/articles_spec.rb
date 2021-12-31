require "rails_helper"

RSpec.describe "Api::V1::Articles", type: :request do
  describe "GET /articles" do
    subject { get(api_v1_articles_path) }
    # before { create_list(:article, 3) }

    # let!(:article1) { create(:article, updated_at: 1.days.ago) }
    # let!(:article2) { create(:article, updated_at: 2.days.ago) }
    # let!(:article3) { create(:article) }
    before do
      create(:article, updated_at: 1.days.ago)
      create(:article, updated_at: 2.days.ago)
      create(:article)
    end

    it "記事の一覧が取得できる" do
      subject
      res = JSON.parse(response.body)
      expect(response).to have_http_status(:ok)
      expect(res.length).to eq 3
      expect(res[0].keys).to eq ["id", "title", "updated_at", "user"]
      expect(res[0]["user"].keys).to eq ["id", "name", "email"]
    end
  end

  describe "GET /articles/:id" do
    subject { get(api_v1_article_path(article_id)) }

    context "指定したidの記事が存在するとき" do
      let(:article_id) { article.id }
      let(:article) { create(:article) }
      it "任意の記事を取得できる" do
        subject
        res = JSON.parse(response.body)
        expect(res.length).to eq 5
        expect(res["title"]).to eq article.title
        expect(res["body"]).to eq article.body
        expect(res["updated_at"]).to be_present
        expect(res["user"]["id"]).to eq article.user.id
        expect(res["user"].keys).to eq ["id", "name", "email"]

        # binding.pry
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
end
