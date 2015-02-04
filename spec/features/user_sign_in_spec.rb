require 'spec_helper'

feature 'User signs in' do
  scenario 'with existing username' do
    my_user = Fabricate(:user)
    sign_in(my_user)
    page.should have_content my_user.full_name
  end
end
