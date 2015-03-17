require 'spec_helper'

describe 'Deactivate user on declined payments' do
  let(:event_data) do
  {
  "id" => "evt_15hT1GKoSw2hrlQel71Dsa44",
  "created" => 1426630718,
  "livemode" => false,
  "type" => "charge.failed",
  "data" => {
    "object" => {
      "id" => "ch_15hT1GKoSw2hrlQeIIGwCLk8",
      "object" => "charge",
      "created" => 1426630718,
      "livemode" => false,
      "paid" => false,
      "status" => "failed",
      "amount" => 999,
      "currency" => "cad",
      "refunded" => false,
      "source" => {
        "id" => "card_15hT0LKoSw2hrlQeb69NK1gW",
        "object" => "card",
        "last4" => "0341",
        "brand" => "Visa",
        "funding" => "credit",
        "exp_month" => 3,
        "exp_year" => 2016,
        "fingerprint" => "g5jpAGBEMYWvSSJp",
        "country" => "US",
        "name" => nil,
        "address_line1" => nil,
        "address_line2" => nil,
        "address_city" => nil,
        "address_state" => nil,
        "address_zip" => nil,
        "address_country" => nil,
        "cvc_check" => "pass",
        "address_line1_check" => nil,
        "address_zip_check" => nil,
        "dynamic_last4" => nil,
        "metadata" => {},
        "customer" => "cus_5tFUVPL2iGqaSJ"
      },
      "captured" => false,
      "balance_transaction" => nil,
      "failure_message" => "Your card was declined.",
      "failure_code" => "card_declined",
      "amount_refunded" => 0,
      "customer" => "cus_5tFUVPL2iGqaSJ",
      "invoice" => nil,
      "description" => "Payment declined",
      "dispute" => nil,
      "metadata" => {},
      "statement_descriptor" => nil,
      "fraud_details" => {},
      "receipt_email" => nil,
      "receipt_number" => nil,
      "shipping" => nil,
      "refunds" => {
        "object" => "list",
        "total_count" => 0,
        "has_more" => false,
        "url" => "/v1/charges/ch_15hT1GKoSw2hrlQeIIGwCLk8/refunds",
        "data" => []
      }
    }
  },
  "object" => "event",
  "pending_webhooks" => 1,
  "request" => "iar_5tFWuL677GSAkN",
  "api_version" => "2015-02-18"
  }
  end
  it 'deactivates the user with webhook data from stripe', :vcr do
    alice = Fabricate(:user, customer_token: "cus_5tFUVPL2iGqaSJ")
    post "stripe_events", event_data
    expect(alice.reload).not_to be_active
  end
end
