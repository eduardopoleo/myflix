require 'spec_helper'

describe PasswordResetsController do
  describe 'GET show' do
    it 'displays the reset pasword page if the token is valid' do
      alice = Fabricate(:user)
      get :show, id: alice.token  
      expect(response).to render_template :show
    end

    it 'redirects to the expired token page if the token is invalid' do
      get :show, id: '3lkjfslkf'
      expect(response).to redirect_to expired_token_path
    end
  end
end
