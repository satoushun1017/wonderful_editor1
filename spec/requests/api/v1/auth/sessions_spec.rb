require 'rails_helper'

RSpec.describe "Api::V1::Auth::Sessions", type: :request do
  describe "POST /api/v1/auth/sign_in" do
    subject { post(api_v1_user_session_path, params: params) }
    context "内容が正しいとき" do
      let(:params) { attributes_for(:user, email: user.email, password: user.password) }
      let(:user) { create(:user) }
      it "ログインできる" do
        subject
        # binding.pry
        expect(response.headers["uid"]).to be_present
        expect(response.headers["access-token"]).to be_present
        expect(response.headers["client"]).to be_present
        expect(response).to have_http_status(200)
      end
    end

    context "メールが違うとき" do
      let(:params) { attributes_for(:user, email: "sss@email.com", password: user.password) }
      let(:user) { create(:user) }
      it "失敗" do
        subject
        # binding.pry
        res = JSON.parse(response.body)
        expect(res["succes"]).to be_falsey
        expect(res["errors"]).to include("Invalid login credentials. Please try again.")
        expect(response.headers["uid"]).to be_blank
        expect(response.headers["access-token"]).to be_blank
        expect(response.headers["client"]).to be_blank
        # binding.pry
      end
    end

    context "パスワードが違うとき" do
      let(:params) { attributes_for(:user, email: user.email, password: "123456") }
      let(:user) { create(:user) }
      it "失敗" do
        subject
        res = JSON.parse(response.body)
        expect(res["succes"]).to be_falsey
        expect(res["errors"]).to include("Invalid login credentials. Please try again.")
        expect(response.headers["uid"]).to be_blank
        expect(response.headers["access-token"]).to be_blank
        expect(response.headers["client"]).to be_blank
        # binding.pry

      end
    end
  end

  describe "DELETE /api/v1/auth/sign_out" do
    subject { delete(destroy_api_v1_user_session_path, headers: headers) }
    context "ログアウト時" do
      # let(:params) { attributes_for(:user) }
      let(:user) { create(:user) }
      let(:headers) { user.create_new_auth_token }
      it "ログアウトできる" do
        subject
        # binding.pry
        expect(user.reload.tokens).to be_blank
        expect(response).to have_http_status(200)

      end
    end

    context "誤ったものを送信したとき" do
        let(:user) { create(:user) }
        let(:headers)  { { "access-token" => "", "token-type" => "", "client" => "", "expiry" => "", "uid" => "" } }
        it "失敗" do
          subject
          # binding.pry
          res = JSON.parse(response.body)
          expect(res["errors"]).to include("User was not found or was not logged in.")
          expect(response).to have_http_status(404)
        end
      end
    end
  end
