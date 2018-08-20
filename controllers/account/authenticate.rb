# frozen_string_literal: true

require 'roda'

module Howtosay
  # Web controller for Howtosay API
  class Api < Roda
    route('authenticate', 'accounts') do |routing|
      # POST /api/v1/accounts/authenticate
      routing.post do
        credentials = JsonRequestBody.parse_symbolize(request.body.read)
        auth_account = AuthenticateAccount.call(credentials)
        puts "登入："
        puts auth_account.to_json
        auth_account.to_json
      rescue UnauthorizedError => error
        puts [error.class, error.message].join ': '
        # 403 Forbidden 沒有權限訪問
        routing.halt '403', { message: 'Invalid credentials' }.to_json
      end
    end
  end
end