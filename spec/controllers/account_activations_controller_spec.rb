require "rails_helper"

RSpec.describe AccountActivationsController, type: :controller do
  describe "GET /edit" do
    context "valid account" do
      let!(:user) { FactoryBot.create(:user, activated: false) }
      before do
        get :edit, params: {email: user.email, id: user.activation_token}
      end

      it "should redirect to profile" do
        expect(response).to redirect_to(user)
      end
    end

    context "invalie account" do
      before do
        get :edit, params: {email: "abcd", id: 1}
      end

      it "should redirect to profile" do
        expect(response).to redirect_to(root_path)
      end
    end
  end
end
