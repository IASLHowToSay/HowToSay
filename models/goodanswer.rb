# frozen_string_literal: true

require 'json'
require 'sequel'

module Howtosay
  # Models a Detail
  class Goodanswer < Sequel::Model
    
    many_to_one :answer

    plugin :timestamps

    # rubocop:disable MethodLength
    def to_json(options = {})
      JSON(
        {
          type: 'goodanswer',
          answer_id: answer_id,
          grader_id: grader_id,
          good: good
        }, options
      )
    end
    # rubocop:enable MethodLength
  end
end