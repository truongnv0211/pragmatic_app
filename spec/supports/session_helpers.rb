module SessionHelpers
  # Returns true if a test user is logged in.
  def is_logged_in?
    !session[:user_id].nil?
  end

  # Log in as a particular user.
  def sign_in(user)
    session[:user_id] = user.id
    session[:session_token] = user.session_token
  end
end
