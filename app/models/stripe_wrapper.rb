module StripeWrapper
  #this is just a wrapper so no need to extend from Active Record Base
  class Charge
    attr_reader :response, :status
    #This allows me this some_charge = Charge.new(some_response, some_status)
    #some_charge.response = some_response
    #some_charge.status = some_status
    #We need this methods available because the succesful and error methods use them implicitly

    def initialize(response, status)
      @response = response
      @status = status
    end
    
    def self.create(options={})
      begin
        response = Stripe::Charge.create(customer: options[:customer],
                                         amount: options[:amount],
                                         description: options[:description], 
                                         currency: 'usd',
                                         card: options[:card])
        new(response, :success)
        #This is the same as saying Charge.new, since this is a class method there is no need to write it explicitly  
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

  class Customer
    attr_accessor :response, :status

    def initialize(response, status)
      @response = response
      @status = status
    end

    def self.create(options={})
      begin
        response = Stripe::Customer.create(
          email: options[:user].email,
          card: options[:card],
          plan: 'regular'
        )
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

    def customer_token
      response.id
    end
  end
end
