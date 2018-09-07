# frozen_string_literal: true

require_relative 'organization'
require_relative 'system'


module Howtosay
  # Behaviors of the get register page
  class Registerpage

    def initialize()
      @os = Organization.all
      @os.map! do |o|
        o.to_h
      end
      @s = System.first.to_h

      @info = {
        organizations: @os,
        system: @s
      }
    end

    def to_json(options = {})
      JSON(@info, options)
    end
  end
end
