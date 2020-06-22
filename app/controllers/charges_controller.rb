class ChargesController < ApplicationController

    def charge_card
  
      # Create an instance of the API Client and initialize it with the credentials
      # for the Square account whose assets you want to manage.
      api_client = Square::Client.new(
        access_token: "EAAAEKOYkzsENSH7BanFgLVh-U3Kbkuaj-2Hf2ju2LR85EuPuvX8bEb7iathafMM",
        environment: 'sandbox' 
      )
  
      # To learn more about splitting payments with additional recipients,
      # see the Payments API documentation on our [developer site]
      # (https://developer.squareup.com/docs/payments-api/overview).
      # Charge 1 dollar (100 cent)
      puts "NONCE: #{params[:nonce]}"
      puts "AMOUNT: #{params[:amount]}"

      request_body = {
        :source_id => params[:nonce],
        :amount_money => {
          :amount => params[:amount],
          :currency => 'USD'
        },
        :idempotency_key => SecureRandom.uuid
      }
  
      resp = api_client.payments.create_payment(body: request_body)
      if resp.success?
        @payment = resp.data.payment
        render json: { success: true }
        
      else
        @error = resp.errors
        render json: { success: false }
      end
    end
    
end