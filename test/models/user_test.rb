require "test_helper"

class UserTest < ActiveSupport::TestCase
  def setup
    @user = User.new(name: "Example User", email: "user@example.com",
      password: "foobar", password_confirmation: "foobar")
  end

  test "should be valid" do
    assert @user.valid?
  end

  test "name should be present" do
    @user.name = ""
    assert_not @user.valid?
  end

  test "email should be present" do
    @user.email = "     "
    assert_not @user.valid?
  end

  test "name should not be too long" do
    @user.name = "a" * 51
    assert_not @user.valid?
  end

  test "email should not be too long" do
    @user.email = "a" * 244 + "@example.com"
    assert_not @user.valid?
  end

  test "email validation should accept valid addresses" do
    valid_addresses = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org
      first.last@foo.jp alice+bob@baz.cn]
    valid_addresses.each do |valid_address|
      @user.email = valid_address
      assert @user.valid?, "#{valid_address.inspect} should be valid"
    end
  end

  test "email validation should reject invalid addresses" do
    invalid_addresses = %w[user@example,com user_at_foo.org user.name@example.
      foo@bar_baz.com foo@bar+baz.com]
    invalid_addresses.each do |invalid_address|
      @user.email = invalid_address
      assert_not @user.valid?, "#{invalid_address.inspect} should be invalid"
    end
  end

  test "email addresses should be unique" do
    duplicate_user = @user.dup
    @user.save
    assert_not duplicate_user.valid?
  end

  test "password should be present (nonblank)" do
    @user.password = @user.password_confirmation = " " * 6
    assert_not @user.valid?
  end

  test "password should have a minimum length" do
    @user.password = @user.password_confirmation = "a" * 5
    assert_not @user.valid?
  end

  test "authenticated? should return false for a user with nil digest" do
    assert_not @user.authenticated?(:remember, "")
  end

  test "associated microposts should be destroyed" do
    @user.save
    @user.microposts.create!(content: "Lorem ipsum")
    assert_difference "Micropost.count", -1 do
      @user.destroy
    end
  end

  test "should follow and unfollow a user" do
    first_user = FactoryBot.create(:user)
    second_user = FactoryBot.create(:user)
    assert_not first_user.following?(second_user)
    first_user.follow(second_user)
    assert first_user.following?(second_user)
    assert second_user.followers.include?(first_user)
    first_user.unfollow(second_user)
    assert_not first_user.following?(second_user)
    # Users can't follow themselves.
    first_user.follow(first_user)
    assert_not first_user.following?(first_user)
  end

  test "feed should have the right posts" do
    first_user = FactoryBot.create(:user)
    second_user = FactoryBot.create(:user)
    third_user = FactoryBot.create(:user)
    # Posts from followed user
    third_user.microposts.each do |post_following|
      assert first_user.feed.include?(post_following)
    end
    # Self-posts for user with followers
    first_user.microposts.each do |post_self|
      assert first_user.feed.include?(post_self)
    end
    # Self-posts for user with no followers
    second_user.microposts.each do |post_self|
      assert second_user.feed.include?(post_self)
    end
    # Posts from unfollowed user
    second_user.microposts.each do |post_unfollowed|
      assert_not first_user.feed.include?(post_unfollowed)
    end
  end
end
