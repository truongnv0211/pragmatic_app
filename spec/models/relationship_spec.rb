require "rails_helper"

RSpec.describe Relationship, type: :model do
  let(:follower) { FactoryBot.create(:user) }
  let(:followed) { FactoryBot.create(:user) }

  subject { described_class.new(follower_id: follower.id, followed_id: followed.id) }

  describe "validations" do
    it "is valid with valid follower_id and followed_id" do
      expect(subject).to be_valid
    end

    it "is invalid without a follower_id" do
      subject.follower_id = nil
      expect(subject).not_to be_valid
    end

    it "is invalid without a followed_id" do
      subject.followed_id = nil
      expect(subject).not_to be_valid
    end
  end
end
