require "test_helper"

class RelationshipsControllerTest < ActionDispatch::IntegrationTest
  test "create should require logged-in user" do
    assert_no_difference "Relationship.count" do
      post relationships_path
    end
    assert_redirected_to login_url
  end

  test "destroy should require logged-in user" do
    @followed = FactoryBot.create(:user)
    @follower = FactoryBot.create(:user)
    @relationship = FactoryBot.create(:relationship,
      followed_id: @followed.id, follower_id: @follower.id)
    assert_no_difference "Relationship.count" do
      delete relationship_path(@relationship)
    end
    assert_redirected_to login_url
  end
end
