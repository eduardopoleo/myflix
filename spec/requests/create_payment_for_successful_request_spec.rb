require 'spec_helper'

describe "Create payments on successful charge" do
  let(:event_data) do
    {
    "id" => "evt_15h8i8KoSw2hrlQeVpYKLNgG",
    "created" => 1426552652,
    "livemode" => false,
    "type" => "charge.succeeded",
    "data" => {
      "object" => {
        "id" => "ch_15h8i8KoSw2hrlQeq9MZaYBZ",
        "object" => "charge",
        "created" => 1426552652,
        "livemode" => false,
        "paid" => true,
        "status" => "succeeded",
        "amount" => 999,
        "currency" => "usd",
        "refunded" => false,
        "source" => {
          "id" => "card_15h8i7KoSw2hrlQeKuWBU76i",
          "object" => "card",
          "last4" => "4242",
          "brand" => "Visa",
          "funding" => "credit",
          "exp_month" => 10,
          "exp_year" => 2015,
          "fingerprint" => "yVufS9dNGxll2kqT",
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
          "customer" => "cus_5suXMRv9oPbV7R"
        },
        "captured" => true,
        "balance_transaction" => "txn_15h8i8KoSw2hrlQen2Y9sxqD",
        "failure_message" => nil,
        "failure_code" => nil,
        "amount_refunded" => 0,
        "customer" => "cus_5suXMRv9oPbV7R",
        "invoice" => "in_15h8i8KoSw2hrlQeyAviaYmR",
        "description" => nil,
        "dispute" => nil,
        "metadata" => {},
        "statement_descriptor" => "Myflix fee",
        "fraud_details" => {},
        "receipt_email" => nil,
        "receipt_number" => nil,
        "shipping" => nil,
        "refunds" => {
          "object" => "list",
          "total_count" => 0,
          "has_more" => false,
          "url" => "/v1/charges/ch_15h8i8KoSw2hrlQeq9MZaYBZ/refunds",
          "data" => []
        }
      }
    },
    "object" => "event",
    "pending_webhooks" => 1,
    "request" => "iar_5suXcAzpmsjSEx",
    "api_version" => "2015-02-18"
    }
  end

  it "creates a payment with the webhook for successful charge", :vcr do
    post "/stripe_events", event_data
    expect(Payment.count).to eq(1)
  end

  it "creates the payment associated with user", :vcr do
    alice = Fabricate(:user, customer_token: "cus_5suXMRv9oPbV7R")
    post "/stripe_events", event_data
    expect(Payment.first.user).to eq(alice)
  end

  it "creates the payment with the amount", :vcr do
    alice = Fabricate(:user, customer_token: "cus_5suXMRv9oPbV7R")
    post "/stripe_events", event_data
    expect(Payment.first.amount).to eq(999)
  end

  it "creates the payment with the amount", :vcr do
    alice = Fabricate(:user, customer_token: "cus_5suXMRv9oPbV7R")
    post "/stripe_events", event_data
    expect(Payment.first.reference_id).to eq("ch_15h8i8KoSw2hrlQeq9MZaYBZ")
  end 
end
