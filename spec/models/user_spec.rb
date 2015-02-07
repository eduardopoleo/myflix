require 'spec_helper'

describe User do
  it {should validate_presence_of(:email)}
  it {should validate_presence_of(:password)}
  it {should validate_presence_of(:full_name)}
  it {should validate_uniqueness_of(:email)}
  it {should have_secure_password}
  it {should have_many(:reviews)}
  it {should have_many(:queue_items).order(:order)}
  it {should have_many(:followings).order('created_at desc')}
  it {should have_many(:subjects)}

  it "generates a ramdon token when the user is created" do
    alice = Fabricate(:user)
    expect(alice.token).to be_present
  end
end
