# frozen_string_literal: true

module Howtosay
    # Error for invalid credentials
    class UnauthorizedError < StandardError
      def initialize(msg = nil)
        @credentials = msg
      end
  
      def message
        "Invalid Credentials for: #{@credentials[:email]}"
      end
    end
  
    # Find account and check password
    # 登入比對
    class AuthenticateAccount
      def self.call(credentials)
        account = Account.first(email: credentials[:email])
        # account.password?(credentials[:password]) -> true or false
        account.password?(credentials[:password]) ? account : raise
      rescue StandardError
        raise UnauthorizedError, credentials
      end
    end
  end