# == Schema Information
#
# Table name: articles
#
#  id         :bigint           not null, primary key
#  body       :text
#  status     :string           default("draft")
#  title      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :bigint           not null
#
# Indexes
#
#  index_articles_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#

RSpec.describe Article, type: :model do
  describe "正常系" do
    context "情報が揃っているとき" do
      let(:article) { build(:article) }
      it "下書き記事として保存できる" do
        expect(article).to be_valid
        # binding.pry
        expect(article.status).to eq "draft"
      end
    end

    context "statusが下書きの時" do
      let(:article) { build(:article, :draft) }
      it "下書きを保存できる" do
        expect(article).to be_valid
        # binding.pry
        expect(article.status).to eq "draft"
      end
    end

    context "statusが公開の時" do
      let(:article) { build(:article, :published) }
      it "公開記事を保存できる" do
        expect(article).to be_valid
        # binding.pry
        expect(article.status).to eq "published"
      end
    end
  end
end
