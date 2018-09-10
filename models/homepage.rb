# frozen_string_literal: true

require_relative 'organization'
require_relative 'system'


module Howtosay
  # Behaviors of the get home page
  class Homepage

    def initialize()
      @os = Organization.all
      @os.map! do |o|
        o.to_h
      end
    end

    def to_json(options = {})
      JSON(@os, options)
    end
  end
end
