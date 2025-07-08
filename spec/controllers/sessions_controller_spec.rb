require "rails_helper"

RSpec.describe SessionsController, type: :controller do
  describe "GET /new" do
    before do
      get :new
    end

    it "should load succes" do
      expect(response).to render_template :new
    end
  end

  describe "POST /create" do
    let(:user) { FactoryBot.create(:user) }
    context "when remembering" do
      before do
        post :create, params: {
          session: {
            email: user.email,
            password: "password",
            remember_me: "1"
          }
        }
      end

      it "should has cookies" do
        expect(cookies["remember_token"]).not_to be_blank
      end
    end

    context "when remembering" do
      before do
        post :create, params: {
          session: {
            email: user.email,
            password: "password",
            remember_me: "0"
          }
        }
      end

      it "should has cookies" do
        expect(cookies["remember_token"]).to be_blank
      end
    end
  end
end
