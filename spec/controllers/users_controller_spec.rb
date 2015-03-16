require 'spec_helper'

describe UsersController do
  describe 'GET new' do
    it 'sets the new object @user' do
      get :new
      expect(assigns(:user)).to be_new_record
      expect(assigns(:user)).to be_instance_of(User)
    end

    it 'renders the new template' do
      get :new
      expect(response).to render_template :new
    end
  end

  describe 'POST create' do
    context 'successful user signup' do
      before do
        response = double(:signup_result, status: :success)
        UserSignup.any_instance.should_receive(:sign_up).and_return(response)
        post :create, user: Fabricate.attributes_for(:user)
      end

      it 'redirects to the signin path' do
        expect(response).to redirect_to signin_path
      end
      
      it 'set a flash success message' do
        expect(flash[:success]).to be_present
      end
    end

    context 'with unsuccessful signup' do
      before do
        response = double(:signup_result, status: :failed)
        UserSignup.any_instance.should_receive(:sign_up).and_return(response)
        response.stub(:error_message).and_return("There is a problem with your signin")
        post :create, user: Fabricate.attributes_for(:user)
      end

      it 'reders the new template' do
        expect(response).to render_template :new
      end

      it 'reders the new template' do
        expect(flash[:error]).to be_present
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

  describe 'POST invited_user' do
    let(:invitation) {Fabricate(:invitation)}

    it 'sets the new user instance variable with the invitation instance variables' do
      get :invited_user, token: invitation.token
      expect(assigns(:user).email).to eq(invitation.guest_email) 
    end

    it 'sets token variable' do
      get :invited_user, token: invitation.token
      expect(assigns(:token)).to eq(invitation.token)
    end

    it 'renders the new template' do
      get :invited_user, token: invitation.token
      expect(response).to render_template(:new)
    end
  end
end
