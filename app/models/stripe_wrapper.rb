module StripeWrapper
  #this is just a wrapper so no need to extend from Active Record Base
  class Charge
    attr_reader :response, :status

    def initialize(response, status)
      @response = response
      @status = status
    end
    
    def self.create(options={})
      begin
        response = Stripe::Charge.create(customer: options[:customer], amount: options[:amount], description: options[:description], currency: 'usd', card: options[:card])
        new(response, :success)
      rescue Stripe::CardError => e
        new(e, :error)
      end
    end

    def successful?
      status == :success
    end

    def error
      response.message
    end
  end
end
