# frozen_string_literal: true

require 'roda'

module Howtosay
  # Web controller for Credence API
  class Api < Roda
    route('home') do |routing|
      @home_route = "#{@api_root}/home"
      cates = Cate.all
      s = System.first
      a = Account.first
      s.to_json
    rescue StandardError => error
      routing.halt 404, { message: error.message }.to_json
    end
  end
end