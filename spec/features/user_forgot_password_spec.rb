require 'spec_helper'

feature 'User forgot another user' do
  scenario 'user successfully  resets the password' do
    alice = Fabricate(:user, password: "some_password")
    navigate_to_signin
    
    click_link('Forgot Password?')
    fill_in('Email Adress', with: alice.email)
    click_button('Send Email')

    open_email(alice.email)
    current_email.click_link('Reset My Password')
    expect(page).to have_content('New Password')

    fill_in('New Password', with: 'password')
    click_button('Reset Password')
    
    fill_in('Email Address', with: alice.email)
    fill_in('Password', with: 'password')
    click_button('Sign in')
    expect(page).to have_content(alice.full_name)

    clear_email
  end

  def navigate_to_signin
    clear_emails
    visit root_path
    click_link('Sign In')
    expect(page).to have_content("Forgot")
  end
end
