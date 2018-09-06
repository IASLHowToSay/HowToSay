
require 'roda'

module Howtosay
  # Web controller for Howtosay API
  class Api < Roda
    route('accounts') do |routing|
      @account_route = "#{@api_root}/accounts"
      
      routing.on 'authenticate' do 
        routing.route('authenticate', 'accounts')
      end

      routing.on String do |email|
        # GET api/v1/accounts/[email]
        routing.get do
          account = Account.first(email: email)
          account ? account.to_json : raise('Account not found')
        rescue StandardError => error
          routing.halt 404, { message: error.message }.to_json
        end
      end


      # POST api/v1/accounts
      routing.post do
        new_data = JSON.parse(routing.body.read)
        new_account = Account.new(new_data)
        raise('Could not save account') unless new_account.save

        response.status = 201
        response['Location'] = "#{@account_route}/#{new_account.id}"
        { message: 'Account saved', data: new_account }.to_json
      rescue Sequel::MassAssignmentRestriction
        routing.halt 400, { message: 'Illegal Request' }.to_json
      rescue StandardError => error
        puts error.inspect
        routing.halt 500, { message: error.message }.to_json
      end

    end
  end
end