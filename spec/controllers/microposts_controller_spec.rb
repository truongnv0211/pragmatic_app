require "rails_helper"

RSpec.describe MicropostsController, type: :controller do
  let(:user) { FactoryBot.create(:user) }
  let(:other_user) { FactoryBot.create(:user) }
  let(:micropost) { FactoryBot.create(:micropost, user: user) }
  let(:other_micropost) { FactoryBot.create(:micropost, user: other_user) }
  let(:total_micropost) { Micropost.count }

  describe "POST /microposts" do
    context "when not logged in" do
      before do
        post :create, params: {micropost: {content: "Lorem ipsum"}}
      end

      it "does not create a micropost and redirects to login" do
        expect(Micropost.count).to eq(total_micropost)
        expect(response).to redirect_to(login_url)
      end
    end
  end

  describe "DELETE /microposts/:id" do
    context "when not logged in" do
      before do
        delete :destroy, params: {id: micropost.id}
      end
      it "does not delete the micropost and redirects to login" do
        expect(Micropost.count).to eq(total_micropost)
        expect(response).to redirect_to(login_url)
      end
    end

    context "when logged in as wrong user" do
      before do
        sign_in(user)
        delete :destroy, params: {id: other_micropost.id}
      end

      it "does not delete the other user's micropost and redirects to root" do
        expect(Micropost.count).to eq(total_micropost)
        expect(response).to redirect_to(root_url)
      end
    end

    context "when logged in and wrong referer" do
      before do
        sign_in(user)
        request.env["HTTP_referer"] = nil
        delete :destroy, params: {id: micropost.id}
      end

      it "does not delete the other user's micropost and redirects to root" do
        expect(Micropost.count).to eq(total_micropost)
        expect(response).to redirect_to(root_url)
      end
    end
  end
end
