def set_current_user_id(user=nil) 
  session[:user_id] = (user || Fabricate(:user)).id
end

def clear_session 
  session[:user_id] = nil
end


