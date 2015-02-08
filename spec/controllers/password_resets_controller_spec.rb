require 'spec_helper'

describe PasswordResetsController do
  describe 'GET show' do
    it 'displays the reset pasword page if the token is valid' do
      alice = Fabricate(:user)
      get :show, id: alice.token  
      expect(response).to render_template :show
    end

    it 'sets a token to track the user' do
      alice = Fabricate(:user)
      get :show, id: alice.token  
      expect(assigns(:token)).to eq(alice.token)
    end

    it 'redirects to the expired token page if the token is invalid' do
      get :show, id: '3lkjfslkf'
      expect(response).to redirect_to expired_token_path
    end
  end

  describe 'POST create' do
    context 'valid token' do
      it 'redirects to the signin page' do
        alice = Fabricate(:user, password: 'old_password')
        post :create, token: alice.token, password: 'new_pasword'
        expect(response).to redirect_to signin_path
      end

      it 'updates the user password' do
        alice = Fabricate(:user, password: 'old_password')
        post :create, token: alice.token, password: 'new_password'
        expect(alice.reload.authenticate('new_password')).to be_true
      end

      it 'sets the flash success message' do
        alice = Fabricate(:user, password: 'old_password')
        post :create, token: alice.token, password: 'new_password'
        expect(flash[:notice]).to be_present
      end

      it 'regenerates the user token' do
        alice = Fabricate(:user, password: 'old_password')
        alice.update_column(:token, '12345')
        post :create, token: alice.token, password: 'new_password'
        expect(alice.reload.token).not_to eq('12345')
      end
    end 

    context 'invalid token' do
      it 'redirects to the expired token path' do
        post :create, token: '12345', password: 'some_password'
        expect(response).to redirect_to expired_token_path
      end
    end
  end
end
