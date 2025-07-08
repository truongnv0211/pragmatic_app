require "rails_helper"

RSpec.describe Micropost, type: :model do
  let(:user) { FactoryBot.create(:user) }

  subject { user.microposts.build(content: "Lorem ipsum") }

  describe "validations" do
    it "is valid with valid attributes" do
      expect(subject).to be_valid
    end

    it "is invalid without a user_id" do
      subject.user_id = nil
      expect(subject).not_to be_valid
    end

    it "is invalid with blank content" do
      subject.content = "   "
      expect(subject).not_to be_valid
    end

    it "is invalid if content is too long" do
      subject.content = "a" * 141
      expect(subject).not_to be_valid
    end
  end

  describe "ordering" do
    it "returns most recent microposts first" do
      _ = FactoryBot.create(:micropost, user: user, created_at: 1.day.ago)
      newer = FactoryBot.create(:micropost, user: user, created_at: 1.hour.ago)
      expect(Micropost.first).to eq(newer)
    end
  end
end
