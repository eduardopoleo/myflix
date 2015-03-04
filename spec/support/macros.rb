def set_current_user(user=nil) 
  session[:user_id] = (user || Fabricate(:user)).id
end

def set_current_admin(admin=nil) 
  session[:user_id] = (admin || Fabricate(:admin)).id
end

def clear_session 
  session[:user_id] = nil
end

def click_video_on_homepage(video)
  find("a[href='/videos/#{video.id}']").click
end

def sign_in(a_user = nil)
  user = a_user || Fabricate(:user)
  visit signin_path
  fill_in 'email', with: user.email
  fill_in 'password', with: user.password
  click_button 'Sign in'
end


def sign_in_integration_test(a_user = nil) 
  user = a_user || Fabricate(:user)
  session[:user_id] = user.id
end

def sign_out 
  visit signout_path
end


