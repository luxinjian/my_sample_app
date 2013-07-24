include ApplicationHelper

def sign_in(user)
  visit signin_path
  fill_in "Email", with: user.email
  fill_in "Password", with: user.password
  click_button "Sign in"

  #current_user will be assigned when call current_user method
  cookies[:remember_token] = user.remember_token
end
