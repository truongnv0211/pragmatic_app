require "rails_helper"

RSpec.describe "UsersSignup", type: :feature do
  before do
    ActionMailer::Base.deliveries.clear
  end

  it "does not create a user with invalid signup information" do
    visit signup_path

    expect {
      fill_in "Name", with: ""
      fill_in "Email", with: "user@invalid"
      fill_in "Password", with: "foo"
      fill_in "Confirmation", with: "bar"
      click_button "Create my account"
    }.not_to change(User, :count)

    expect(page).to have_current_path(users_path) # POST /users => render :new
    expect(page).to have_selector("div#error_explanation")
    expect(page).to have_selector("div.field_with_errors")
  end

  it "creates a user with valid information and activates the account" do
    visit signup_path

    expect {
      fill_in "Name", with: "Example User"
      fill_in "Email", with: "user@example.com"
      fill_in "Password", with: "password"
      fill_in "Confirmation", with: "password"
      click_button "Create my account"
    }.to change(User, :count).by(1)

    expect(ActionMailer::Base.deliveries.size).to eq(1)
    activation_token = extract_activation_token(ActionMailer::Base.deliveries.last)

    user = User.find_by(email: "user@example.com")
    expect(user).not_to be_activated

    # Try to log in before activation
    log_in_as(user)
    expect(page).not_to have_link("Log out")

    # Invalid activation token
    visit edit_account_activation_path("invalid token", email: user.email, id: "token")
    expect(page).not_to have_link("Log out")

    # Valid token, wrong email
    visit edit_account_activation_path(activation_token, email: "wrong")
    expect(page).not_to have_link("Log out")

    # Valid activation
    visit edit_account_activation_path(activation_token, email: user.email)
    expect(user.reload).to be_activated
    expect(page).to have_current_path(user_path(user))
    expect(page).to have_content(user.name)
    expect(page).to have_link("Log out")
  end
end
