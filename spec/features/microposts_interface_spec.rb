require "rails_helper"

RSpec.describe "MicropostInterface", type: :feature do
  let!(:user) { FactoryBot.create(:user, :has_microposts, total_post: 35) }
  let!(:other_user) { FactoryBot.create(:user, :has_microposts, total_post: 2) }

  before do
    log_in_as(user)
    visit(root_path)
  end

  it "displays pagination and file upload form" do
    expect(page).to have_selector("div.pagination")
    expect(page).to have_selector("input[type=file]")
  end

  it "rejects invalid micropost submission" do
    fill_in "micropost_content", with: ""
    click_button "Post"

    expect(page).to have_selector("div#error_explanation")
    expect(page).to have_link("2", href: "/?page=2") # Pagination link exists
  end

  it "accepts valid submission with image" do
    content = "This micropost really ties the room together"
    image_path = Rails.root.join("test", "fixtures", "files", "kitten.jpg")

    expect {
      fill_in "micropost_content", with: content
      attach_file("micropost_image", image_path)
      click_button "Post"
    }.to change(Micropost, :count).by(1)

    expect(page).to have_content(content)

    micropost = Micropost.order(created_at: :desc).first
    expect(micropost.reload.image).to be_attached
  end

  it "allows deletion of own microposts" do
    first_micropost = user.microposts.paginate(page: 1).first
    expect(page).to have_link("delete", href: micropost_path(first_micropost))

    expect {
      # accept_confirm do
      click_link("delete", href: micropost_path(first_micropost))
      # end
    }.to change(Micropost, :count).by(-1)
  end

  it "does not show delete link on other users' profiles" do
    visit user_path(other_user)
    expect(page).not_to have_link("delete")
  end
end
