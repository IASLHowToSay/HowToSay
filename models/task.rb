# frozen_string_literal: true

require 'json'
require 'sequel'

module Howtosay
  # Models a Task
  class Task < Sequel::Model
    
    many_to_one :account
    many_to_one :question

    plugin :timestamps
    
    def to_h
        {
          type: 'task',
          account_id: account_id,
          question_id: question_id,
          sequence: sequence,
          complete: complete
        }
    end
  
    def to_json(options = {})
      JSON(to_h, options)
    end
  end
end