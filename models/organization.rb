# frozen_string_literal: true

require 'json'
require 'sequel'

module Howtosay
  # Models a System
  class Organization < Sequel::Model
    
    one_to_many :accounts

    plugin :timestamps
    
    def to_h
        {
          type: 'organization',
          id: id,
          name: name
        }
    end
  
    def to_json(options = {})
      JSON(to_h, options)
    end
  end
end