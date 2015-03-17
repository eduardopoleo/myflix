require 'spec_helper'

feature 'User signs in' do
  scenario 'with existing username' do
    my_user = Fabricate(:user)
    sign_in(my_user)
    expect(page).to have_content my_user.full_name
  end

  scenario 'with existing username' do
    my_user = Fabricate(:user, active: false)
    sign_in(my_user)
    expect(page).not_to have_content(my_user.full_name)
    expect(page).to have_content("Your account have been suspended please contact customer service.")
  end
end
