require "rails_helper"

RSpec.describe "UsersProfile", type: :feature do
  include ApplicationHelper

  let!(:user) { FactoryBot.create(:user, :has_microposts, total_post: 35) }

  it "displays the user's profile with microposts and pagination" do
    visit user_path(user)
    expect(page).to have_title(full_title(user.name))
    expect(page).to have_selector("h1", text: user.name)
    expect(page).to have_selector("h1 img.gravatar")
    expect(page).to have_content(user.microposts.count.to_s)
    expect(page).to have_selector("div.pagination")
    user.microposts.paginate(page: 1).each do |micropost|
      expect(page).to have_content(micropost.content)
    end
  end
end
