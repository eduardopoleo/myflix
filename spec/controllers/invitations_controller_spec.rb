require 'spec_helper'

describe InvitationsController do

  describe 'GET new' do
    let(:alice) {Fabricate(:user)}
    before {session[:user_id] = alice.id}

    it 'sets a new instace of invitation' do
      get :new
      expect(assigns(:invitation)).to be_a_new(Invitation)
    end

    it_behaves_like 'require_sign_in' do
      let(:action) {get :new}
    end
  end

  describe 'POST create' do
    let(:alice) {Fabricate(:user)}
    before {session[:user_id] = alice.id}

    context 'with valid input' do 
      it 'redirects to the new_invitation path' do
        post :create, invitation: {guest_name: 'Joe', guest_email: 'joe@example.com', invitation_message: 'Hey come and join me at Myflix'}
        expect(response).to redirect_to(invite_friend_path)
      end

      it 'creates an invitation' do
        post :create, invitation: {guest_name: 'Joe', guest_email: 'joe@example.com', invitation_message: 'Hey come and join me at Myflix'}
        expect(Invitation.count).to eq(1)
      end

      it 'creates an invitation associated with the current user' do
        post :create, invitation: {guest_name: 'Joe', guest_email: 'joe@example.com', invitation_message: 'Hey come and join me at Myflix'}
        expect(Invitation.first.user).to eq(alice)
      end

      it 'sends and email to a friend' do
        post :create, invitation: {guest_name: 'Joe', guest_email: 'joe@example.com', invitation_message: 'Hey come and join me at Myflix'}
        expect(ActionMailer::Base.deliveries.last.to).to eq(["joe@example.com"])
      end

      it 'sets a flash message if the invitation is sent' do
        post :create, invitation: {guest_name: 'Joe', guest_email: 'joe@example.com', invitation_message: 'Hey come and join me at Myflix'}
        expect(flash[:success]).to be_present
      end
    end

    context 'with invalid input' do
      it 'renders the new template' do
        post :create, invitation: {guest_name: "" , guest_email: 'joe@example.com', invitation_message: 'Hey come and join me at Myflix'}
        expect(response).to render_template :new
      end

      it 'does not create the invitation' do
        post :create, invitation: {guest_name: "" , guest_email: 'joe@example.com', invitation_message: 'Hey come and join me at Myflix'}
        expect(Invitation.count).to eq(0)
      end
    end

    it_behaves_like 'require_sign_in' do
      let(:action) {get :new}
    end
  end
end
