# frozen_string_literal: true

require 'json'
require 'sequel'

module Howtosay
  # Models a Account
  class Goodquestion < Sequel::Model
    many_to_one :question

    plugin :timestamps

    # rubocop:disable MethodLength
    def to_json(options = {})
      JSON(
        {
          data: {
            type: 'goodquestion',
            attributes: {
              id: id,
              question_id: question_id,
              account_id: account_id,
              good: good
            }
          },
          included: {
            question: question.to_json,
          }
        }, options
      )
    end
    # rubocop:enable MethodLength
  end
end