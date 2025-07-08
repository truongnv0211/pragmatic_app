require "rails_helper"

RSpec.describe "Password resets", type: :feature do
  let!(:user) { FactoryBot.create(:user) }

  before do
    ActionMailer::Base.deliveries.clear
  end

  it "resets password through the interface" do
    visit new_password_reset_path
    expect(page).to have_current_path(new_password_reset_path)
    expect(page).to have_selector("input[name='password_reset[email]']")

    # invalie email
    fill_in "Email", with: ""
    click_button "Submit"
    expect(page).to have_current_path(password_resets_path)
    expect(page).to have_selector("div.alert")

    # valid email
    fill_in "Email", with: user.email
    click_button "Submit"
    expect(user.reload.reset_digest).not_to be_nil
    expect(ActionMailer::Base.deliveries.size).to eq(1)
    expect(page).to have_current_path(root_path)
    expect(page).to have_selector("div.alert")

    reset_user = User.find_by(email: user.email)
    token = extract_reset_token(ActionMailer::Base.deliveries.last)

    # Invalid email
    visit edit_password_reset_path(token, email: "")
    expect(page).to have_current_path(root_path)

    # Account not active
    reset_user.update!(activated: false)
    visit edit_password_reset_path(token, email: reset_user.email)
    expect(page).to have_current_path(root_path)
    reset_user.update!(activated: true)

    # Token exprired
    reset_sent_at = reset_user.reset_sent_at
    reset_user.update!(reset_sent_at: Time.zone.now - 3.hour)
    visit edit_password_reset_path(token, email: reset_user.email)
    expect(page).to have_current_path(new_password_reset_url)
    reset_user.update!(reset_sent_at: reset_sent_at)

    # Invalid token
    visit edit_password_reset_path("wrong-token", email: reset_user.email)
    expect(page).to have_current_path(root_path)

    # Token & email valid
    visit edit_password_reset_path(token, email: reset_user.email)
    expect(page).to have_selector("form")
    expect(page).to have_field("email", type: "hidden", with: reset_user.email)

    # Password not match
    fill_in "Password", with: "foobaz"
    fill_in "Confirmation", with: "barquux"
    click_button "Update password"
    expect(page).to have_selector("div#error_explanation")

    # Empty password
    fill_in "Password", with: ""
    fill_in "Confirmation", with: ""
    click_button "Update password"
    expect(page).to have_selector("div#error_explanation")

    # Password valid
    fill_in "Password", with: "foobaz"
    fill_in "Confirmation", with: "foobaz"
    click_button "Update password"

    expect(page).to have_current_path(user_path(reset_user))
    expect(page).to have_selector("div.alert")
    expect(page).to have_link("Log out")
  end
end
