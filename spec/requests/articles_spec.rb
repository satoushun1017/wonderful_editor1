require "rails_helper"

RSpec.describe "Articles", type: :request do
  describe "GET /articles" do
    # pending "add some examples (or delete) #{__FILE__}"
    subject { get(api_v1_articles_path) }

    it "ユーザーの一覧が取得できる" do
      # subject

      # binding.pry
    end
  end
end
