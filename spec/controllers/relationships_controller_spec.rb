require "rails_helper"

RSpec.describe RelationshipsController, type: :controller do
  let(:total_relation) { Relationship.count }

  describe "POST /relationships" do
    context "when not logged in" do
      before do
        post :create
      end

      it "does not create a relationship and redirects to login" do
        expect(Relationship.count).to eq(total_relation)
        expect(response).to redirect_to(login_url)
      end
    end

    context "when logged in" do
      let!(:followed) { FactoryBot.create(:user) }
      let!(:follower) { FactoryBot.create(:user) }
      before do
        sign_in(follower)
        post :create, params: {followed_id: followed.id}
      end

      it "does not create a relationship and redirects to user_path" do
        expect(Relationship.count).to eq(1)
        expect(response).to redirect_to(user_path(followed))
      end
    end
  end

  describe "DELETE /relationships/:id" do
    let!(:followed) { FactoryBot.create(:user) }
    let!(:follower) { FactoryBot.create(:user) }
    let!(:relationship) do
      FactoryBot.create(:relationship, followed_id: followed.id,
        follower_id: follower.id)
    end

    context "when not logged in" do
      before do
        delete :destroy, params: {id: relationship.id}
      end

      it "does not destroy the relationship and redirects to login" do
        expect(Relationship.count).to eq(total_relation)
        expect(response).to redirect_to(login_url)
      end
    end

    context "when logged in" do
      before do
        sign_in(follower)
        delete :destroy, params: {id: relationship.id}
      end

      it "shoulde destroy the relationship" do
        expect(Relationship.count).to eq(0)
        expect(response).to redirect_to(user_path(followed))
      end
    end
  end
end
