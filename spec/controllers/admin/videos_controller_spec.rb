require 'spec_helper'

describe Admin::VideosController do
  describe 'GET new' do
    
    it_behaves_like "require_sign_in" do
      let(:action) {get :new}
    end

    it 'sets the instance variable @new'do
      set_current_admin
      get :new
      expect(assigns(:video)).to be_instance_of(Video)  
      expect(assigns(:video)).to be_new_record
    end

    it 'redirects to the home page if the user is not admin' do
      set_current_user
      get :new
      expect(response).to redirect_to home_path
    end

    it 'sets a flash message to the regular user' do
      set_current_user
      get :new
      expect(flash[:error]).to be_present
    end
  end
end
