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
    context 'with valid user information input' do
      context 'with valid payment input' do
        before do
          charge = double('charge')
          StripeWrapper::Charge.should_receive(:create).and_return(charge)
          #calling stub implies that calling :create is optional, but in this case it is mandatory.
          # setting the should_receive expectation ensures that this actually takes place
          charge.stub(:successful?).and_return(true)
        end

        it 'creates the user ' do
          post :create, user: Fabricate.attributes_for(:user)
          User.count.should == 1
        end

        it 'redirects to the home_path' do
          post :create, user: Fabricate.attributes_for(:user)
          response.should redirect_to home_path
        end

        it 'if there is token the user should follow the guest' do
          alice = Fabricate(:user)
          invitation = Fabricate(:invitation, user: alice)
          post :create, user: {email: invitation.guest_email, full_name: invitation.guest_name, password: "password"}, token: invitation.token
          expect(alice.subjects.first).to eq(User.find_by_email(invitation.guest_email))
        end

        it 'if there is token the guest should follow the user who invited' do
          alice = Fabricate(:user)
          invitation = Fabricate(:invitation, user: alice)
          post :create, user: {email: invitation.guest_email, full_name: invitation.guest_name, password: "password"}, token: invitation.token
          expect(User.find_by_email(invitation.guest_email).subjects.first).to eq(alice)
        end

        it 'should set the inviation token to nil after the guest signs up' do
          alice = Fabricate(:user)
          invitation = Fabricate(:invitation, user: alice)
          post :create, user: {email: invitation.guest_email, full_name: invitation.guest_name, password: "password"}, token: invitation.token
          expect(invitation.reload.token).to eq(nil)
        end
      end

      context 'with invalid payment input' do
        before do
          charge = double('charge')
          StripeWrapper::Charge.stub(:create).and_return(charge)
          charge.stub(:successful?).and_return(false)
          charge.stub(:error).and_return("Your card was declined.")
        end

        it 'does not create a new user the record' do
          post :create, user: Fabricate.attributes_for(:user)
          expect(User.count).to eq(0)
        end

        it 'redirects to the register path' do
          post :create, user: Fabricate.attributes_for(:user)
          expect(response).to redirect_to register_path
        end

        it 'set a flash error message' do
          post :create, user: Fabricate.attributes_for(:user)
          expect(flash[:error]).to eq('Your card was declined.')
        end
      end
    end

    context 'with invalid user information input' do    
      before {post :create, user: {password: 'password', full_name: 'eduardo'}}
      it 'does not save the record' do
        User.count.should == 0
      end

      it 'renders the new template' do
        response.should render_template :new
      end

      it 'it does not charge the card' do
        StripeWrapper::Charge.should_not_receive(:create)
      end
    end
    
    context 'sending emails' do
      after{ActionMailer::Base.deliveries.clear}
      context "with valid input" do
        before do
          charge = double('charge')
          StripeWrapper::Charge.should_receive(:create).and_return(charge)
          charge.stub(:successful?).and_return(true)
        end

        it 'sends out email with valid input' do
          post :create, user: Fabricate.attributes_for(:user)
          ActionMailer::Base.deliveries.should_not be_empty
        end

        it 'sends out to the right recipient' do
          post :create, user: Fabricate.attributes_for(:user)
          message =  ActionMailer::Base.deliveries.last
          message.to.should == [User.first.email]
        end

        it 'has the right content' do
          post :create, user: Fabricate.attributes_for(:user)
          message =  ActionMailer::Base.deliveries.last
          message.body.should include("#{User.first.full_name}") 
        end
      end

      context "with invalid input" do
        before {ActionMailer::Base.deliveries.clear}
        it 'does not send out email with invalid input' do
          post :create, user: {email: "", password: "someting", full_name: 'Joe'} 
          message =  ActionMailer::Base.deliveries
          expect(message).to be_empty
        end
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
