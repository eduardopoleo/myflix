require 'spec_helper'

describe "Create payment for successfull request" do
  let(:event_data) do 
    {
      "id" => "ch_15h6UuKoSw2hrlQe9Rn7eNYl",
      "object"=> "charge",
      "created"=> 1426544144,
      "livemode"=> false,
      "paid"=> true,
      "status"=> "succeeded",
      "amount"=> 999,
      "currency"=> "usd",
      "refunded"=> false,
      "source"=>
      {
        "id"=> "card_15h6UtKoSw2hrlQe6ULXaBCr",
        "object"=> "card",
        "last4"=> "4242",
        "brand"=> "Visa",
        "funding"=> "credit",
        "exp_month"=> 10,
        "exp_year"=> 2015,
        "fingerprint"=> "yVufS9dNGxll2kqT",
        "country"=> "US",
        "name"=> nil,
        "address_line1"=> nil,
        "address_line2"=> nil,
        "address_city"=> nil,
        "address_state"=> nil,
        "address_zip"=> nil,
        "address_country"=> nil,
        "cvc_check"=> "pass",
        "address_line1_check"=> nil,
        "address_zip_check"=> nil,
        "dynamic_last4"=> nil,
        "metadata"=>
        {},
        "customer"=> "cus_5ssFQDk9KejMyr"
        },
      "captured"=> true,
      "balance_transaction"=> "txn_15h6UuKoSw2hrlQegxcXALF7",
      "failure_message"=> nil,
      "failure_code"=> nil,
      "amount_refunded"=> 0,
      "customer"=> "cus_5ssFQDk9KejMyr",
      "invoice"=> "in_15h6UuKoSw2hrlQekrjUqsgS",
      "description"=> nil,
      "dispute"=> nil,
      "metadata"=>
      {},
      "statement_descriptor"=> "Myflix fee",
      "fraud_details"=>
      {},
      "receipt_email"=> nil,
      "receipt_number"=> nil,
      "shipping"=> nil,
      "refunds"=>
      {
        "object"=> "list",
        "total_count"=> 0,
        "has_more"=> false,
        "url"=> "/v1/charges/ch_15h6UuKoSw2hrlQe9Rn7eNYl/refunds",
        "data"=>
        []
      }
    }
  end

  it 'it creates a payment with the webhook', :vcr do
    post "/stripe_events", event_data
    expect(Payment.count).to eq(1)
  end
end
