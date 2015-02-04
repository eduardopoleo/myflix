require 'spec_helper'

describe UsersController do
  describe 'GET new' do
    it 'sets the new object @user' do
      get :new
      assigns(:user).should be_new_record
      assigns(:user).should be_instance_of(User)
    end

    it 'renders the new template' do
      get :new
      response.should render_template :new
    end
  end

  describe 'POST create' do
    context 'with valid input' do
      before{post :create, user: Fabricate.attributes_for(:user)}

      it 'creates the user ' do
        User.count.should == 1
      end

      it 'redirects to the home_path' do
        response.should redirect_to home_path
      end
    end

    context 'with invalid input' do    
      before {post :create, user: {password: 'password', full_name: 'eduardo'}}
      it 'does not save the record' do
        User.count.should == 0
      end

      it 'renders the new template' do
        response.should render_template :new
      end
    end
  end

  describe 'GET show' do
    it_behaves_like 'require_sign_in' do
      let(:action) {get :show, id: 3} 
    end

    it "sets @user variable" do
      set_current_user
      alice = Fabricate(:user)
      get :show, id: alice.id
      expect(assigns(:user)).to eq(alice)
    end 

    it "renders the show template" do
      set_current_user
      user = Fabricate(:user)
      get :show, id: user.id
      expect(response).to render_template :show
    end
  end
end
