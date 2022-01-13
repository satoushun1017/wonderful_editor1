require "rails_helper"

RSpec.describe "Api::V1::Auth::Registrations", type: :request do
  describe "POST /auth" do
    subject { post(api_v1_user_registration_path, params: params) }

    context "必要な情報があるとき" do
      let(:params) { attributes_for(:user) }
      it "ユーザーを登録できる" do
        expect { subject }.to change { User.count }.by(1)
        expect(response).to have_http_status(:ok)
        res = JSON.parse(response.body)
        expect(res["data"]["email"]).to eq(User.last.email)
      end

      it "heder情報を取得できる" do
        subject
        # binding.pry
        header = response.header
        expect(header["access-token"]).to be_present
        expect(header["client"]).to be_present
        expect(header["expiry"]).to be_present
        expect(header["uid"]).to be_present
        expect(header["token-type"]).to be_present
      end
    end

    context "nameがないとき" do
      let(:params) { attributes_for(:user, name: nil) }
      it "エラーする" do
        expect { subject }.to change { User.count }.by(0)
        # binding.pry
        expect(response).to have_http_status(:unprocessable_entity)
        # expect(res["errors"]["name"]).to include "can't be blank"
      end
    end

    context "emailがないとき" do
      let(:params) { attributes_for(:user, email: nil) }
      it "エラーする" do
        expect { subject }.to change { User.count }.by(0)
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    context "passwordがないとき" do
      let(:params) { attributes_for(:user, password: nil) }
      it "エラーする" do
        expect { subject }.to change { User.count }.by(0)
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end
end
