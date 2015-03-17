require 'spec_helper'

feature 'User Makes Payment', :vcr do
  background do
    visit register_path
  end

  scenario 'valid user info and valid payment info',:js => true do
    fill_in_user_information('joe@gmail.com')
    fill_in_payment_information('4242424242424242')
    click_button('Sign Up')
    expect(page).to have_content('Joe')
  end

  scenario 'valid user info and invalid payment info',:js => true do
    fill_in_user_information('joe@gmail.com')
    fill_in_payment_information('4242424s4242')
    click_button('Sign Up')
    expect(page).to have_content("incorrect" )
  end

  scenario 'valid user info and declined card',:js => true do
    fill_in_user_information('joe@gmail.com')
    fill_in_payment_information('4000000000000002')
    click_button('Sign Up')
    expect(page).to have_content("declined" )
  end

  scenario 'invalid user info and valid payment info',:js => true do
    fill_in_user_information('')
    fill_in_payment_information('4242424242424242')
    click_button('Sign Up')
    expect(page).to have_content("can't be blank" )
  end

  scenario 'invalid user info and invalid payment info',:js => true do
    fill_in_user_information('')
    fill_in_payment_information('424242424242')
    click_button('Sign Up')
    expect(page).to have_content("can't be blank" )
  end

  scenario 'invalid user info and declined card info',:js => true do
    fill_in_user_information('')
    fill_in_payment_information('4000000000000002')
    click_button('Sign Up')
    expect(page).to have_content("can't be blank" )
  end
end

def fill_in_user_information(email)
  fill_in('Email Address', with: email)
  fill_in('Password', with: 'password')
  fill_in('Full Name', with: 'Joe Vargas')
end

def fill_in_payment_information(card)
  fill_in("Credit Card Number", with: card)
  fill_in("Security Code", with: '123')
  select("7 - July", from: "date_month" )
  select("2017", from: "date_year" )
end
