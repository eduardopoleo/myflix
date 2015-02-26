require 'spec_helper'

feature 'Admins interacts with the videos' do
  scenario 'Admin adds a video and the plays it as user' do
   dramas = Fabricate(:category, title: 'Dramas')
   action = Fabricate(:category, title: 'Action')
   adventure = Fabricate(:category, title: 'Adventure')
   admin = Fabricate(:admin)

   sign_in(admin) 
   visit new_admin_videos_path
   fill_in "Title", :with =>'Some title'  
   select('Dramas', :from => 'Category')
   fill_in "Description", :with =>'Some short but sweet Description'  
   attach_file 'Large cover', 'spec/support/uploads/large_monk.jpg'
   attach_file 'Small cover', 'spec/support/uploads/monk.jpg'
   fill_in "Video url", :with =>'http://www.example.com/my_video.mp4'  
   click_button 'Add Video'

   sign_out
   sign_in

   visit video_path(Video.first)
   expect(page).to have_selector("img[src='/uploads/large_monk.jpg']")
   expect(page).to have_selector("a[href='http://www.example.com/my_video.mp4']")
  end
end

