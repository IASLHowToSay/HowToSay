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
          can_rewrite: can_rewrite,
          rewrite_amount: rewrite_amount,
          rewrite_people: rewrite_people,
          rewrite_description: rewrite_description,
          can_grade: can_grade,
          grade_amount: grade_amount,
          grade_people: grade_people,
          grade_description: grade_description
        }
    end
  
    def to_json(options = {})
      JSON(to_h, options)
    end
  end
end