require 'spec_helper'
describe SessionsController do
  describe 'GET new' do
    it 'Redirects to the homepath if there is a logged in user' do
      user = Fabricate(:user)
      session[:user_id] = user.id
      get :new
      response.should redirect_to home_path
    end
    it 'Renders the new template if there is NO logged in user' do
       get :new
       response.should render_template :new
    end
  end 
  
  describe 'POST create' do
    context 'Withvalid credentials' do
      it 'puts the authenticated user in the session' do
        alice = Fabricate(:user)
        post :create, email:alice.email, password: alice.password
        session[:user_id].should == alice.id
      end

      it 'redirects to the home path' do
        alice = Fabricate(:user)
        post :create, email:alice.email, password: alice.password
        response.should redirect_to home_path
      end

      it 'flashes the notice' do
        alice = Fabricate(:user)
        post :create, email:alice.email, password: alice.password
        flash[:notice].should_not be_blank
      end
    end

    context 'Invalid creadentials' do
      it 'redirects to the signin path' do
        alice = Fabricate(:user)
        post :create, email: 'eduardo@gmail.com', password: 'somepaswword'
        response.should redirect_to signin_path
      end
      it 'sets the notices' do
        alice = Fabricate(:user)
        post :create, email: 'eduardo@gmail.com', password: 'somepaswword'
        flash[:notice].should_not be_blank
      end
    end
  end
  
  describe 'Get destroy' do
    it 'sets the session id to nil' do
      session[:user_id] = Fabricate(:user).id
      get :destroy
      session[:user_id].should == nil
    end

    it 'redirects to rootpath' do
      get :destroy
      response.should redirect_to root_path 
    end
  end
end
