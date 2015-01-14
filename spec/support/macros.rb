def set_current_user_id(user=nil) 
  session[:user_id] = (user || Fabricate(:user)).id
end

def clear_session 
  session[:user_id] = nil
end

def sign_in(a_user = nil)
  user = a_user || Fabricate(:user)
  visit signin_path
  fill_in 'email', with: user.email
  fill_in 'password', with: user.password
  click_button 'Sign in'
end


