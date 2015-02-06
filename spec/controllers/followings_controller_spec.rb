require 'spec_helper'

describe FollowingsController do
  describe 'GET index' do
    let(:alice) {Fabricate(:user)}
    before{session[:user_id] = alice.id}

    it 'renders the followings/index template' do
      get :index, user_id: alice.id
      expect(response).to render_template 'index'
    end

    it 'sets the @user variable corresponding to the user followings' do
      get :index, user_id: alice.id
      expect(assigns(:user)).to eq(alice)
    end

    it 'sets the @followings variables with the all the corresponding user followings' do
      jose = Fabricate(:user)
      carlos = Fabricate(:user)
      following1 = Fabricate(:following, user_id: alice.id, subject_id: jose.id)
      following2 = Fabricate(:following, user_id: alice.id, subject_id: carlos.id)
      get :index, user_id: alice.id
      expect(assigns(:followings)).to eq(alice.followings)
    end

    it 'orders the followings such that last followings shows first' do
      jose = Fabricate(:user)
      carlos = Fabricate(:user)
      following1 = Fabricate(:following, user_id: alice.id, subject_id: jose.id)
      following2 = Fabricate(:following, user_id: alice.id, subject_id: carlos.id)
      get :index, user_id: alice.id
      expect(assigns(:followings)).to eq([following2, following1])
    end

    it_behaves_like 'require_sign_in' do
      let(:user) {Fabricate(:user)}
      let(:action) {get :index, user_id: alice.id} 
    end
  end

  describe 'POST create' do
    let(:alice) {Fabricate(:user)}
    before{session[:user_id] = alice.id}

    it 'redirects to the index action' do
      joe  = Fabricate(:user)
      post :create, subject_id: joe.id 
      expect(response).to redirect_to(user_followings_path(alice))
    end

    it 'creates a following' do
      joe  = Fabricate(:user)
      post :create, subject_id: joe.id 
      expect(Following.count).to eq(1)
    end

    it 'creates a following related with the current user' do
      joe  = Fabricate(:user)
      post :create, subject_id: joe.id 
      expect(Following.first.user).to eq(alice)
    end

    it 'creates a following related with a subject' do
      joe  = Fabricate(:user)
      post :create, subject_id: joe.id 
      expect(Following.first.subject).to eq(joe)
    end

    it 'sets a flash message if the following is succesfully created' do
      joe  = Fabricate(:user)
      post :create, subject_id: joe.id 
      expect(flash[:notice]).to be_present
    end

    it 'does not follow the same subject twice' do
      joe  = Fabricate(:user)
      Fabricate(:following, user_id: alice.id, subject_id: joe.id)
      post :create, subject_id: joe.id 
      expect(Following.count).to eq(1)
    end

    it 'does not allow current user to follow himself' do
      post :create, subject_id: alice.id 
      expect(Following.count).to eq(0)
    end

    it 'sets a flash message if the following is succesfully created' do
      joe  = Fabricate(:user)
      Fabricate(:following, user_id: alice.id, subject_id: joe.id)
      post :create, subject_id: joe.id 
      expect(flash[:error]).to be_present
    end

    it_behaves_like 'require_sign_in' do
      let(:user) {Fabricate(:user)}
      let(:action) {post :create, user_id: alice.id, subject_id: user.id} 
    end
  end

  describe 'DELETE destroy' do
    let(:alice) {Fabricate(:user)}
    before{session[:user_id] = alice.id}

    it 'destroy the following' do
      joe  = Fabricate(:user)
      following = Fabricate(:following, user_id: alice.id, subject_id: joe.id)
      delete :destroy, id: following.id 
      expect(Following.count).to eq(0)
    end

    it 'sets a flash message' do
      joe  = Fabricate(:user)
      following = Fabricate(:following, user_id: alice.id, subject_id: joe.id)
      delete :destroy, id: following.id 
      expect(flash[:notice]).to be_present
    end

    it 'redirect to the user_followings_path' do
      joe  = Fabricate(:user)
      following = Fabricate(:following, user_id: alice.id, subject_id: joe.id)
      delete :destroy, id: following.id 
      expect(response).to redirect_to user_followings_path(alice)
    end

    it 'does not delete the following if the user is not the owner of the following' do
      joe  = Fabricate(:user)
      ricardo = Fabricate(:user)
      following = Fabricate(:following, user_id: joe.id, subject_id: ricardo.id)
      delete :destroy, id: following.id 
      expect(Following.count).to eq(1)
    end
  end
end
