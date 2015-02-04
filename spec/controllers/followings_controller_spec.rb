require 'spec_helper'

describe FollowingsController do
  describe 'GET index' do
    it 'renders the followings/index template' do
      alice = Fabricate(:user)
      get :index, user_id: alice.id
      expect(response).to render_template 'index'
    end

    it 'sets the @user variable corresponding to the user followings' do
      alice = Fabricate(:user)
      get :index, user_id: alice.id
      expect(assigns(:user)).to eq(alice)
    end

    it 'sets the @followings variables with the all the corresponding user followings' do
      alice = Fabricate(:user)
      jose = Fabricate(:user)
      carlos = Fabricate(:user)
      following1 = Fabricate(:following, user_id: alice.id, subject_id: jose.id)
      following2 = Fabricate(:following, user_id: alice.id, subject_id: carlos.id)
      get :index, user_id: alice.id
      expect(assigns(:followings)).to eq(alice.followings)
    end

    it 'redirects to the singin path if the user is not authenticated'
  end
end
