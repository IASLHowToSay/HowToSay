# frozen_string_literal: true

require 'roda'
require 'json'


module Howtosay
  # Web controller for Credence API
  class Api < Roda
    plugin :halt

    route do |routing|
      response['Content-Type'] = 'application/json'

      routing.root do
        { message: 'HowtosayAPI up at /api/v1' }.to_json
      end

      routing.on 'api' do
        routing.on 'v1' do
          @api_root = "api/v1"

          routing.on 'cates' do
            @cate_route = "#{@api_root}/cates"
            cates = Cate.all
          rescue StandardError => error
            routing.halt 404, { message: error.message }.to_json
          end
        end
      end
    end
  end
end