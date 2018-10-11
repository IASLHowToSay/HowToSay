# frozen_string_literal: true

require 'json'
require 'sequel'
require_relative 'question'

module Howtosay
  # Models a Task
  class Task < Sequel::Model
    
    many_to_one :account
    many_to_one :question
    
    plugin :timestamps
    
    def to_h
        {
          type: 'task',
          task_id: id,
          cate_id: cate_id,
          account_id: account_id,
          question: Howtosay::Question.where(id: question_id).first,
          sequence: sequence,
          complete: complete
        }
    end
  
    def to_json(options = {})
      JSON(to_h, options)
    end
  end
end