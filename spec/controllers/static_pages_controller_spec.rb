require "rails_helper"

RSpec.describe StaticPagesController, type: :controller do
  render_views

  describe "GET /" do
    before do
      get :home
    end

    it "returns success and correct title" do
      expect(response).to render_template(:home)
      expect(response.body).to include("<title>Ruby on Rails Tutorial Sample App</title>")
    end
  end

  describe "GET /help" do
    before do
      get :help
    end
    it "returns success and correct title" do
      expect(response).to render_template(:help)
      expect(response.body).to include("<title>Help | Ruby on Rails Tutorial Sample App</title>")
    end
  end

  describe "GET /about" do
    before do
      get :about
    end
    it "returns success and correct title" do
      expect(response).to render_template(:about)
      expect(response.body).to include("<title>About | Ruby on Rails Tutorial Sample App</title>")
    end
  end

  describe "GET /contact" do
    before do
      get :contact
    end
    it "returns success and correct title" do
      expect(response).to render_template(:contact)
      expect(response.body).to include("<title>Contact | Ruby on Rails Tutorial Sample App</title>")
    end
  end
end
