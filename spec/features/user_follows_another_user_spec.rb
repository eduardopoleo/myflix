require 'spec_helper'

feature 'User follows another users' do
  scenario 'User follows and unfollow another users' do
    alice = Fabricate(:user)
    bob = Fabricate(:user)
    comedies = Fabricate(:category) 
    monk = Fabricate(:video, title: 'Monk', category: comedies)
    review = Fabricate(:review, user: bob, video: monk)

    sign_in(alice)
    click_video_on_homepage(monk)
    page.should have_content(monk.title) 

    click_link bob.full_name
    follow(bob)
    page.should have_content(bob.full_name)

    unfollow 
    expect(alice.subjects.size).to eq(0)
  end

  def follow(user)
    find("a[href='/followings?subject_id=#{user.id}']").click
  end

  def unfollow 
    find("a[href='/followings/#{Following.first.id}']").click
  end
end

