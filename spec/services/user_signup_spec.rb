require 'spec_helper'

describe UserSignup do
  describe '#signup' do
    context 'valid personal info and credit card' do
      let(:customer) {double(:customer, successful?: true, customer_token: 'abcdefg')}

      before do
        StripeWrapper::Customer.should_receive(:create).and_return(customer)
      end

      after do
        ActionMailer::Base.deliveries.clear
      end
        it 'creates a user ' do
          UserSignup.new(Fabricate.build(:user)).sign_up("some_stripe_token", nil)
          expect(User.count).to eq(1)
        end

        it 'stores the customer token from striper' do
          UserSignup.new(Fabricate.build(:user)).sign_up("some_stripe_token", nil)
          expect(User.first.customer_token).to eq('abcdefg')
        end

        it 'makes the user follow the guest' do
          alice = Fabricate(:user)
          invitation = Fabricate(:invitation, user: alice, guest_email: 'joe@example.com')
          UserSignup.new(
            Fabricate.build(:user,
                            email: 'joe@example.com',
                            password: 'password',
                            full_name: "John Doe")).sign_up("some_stripe_token", invitation.token)
          expect(alice.subjects.first).to eq(User.find_by_email(invitation.guest_email))
        end

        it 'make the guest follow the user' do
          alice = Fabricate(:user)
          invitation = Fabricate(:invitation, user: alice, guest_email: 'joe@example.com')
          UserSignup.new(
            Fabricate.build(:user,
                            email: 'joe@example.com',
                            password: 'password',
                            full_name: "John Doe")).sign_up("some_stripe_token", invitation.token)

          expect(User.find_by_email(invitation.guest_email).subjects.first).to eq(alice)
         end

        it 'expires the invitation upon acceptance' do
          alice = Fabricate(:user)
          invitation = Fabricate(:invitation, user: alice, guest_email: 'joe@example.com')
          UserSignup.new(
            Fabricate.build(:user,
                            email: 'joe@example.com',
                            password: 'password',
                            full_name: "John Doe")).sign_up("some_stripe_token", invitation.token)
          expect(invitation.reload.token).to eq(nil)
        end

        it 'sends out email with valid input' do
          UserSignup.new(Fabricate.build(:user)).sign_up("some_stripe_token", nil)
          expect(ActionMailer::Base.deliveries.last).to be_present
        end

        it 'sends out to the right recipient' do
          UserSignup.new(Fabricate.build(:user)).sign_up("some_stripe_token", nil)
          message =  ActionMailer::Base.deliveries.last
          expect(message.to).to eq([User.first.email])
        end

        it 'has the right content' do
          UserSignup.new(Fabricate.build(:user)).sign_up("some_stripe_token", nil)
          message =  ActionMailer::Base.deliveries.last
          expect(message.body).to include("#{User.first.full_name}") 
        end
      end

      context 'with valid personal info invalid credit card' do
        it 'does not create a new user the record' do
          customer = double(:customer, successful?: false, error: "Your card was declined")
          StripeWrapper::Customer.should_receive(:create).and_return(customer)
          UserSignup.new(Fabricate.build(:user)).sign_up("3424", nil)
          expect(User.count).to eq(0)
        end
      end

    context 'with invalid personal info' do
      it 'does not save the record' do
        UserSignup.new(Fabricate.build(:user, email: '')).sign_up("3424", nil)
        expect(User.count).to eq(0)
      end

      it 'does not charge the card' do
        UserSignup.new(Fabricate.build(:user, email: '')).sign_up("3424", nil)
        StripeWrapper::Customer.should_not_receive(:create)
      end

      it 'does not send out email with invalid input' do
        UserSignup.new(Fabricate.build(:user, email: '')).sign_up("3424", nil)
        message =  ActionMailer::Base.deliveries
        expect(message).to be_empty
      end
    end
  end
end
