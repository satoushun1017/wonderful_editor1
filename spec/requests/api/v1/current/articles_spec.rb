require "rails_helper"

RSpec.describe "Api::V1::Current::Articles", type: :request do
  describe "GET /api/v1/current/articles" do
    subject { get(api_v1_current_articles_path, headers: headers) }

    let(:current_user) { create(:user) }
    let(:headers) { current_user.create_new_auth_token }
    context "自分がかいた記事が公開している時" do
      let(:article1) { create(:article, :published, user: current_user, updated_at: 1.day.ago) }
      let(:article2) { create(:article, :published, user: current_user, updated_at: 2.day.ago) }
      let(:article3) { create(:article, :published, user: current_user) }
      before do
        create(:article, :draft, user: current_user)
        create(:article, :published)
      end

      it "一覧を取得できる" do
        subject
        # binding.pry
        res = JSON.parse(response.body)
        expect(res.length).to eq 2
        expect(res[0].keys).to eq ["id", "title", "updated_at", "user"]
        expect(res[0]["user"].keys).to eq ["id", "name", "email"]
        # expect(res[0]["user"]["id"]).to eq current_user.id
        # expect(res[0]["user"]["name"]).to eq current_user.name
        # expect(res[0]["user"]["email"]).to eq current_user.email
        expect(response).to have_http_status(:ok)
      end
    end
  end
end
