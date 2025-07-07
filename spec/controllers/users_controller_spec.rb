require "rails_helper"

RSpec.describe UsersController, type: :controller do
  let!(:user) { FactoryBot.create(:user) }
  let!(:other_user) { FactoryBot.create(:user, :non_admin) }

  describe "GET /signup" do
    before do
      get :new
    end

    it "renders the signup page successfully" do
      expect(response).to render_template(:new)
    end
  end

  describe "GET /users (index)" do
    before do
      get :index
    end

    it "redirects to login when not logged in" do
      expect(response).to redirect_to(login_url)
    end
  end

  describe "GET /users/:id/edit" do
    context "when not logged in" do
       before do
        get :edit, params: {id: user.id}
      end

      it "redirects to login" do
        expect(flash).not_to be_empty
        expect(response).to redirect_to(login_url)
      end
    end

    context "when logged in as wrong user" do
      before do
        sign_in(other_user)
        get :edit, params: {id: user.id}
      end

      it "redirects to root and does not show flash" do
        expect(flash).to be_empty
        expect(response).to redirect_to(root_url)
      end
    end
  end

  describe "PATCH /users/:id" do
    let(:user_params) do
      {
        id: user.id,
        user: {
          name: user.name,
          email: user.email
        }
      }
    end

    context "when not logged in" do
      before do
        patch :update, params: user_params
      end

      it "redirects to login with flash" do
        expect(flash).not_to be_empty
        expect(response).to redirect_to(login_url)
      end
    end

    context "when logged in as wrong user" do
      before do
        sign_in(other_user)
        patch :update, params: user_params
      end

      it "redirects to root without flash" do
        expect(flash).to be_empty
        expect(response).to redirect_to(root_url)
      end
    end

    context "when get edit" do
      before do
        sign_in(user)
        get :edit, params: {id: user.id}
      end
      it "should render edit view" do
        expect(response).to render_template(:edit)
      end
    end

    context "when update with invalid data" do
      before do
        sign_in(user)
        patch :update, params: {
          id: user.id,
          user: {
            name: "",
            email: "foo@invalid",
            password: "foo",
            password_confirmation: "bar"
          }
        }
      end
      it "should render edit view" do
        expect(response).to render_template(:edit)
      end
    end

    context "when update with valid data" do
      let(:new_name){Faker::Name.name}
      let(:new_email){Faker::Internet.email}
      before do
        sign_in(user)
        patch :update, params: {
          id: user.id,
          user: {
            name: new_name,
            email: new_email,
            password: "",
            password_confirmation: ""
          }
        }
      end
      it "should render edit view" do
        expect(user.reload.email).to eq(new_email)
        expect(user.reload.name).to eq(new_name)
        expect(response).to redirect_to(user_path(user))
      end
    end
  end

  describe "DELETE /users/:id" do
    let(:total_user){User.count}
    context "when not logged in" do
      before do
        delete :destroy, params: {id: user.id}
      end
      it "does not delete the user and redirects to login" do
        expect(User.count).to eq(total_user)
        expect(response).to redirect_to(login_url)
      end
    end

    context "when logged in as non-admin" do
      before do
        sign_in(other_user)
        delete :destroy, params: {id: user.id}
      end

      it "does not delete the user and redirects to root" do
        expect(User.count).to eq(total_user)
        expect(response).to redirect_to(root_url)
      end
    end
  end

  describe "GET /users/:id/following" do
    before do
      get :following, params: {id: user.id}
    end
    it "redirects to login when not logged in" do
      expect(response).to redirect_to(login_url)
    end
  end

  describe "GET /users/:id/followers" do
    before do
      get :followers, params: {id: user.id}
    end
    it "redirects to login when not logged in" do
      expect(response).to redirect_to(login_url)
    end
  end
end
