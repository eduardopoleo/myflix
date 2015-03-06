require 'spec_helper'

feature 'User invites friend to sign up in myflix', {js: true, vcr: true} do
  scenario 'User sends out invitation' do
    alice = Fabricate(:user) 
    sign_in(alice)

    user_sends_invitation
    guest_opens_email
    guest_signs_in 
    guest_follows_user(alice) 
    user_follows_guest(alice)
    clear_email
  end

  def user_sends_invitation 
    click_link('Invite')
    fill_in('Guest name', with: 'Joe')
    fill_in('Guest email', with: 'joe@gmail.com')
    fill_in('Invitation', with: 'joe@gmail.com')
    click_button('Send Invitation')
    sign_out
  end

  def guest_opens_email
    open_email('joe@gmail.com')
    current_email.click_link('Join us!')
    fill_in('Password', with: 'password')
    fill_in('Full Name', with: 'Joe Vargas')
    fill_in("Credit Card Number", with: '4242424242424242')
    fill_in("Security Code", with: '123')
    select("7 - July", from:  "date_month" )
    select("2017", from:  "date_year" )
    click_button('Sign Up')
  end
  
  def guest_signs_in
    fill_in('email', with: 'joe@gmail.com')
    fill_in('Password', with: 'password')
    click_button('Sign in')
    expect(page).to have_content('Welcome, Joe')
  end

  def guest_follows_user(user)
    click_link("People")
    expect(page).to have_content(user.full_name)
    sign_out
  end

  def user_follows_guest(user)
    sign_in(user) 
    click_link("People")
    expect(page).to have_content('Joe Vargas')
  end
end
