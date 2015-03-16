require 'spec_helper'

describe StripeWrapper do
  let(:valid_token) do
    Stripe::Token.create(
      :card => {
        :number => '4242424242424242',
        :exp_month => 3,
        :exp_year => 2016,
        :cvc => "314"
      }
    ).id
  end

  let(:declined_token) do
    Stripe::Token.create(
      :card => {
        :number => 4000000000000002,
        :exp_month => 3,
        :exp_year => 2016,
        :cvc => "314"
      }
    ).id
  end

  describe StripeWrapper::Charge do
    context "with valid credit card", :vcr do
      it "charges the card successfully" do
        response = StripeWrapper::Charge.create(amount: 300, card: valid_token)
        expect(response).to be_successful
      end
    end

    context "with invalid credit card", :vcr do
      it 'does not charge the card' do
        response = StripeWrapper::Charge.create(amount: 300, card: declined_token)
        expect(response).not_to be_successful
      end

      it 'sets an error message' do
        response = StripeWrapper::Charge.create(amount: 300, card: declined_token)
        expect(response.error).to eq('Your card was declined.')
      end
    end

    describe StripeWrapper::Costumer, :vcr do
      describe ".create" do

        context 'with valid credit card' do
          it 'creates a customer with valid credit card info' do
            alice = Fabricate(:user)
            response = StripeWrapper::Costumer.create(
              user: alice,
              card: valid_token 
            )
            expect(response).to be_successful
          end
        end
          
        context 'with invalid credit card' do
          let(:alice) {Fabricate(:user)}

          let(:response) do 
            StripeWrapper::Costumer.create(
              user: alice,
              card: declined_token 
            )
          end

          it 'does not create a costumer with a declined card' do
            expect(response).not_to be_successful
          end

          it 'returns the error message for invalid card' do
            expect(response.error).to eq('Your card was declined.')
          end
        end
      end
    end
  end
end
