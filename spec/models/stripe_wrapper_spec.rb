require 'spec_helper'

describe StripeWrapper::Charge do

  let(:token) do
    Stripe::Token.create(
      :card => {
        :number => card_number,
        :exp_month => 3,
        :exp_year => 2016,
        :cvc => "314"
      },
  ).id
  end
  
  context "with valid credit card" do
    let(:card_number) {'4242424242424242'} 

    it "charges the card successfully", :vcr do
      response = StripeWrapper::Charge.create(amount: 300, card: token)
      expect(response).to be_successful
    end
  end

  context "with invalid credit card", :vcr do
    let(:card_number) {'4000000000000002'} 

    it 'does not charge the card' do
      response = StripeWrapper::Charge.create(amount: 300, card: token)
      expect(response).not_to be_successful
    end

    it 'sets an error message' do
      response = StripeWrapper::Charge.create(amount: 300, card: token)
      expect(response.error).to eq('Your card was declined.')
    end
  end
end
