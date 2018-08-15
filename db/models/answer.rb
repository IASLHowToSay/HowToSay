# frozen_string_literal: true

require 'json'
require 'sequel'

module Howtosay
  # Models a Cate_Detail
  class Answer < Sequel::Model
    many_to_one :question
    one_to_many :goodanswers
    many_to_one :account

    plugin :timestamps

    # rubocop:disable MethodLength
    def to_json(options = {})
      JSON(
        {
          data: {
            type: 'answer',
            attributes: {
              id: id,
              question_id: question_id,
              content: content,
              writer_id: writer_id
            }
          },
          included: {
            question: question.to_json,
            account: account.to_json
          }
        }, options
      )
    end
    # rubocop:enable MethodLength
  end
end