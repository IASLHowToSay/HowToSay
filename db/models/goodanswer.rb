# frozen_string_literal: true

require 'json'
require 'sequel'

module Howtosay
  # Models a Account
  class Goodanswer < Sequel::Model
    many_to_one :answer

    plugin :timestamps

    # rubocop:disable MethodLength
    def to_json(options = {})
      JSON(
        {
          data: {
            type: 'goodanswer',
            attributes: {
              id: id,
              answer_id: answer_id,
              account_id: account_id,
              good: good
            }
          },
          included: {
            answer: answer.to_json
          }
        }, options
      )
    end
    # rubocop:enable MethodLength
  end
end