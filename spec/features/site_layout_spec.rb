require "rails_helper"

RSpec.describe "Site layout", type: :feature do
  it "displays correct layout links" do
    visit(root_path)

    expect(page).to have_current_path(root_path)
    expect(page).to have_link(nil, href: root_path, count: 2)
    expect(page).to have_link("Help",    href: help_path)
    expect(page).to have_link("About",   href: about_path)
    expect(page).to have_link("Contact", href: contact_path)
  end
end
