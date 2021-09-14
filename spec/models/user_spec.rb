require "rails_helper"
require "support/devise"
RSpec.describe User, type: :model do
  let(:user){FactoryBot.create :user}
  let(:user2){FactoryBot.create :user, email: "Abcxyz2@gmail.com"}

  describe "validations" do
    it {expect(user).to be_valid}
  end

  describe "Associations" do
    it {expect(user).to have_many(:active_relationships).dependent(:destroy)}
    it {expect(user).to have_many(:passive_relationships).dependent(:destroy)}
    it {expect(user).to have_many(:following).through(:active_relationships)}
    it {expect(user).to have_many(:followers).through(:passive_relationships)}
    it {expect(user).to have_many(:reviews).dependent(:destroy)}
    it {expect(user).to have_many(:requests).dependent(:destroy)}
  end

  describe "Enums" do
    it "role" do
      is_expected.to define_enum_for(:role)
                       .with_values admin: 0, member: 1
    end
  end

  it "should follow and unfollow a user" do
    expect(user.following?(user2)).to eq false
    user.follow(user2)
    assert user.following?(user2)
    assert user2.followers.include?(user)
    user.unfollow(user2)
    expect(user.following?(user2)).to eq false
    # Users can't follow themselves.
    user.follow(user)
    expect(user.following?(user)).to eq false
  end
end
