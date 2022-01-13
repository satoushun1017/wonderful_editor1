# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  allow_password_change  :boolean          default(FALSE)
#  confirmation_sent_at   :datetime
#  confirmation_token     :string
#  confirmed_at           :datetime
#  email                  :string
#  encrypted_password     :string           default(""), not null
#  image                  :string
#  name                   :string
#  provider               :string           default("email"), not null
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  tokens                 :json
#  uid                    :string           default(""), not null
#  unconfirmed_email      :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_users_on_confirmation_token    (confirmation_token) UNIQUE
#  index_users_on_email                 (email)
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#  index_users_on_uid_and_provider      (uid,provider) UNIQUE
#
require "rails_helper"

RSpec.describe User, type: :model do
  # pending "add some examples to (or delete) #{__FILE__}"
  context "nameを指定しているとき" do
    let(:user) { build(:user) }
    it "記事が作成される" do
      # user = build(:user)
      expect(user).to be_valid
      # binding.pry
    end
  end

  # context "nameを指定していない時" do
  #   let(:user) { build(:user, name: nil) }
  #   it "記事の作成に失敗する" do
  #     # user = build(:user, name: nil)
  #     expect(user).to be_invalid
  #     # binding.pry
  #     expect(user.errors.details[:name][0][:error]).to eq :blank
  #   end
  # end

  context "emailが存在しない時" do
    let(:user) { build(:user, email: nil) }
    it "記事が作成に失敗" do
      # user = build(:user, email: nil)
      # expect(user).to be_invald
      user.valid?
      expect(user.errors.details[:email][0][:error]).to eq :blank
      # binding.pry
    end
  end

  context "passwordが存在しない時" do
    let(:user) { build(:user, password: nil) }
    it "記事の作成に失敗" do
      # user = build(:user, password: nil)
      user.valid?
      expect(user.errors.details[:password][0][:error]).to eq :blank
      # binding.pry
    end
  end

  context "名前のみの入力の場合" do
    let(:user) { build(:user, email: nil, password: nil) }
    it "記事の作成に失敗" do
      user.valid?
    end
  end
end
