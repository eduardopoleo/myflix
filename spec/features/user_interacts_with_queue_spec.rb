require 'spec_helper'

feature 'User interacts with the queue' do
  scenario 'User adds and reorder videos to the queue' do
    comedies = Fabricate(:category) 
    monk = Fabricate(:video, title: 'Monk', category: comedies)
    futurama = Fabricate(:video, title: 'Futurama', category: comedies)
    south_park = Fabricate(:video, title: 'South Park', category: comedies)
   
    sign_in
    add_video_to_queue(monk) 
    page.should have_content(monk.title)

    add_video_to_queue(futurama)
    add_video_to_queue(south_park)
        
    #OPTION: 1 Using id directly to fill the inputs
    # This is an easy solution only useful using the videos id
    # It is not always good to use ids because the front end guys may use it
    # We can not use fill anymore because it only works with id, names and labels
    # So we have to generate a new type of unique marque for each input and the find it as we found the href
    #
    # fill_in "video_#{monk.id}", with: 3
    # fill_in "video_#{south_park.id}", with: 1
    # fill_in "video_#{futurama.id}", with: 2
    #
    # click_button "Update Queue"
    # expect(find("#video_#{south_park.id}").value).to eq("1")
    # expect(find("#video_#{futurama.id}").value).to eq("2")
    # expect(find("#video_#{monk.id}").value).to eq("3")
    #
    # OPTION 2: Using the input data
    # This option is find but one must use find at all times to select the items
    
    set_video_position(south_park, 1) 
    set_video_position(futurama, 2) 
    set_video_position(monk, 3) 

    click_button "Update Queue"

    expected_video_position(south_park, 1)
    expected_video_position(futurama, 2)
    expected_video_position(monk, 3)
  end

  def add_video_to_queue(video)
    visit home_path
    find("a[href='/videos/#{video.id}']").click
    click_link "+ My Queue"
  end

  def set_video_position(video, position) 
    find("input[data-video-id='#{video.id}']").set(position)
  end

  def expected_video_position(video, position)
    expect(find("input[data-video-id='#{video.id}']").value).to eq(position.to_s)
  end
end
