require 'spec_helper'

describe VideosController do
  describe 'GET show' do
    it 'sets the @video variable if user is authenticated' do
      session[:user_id] = Fabricate(:user).id
      video = Fabricate(:video)
      get :show, id: video.id
      assigns(:video).should == video
    end

    # we would like to test the response
    # it 'renders the show template' do
    #   video = Fabricate(:video)
    #   get :show, id: video.id
    #   expect(response).to render_template :show 
    # end

    it 'Sets the variable @reviews for authenticated users' do
      session[:user_id] = Fabricate(:user).id
      video = Fabricate(:video)
      review1 = Fabricate(:review, video: video)
      review2 = Fabricate(:review, video: video)
      get :show, id: video.id
      assigns(:reviews).should =~ [review1, review2]
    end 

    it 'Redirects users to the signing page if users is unauthenticated' do
      video = Fabricate(:video)
      get :show, id: video.id
      response.should redirect_to signin_path
    end


  end

  describe 'POST search' do
    it 'sets the @videos variable if user authenticated' do
      session[:user_id] = Fabricate(:user).id
      futurama = Fabricate(:video, title: 'futurama')
      post :search, search_word: 'futu'
      assigns(:videos).should == [futurama]
    end
    it 'redirects to signin_path if user is not authenticated' do
      futurama = Fabricate(:video, title: 'futurama')
      post :search, search_word: 'futu'
      response.should redirect_to signin_path
    end
  end 
end