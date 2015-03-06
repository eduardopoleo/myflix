Rails.configuration.stripe = {
  :publishable_key => ENV['PUBLISHABLE_KEY'],
  :secret_key      => ENV['SECRET_KEY']
}
#These keys here allow me not having them everywhere else.

Stripe.api_key = Rails.configuration.stripe[:secret_key]
