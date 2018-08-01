# frozen_string_literal: true

require 'roda'
require 'json'

# require_relative 'config/environments'
# require_relative 'models/init'

module Howtosay
  # Web controller for HOWTOSAY API
  class Api < Roda
    plugin :halt

    route do |routing|
      response['Content-Type'] = 'application/json'

      routing.root do
        { message: 'HOWTOSAY API up at /api/v1' }.to_json
      end

      routing.on 'api' do
        routing.on 'v1' do
          @api_root = "api/v1"
          routing.on 'test' do
            { message: 'HOWTOSAY test API up at /api/v1' }.to_json
          end
        end
      end
    end
  end
end