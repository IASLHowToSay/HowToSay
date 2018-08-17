# frozen_string_literal: true

require 'json'
require 'sequel'

module Howtosay
  # Models a System
  class System < Sequel::Model

    plugin :timestamps
    
    def to_h
        {
          type: 'system',
          can_register: can_register,
          can_rewrite: can_rewrite,
          can_grade: can_grade
        }
    end
  
    def to_json(options = {})
      JSON(to_h, options)
    end
  end
end