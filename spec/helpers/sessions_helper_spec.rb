require "rails_helper"

RSpec.describe SessionsHelper, type: :helper do
  let(:user) { FactoryBot.create(:user) }

  describe "#current_user" do
    before do
      remember(user)
    end

    context "when session is nil but remember_token is valid" do
      it "returns the correct user" do
        expect(current_user).to eq(user)
        expect(logged_in?).to be true
      end
    end

    context "when remember digest is wrong" do
      it "returns nil" do
        user.update_attribute(:remember_digest, User.digest(User.new_token))
        expect(current_user).to be_nil
      end
    end
  end
end
