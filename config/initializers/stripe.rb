Rails.configuration.stripe = {
  :publishable_key => ENV['PUBLISHABLE_KEY'],
  :secret_key      => ENV['SECRET_KEY']
}
#These keys here allow me not having them everywhere else.
Stripe.api_key = Rails.configuration.stripe[:secret_key]

Stripe.api_key = ENV['STRIPE_API_KEY'] # Set your api key

StripeEvent.configure do |events|
  events.subscribe 'charge.succeeded' do |event|
   event.data.object 
  end
end

