# frozen_string_literal: true

require 'roda'

module Howtosay
  # Web controller for Credence API
  class Api < Roda
    plugin :halt
    plugin :multi_route

    MUTEX = Mutex.new

    def secure_request?(routing)
      routing.scheme.casecmp(Api.config.SECURE_SCHEME).zero?
    end

    def sync
      MUTEX.synchronize{yield}
    end

    route do |routing|
      response['Content-Type'] = 'application/json'
      
      secure_request?(routing) ||
        routing.halt(403, { message: 'TLS/SSL Requested' }.to_json)
      
      routing.root do
        { message: 'HowtosayAPI up at /api/v1' }.to_json
      end

      routing.on 'api' do
        routing.on 'v1' do
          @api_root = 'api/v1'
          routing.multi_route
        end
      end
    end
  end
end
