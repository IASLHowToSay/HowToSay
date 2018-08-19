# frozen_string_literal: true

require 'json'
require 'sequel'

module Howtosay
  # Models a Detail
  class Goodquestion < Sequel::Model
    
    many_to_one :question

    plugin :timestamps

    # rubocop:disable MethodLength
    def to_json(options = {})
      JSON(
        {
          type: 'goodquestion',
          question_id: question_id,
          writer_id: writer_id,
          good: good
        }, options
      )
    end
    # rubocop:enable MethodLength
  end
end