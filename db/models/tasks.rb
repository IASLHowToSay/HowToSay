# frozen_string_literal: true

require 'json'
require 'sequel'

module Howtosay
  # Models a Cate_Detail
  class Task < Sequel::Model
    many_to_one :account
    many_to_one :question

    plugin :timestamps

    # rubocop:disable MethodLength
    def to_json(options = {})
      JSON(
        {
          data: {
            type: 'task',
            attributes: {
              id: id,
              account_id: account_id,
              question_id: question_id,
              sequence: sequence,
              complete: complete
            }
          },
          included: {
            account: account.to_json,
            question: question.to_json
          }
        }, options
      )
    end
    # rubocop:enable MethodLength
  end
end