require 'spec_helper'

describe Admin::VideosController do
  describe 'GET new' do
    
    it_behaves_like "require_sign_in" do
      let(:action) {get :new}
    end

    it_behaves_like "require_admin" do
      let(:action) {get :new}
    end

    it 'sets the instance variable @new'do
      set_current_admin
      get :new 
      expect(assigns(:video)).to be_new_record
    end

    it 'sets a flash message to the regular user' do
      set_current_user
      get :new
      expect(flash[:error]).to be_present
    end
  end

  describe "POST create" do
    it_behaves_like "require_admin" do
      let(:action) {get :create}
    end

    it_behaves_like "require_sign_in" do
      let(:action) {get :create}
    end

    context 'with valid input' do
      it 'redirects to the new video page' do
        set_current_admin
        category = Fabricate(:category)
        post :create, video: {title: 'Some title', category_id: category.id, description: "some large description"}  
        expect(response).to redirect_to new_admin_videos_path
     end

      it 'creates the video' do
        set_current_admin
        category = Fabricate(:category)
        post :create, video: {title: 'Some title', category_id: category.id, description: "some large description"}  
        expect(Video.count).to eq(1)
      end

      it 'sets a flash success message' do
        set_current_admin
        category = Fabricate(:category)
        post :create, video: {title: 'Some title', category_id: category.id, description: "some large description"}  
        expect(flash[:success]).to be_present 
      end
    end

    context 'with invalid input' do
      it 'does not create a video' do
        set_current_admin
        category = Fabricate(:category)
        post :create, video: {category_id: category.id, description: "some large description"}
        expect(Video.count).to eq(0)
      end

      it 'renders the new video template' do
        set_current_admin
        category = Fabricate(:category)
        post :create, video: {category_id: category.id, description: "some large description"}
        expect(response).to render_template :new
      end

      it 'sets the @video variable' do
        set_current_admin
        category = Fabricate(:category)
        post :create, video: {category_id: category.id, description: "some large description"}
        expect(assigns(:video)).to be_present
      end

      it 'sets the flash error message' do
        set_current_admin
        category = Fabricate(:category)
        post :create, video: {category_id: category.id, description: "some large description"}
        expect(flash[:error]).to be_present
      end
    end
  end
end
