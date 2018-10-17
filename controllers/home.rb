# frozen_string_literal: true

require 'roda'

module Howtosay
  # Web controller for Howtosay API
  class Api < Roda
    route('home') do |routing|
      @home_route = "#{@api_root}/home"
      routing.on String do |email|
        # GET api/v1/home/[email]
        routing.get do
          begin
            homepage = Homepage.new(email: email)
            homepage ? homepage.to_json() : raise('Homepage not found')
          rescue StandardError => error
            routing.halt 404, { message: error.message }.to_json
          end
        end
      end
    end
  end
end