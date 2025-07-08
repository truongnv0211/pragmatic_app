require "rails_helper"

RSpec.describe "Following and followers pages", type: :feature do
  let!(:user) { FactoryBot.create(:user) }
  let!(:other) { FactoryBot.create(:user) }

  before do
    user.follow(other)
    other.follow(user)
    log_in_as(user)
  end

  it "displays following list" do
    visit following_user_path(user)

    expect(user.following).not_to be_empty
    expect(page).to have_content(user.following.count.to_s)

    user.following.each do |followed_user|
      expect(page).to have_link(followed_user.name, href: user_path(followed_user))
    end
  end

  it "displays followers list" do
    visit followers_user_path(user)

    expect(user.followers).not_to be_empty
    expect(page).to have_content(user.followers.count.to_s)

    user.followers.each do |follower|
      expect(page).to have_link(follower.name, href: user_path(follower))
    end
  end
end
