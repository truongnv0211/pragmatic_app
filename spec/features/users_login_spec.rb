require "rails_helper"

RSpec.describe "UsersLogin", type: :feature do
  let!(:user) { FactoryBot.create(:user) }

  it "fails login with valid email and invalid password" do
    visit login_path
    expect(page).to have_current_path(login_path)

    fill_in "Email", with: user.email
    fill_in "Password", with: "invalid"
    click_button "Log in"

    expect(page).to have_current_path(login_path)
    expect(page).to have_selector("div.alert-danger")

    visit root_path
    expect(page).not_to have_selector("div.alert-danger")
  end

  it "logs in with valid credentials and logs out correctly (including double logout)" do
    visit login_path
    fill_in "Email", with: user.email
    fill_in "Password", with: "password"
    click_button "Log in"

    expect(page).to have_current_path(user_path(user))
    expect(page).not_to have_link("Log in")
    expect(page).to have_link("Log out")
    expect(page).to have_link("Profile", href: user_path(user))

    # Log out
    click_link "Log out"
    expect(page).to have_current_path(root_path)
    expect(page).to have_link("Log in")
    expect(page).not_to have_link("Log out")
    expect(page).not_to have_link(user.name)
  end
end
