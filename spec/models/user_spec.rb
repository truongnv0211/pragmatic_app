require "rails_helper"

RSpec.describe User, type: :model do
  subject do
    described_class.new(
      name: "Example User",
      email: "user@example.com",
      password: "foobar",
      password_confirmation: "foobar"
    )
  end

  describe "validations" do
    it "is valid with valid attributes" do
      expect(subject).to be_valid
    end

    it "requires name to be present" do
      subject.name = ""
      expect(subject).not_to be_valid
    end

    it "requires email to be present" do
      subject.email = "    "
      expect(subject).not_to be_valid
    end

    it "rejects too long name" do
      subject.name = "a" * 51
      expect(subject).not_to be_valid
    end

    it "rejects too long email" do
      subject.email = "#{"a" * 244}@example.com"
      expect(subject).not_to be_valid
    end

    it "accepts valid email addresses" do
      valid_addresses = %w[
        user@example.com USER@foo.COM A_US-ER@foo.bar.org
        first.last@foo.jp alice+bob@baz.cn
      ]

      valid_addresses.each do |email|
        subject.email = email
        expect(subject).to be_valid, "#{email.inspect} should be valid"
      end
    end

    it "rejects invalid email addresses" do
      invalid_addresses = %w[
        user@example,com user_at_foo.org user.name@example.
        foo@bar_baz.com foo@bar+baz.com
      ]

      invalid_addresses.each do |email|
        subject.email = email
        expect(subject).not_to be_valid, "#{email.inspect} should be invalid"
      end
    end

    it "enforces unique email addresses" do
      subject.save
      duplicate_user = subject.dup
      expect(duplicate_user).not_to be_valid
    end

    it "requires nonblank password" do
      subject.password = subject.password_confirmation = " " * 6
      expect(subject).not_to be_valid
    end

    it "requires password to be at least 6 characters" do
      subject.password = subject.password_confirmation = "a" * 5
      expect(subject).not_to be_valid
    end
  end

  describe "#authenticated?" do
    it "returns false when digest is nil" do
      expect(subject.authenticated?(:remember, "")).to be_falsey
    end
  end

  describe "micropost associations" do
    it "destroys associated microposts when user is deleted" do
      subject.save!
      subject.microposts.create!(content: "Lorem ipsum")

      expect { subject.destroy }.to change(Micropost, :count).by(-1)
    end
  end

  describe "following" do
    let(:user1) { FactoryBot.create(:user) }
    let(:user2) { FactoryBot.create(:user) }

    it "can follow and unfollow another user" do
      expect(user1.following?(user2)).to be_falsey

      user1.follow(user2)
      expect(user1.following?(user2)).to be_truthy
      expect(user2.followers).to include(user1)

      user1.unfollow(user2)
      expect(user1.following?(user2)).to be_falsey
    end

    it "does not allow a user to follow themselves" do
      user1.follow(user1)
      expect(user1.following?(user1)).to be_falsey
    end
  end

  describe "feed" do
    let(:user) { FactoryBot.create(:user, :has_microposts, total_post: 3) }
    let(:followed) { FactoryBot.create(:user, :has_microposts, total_post: 3) }
    let(:unfollowed) { FactoryBot.create(:user, :has_microposts, total_post: 3) }

    before do
      user.follow(followed)
    end

    it "includes self posts and followed users' posts" do
      followed.microposts.each do |post|
        expect(user.feed).to include(post)
      end

      user.microposts.each do |post|
        expect(user.feed).to include(post)
      end
    end

    it "does not include unfollowed users' posts" do
      unfollowed.microposts.each do |post|
        expect(user.feed).not_to include(post)
      end
    end
  end
end
