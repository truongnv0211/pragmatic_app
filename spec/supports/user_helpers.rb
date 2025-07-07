module UserHelpers
  def log_in_as(user, remember_me: 0)
    visit(login_url)
    fill_in("Email", with: user.email)
    fill_in("Password", with: "password")
    find(:css, "#session_remember_me").set(remember_me)
    click_button("Log in")
  end

  def extract_activation_token(mail)
    activation_url = mail.body.encoded.match(/http[^"]+/)[0]
    uri = URI.parse(activation_url)
    uri.path.split("/")[2]
  end

  def extract_reset_token(mail)
    reset_password_url = mail.body.encoded.match(/http[^"]+/)[0]
    uri = URI.parse(reset_password_url)
    uri.path.split("/")[2]
  end
end
