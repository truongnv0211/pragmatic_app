require "rails_helper"

RSpec.describe "UsersIndex", type: :feature do
  let!(:admin) { FactoryBot.create(:user) }
  let!(:non_admin) { FactoryBot.create(:user, :non_admin) }
  let!(:users){FactoryBot.create_list(:user, 30)}

  context "when logged in as admin" do
    before do
      log_in_as(admin)
      visit users_path
    end

    it "shows pagination and delete links for other users" do
      expect(page).to have_selector("div.pagination")

      User.paginate(page: 1).each do |user|
        expect(page).to have_link(user.name, href: user_path(user))

        if user != admin
          expect(page).to have_link("delete", href: user_path(user))
        else
          expect(page).not_to have_link("delete", href: user_path(user))
        end
      end
    end

    it "can delete another user" do
      expect {
        within(".users") do
          # Find first user that's not admin to delete
          target = User.where.not(id: admin.id).first
          click_link("delete", href: user_path(target))
        end
      }.to change(User, :count).by(-1)
    end
  end

  context "when logged in as non-admin" do
    before do
      log_in_as(non_admin)
      visit users_path
    end

    it "does not show delete links" do
      expect(page).not_to have_link("delete")
    end
  end
end
