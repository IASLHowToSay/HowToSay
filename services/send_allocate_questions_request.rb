# frozen_string_literal: true

require 'http'

module Howtosay
  # send allocate questions post
  class SendAllocateQuestionsRequest
    class SendAllocateQuestionsRequestError < StandardError; end

    def initialize(address)
      @address = address
    end

    def call()
      response = HTTP.post(@address)
      # puts response.code
      raise(SendAllocateQuestionsRequestError) unless response.code == 201
    end
  end
end