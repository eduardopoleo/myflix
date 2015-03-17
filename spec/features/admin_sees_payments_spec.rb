require 'spec_helper'

feature "AdminSeesPayments" do
  background do
    alice = Fabricate(:user, full_name: 'Alice Doe', email: "alice@example.com")
    Fabricate(:payment, amount: 999, user: alice)
  end
  scenario "Admin can see payments" do
    sign_in(Fabricate(:admin))
    visit admin_payments_path
    expect(page).to have_content("$9.99")
    expect(page).to have_content("alice@example.com")
    expect(page).to have_content("Alice Doe")
  end

  scenario "Users can not see payments" do
    user = Fabricate(:user)
    sign_in(user)
    visit admin_payments_path
    expect(page).not_to have_content("$9.99")
    expect(page).not_to have_content("alice@example.com")
    expect(page).not_to have_content("Alice Doe")
    expect(page).to have_content("Sorry but you are not authorized to do that.")
  end
end
