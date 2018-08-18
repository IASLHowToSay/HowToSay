# frozen_string_literal: true

require 'json'
require 'sequel'
require 'account'

module Howtosay
  # Models a Answer
  class Answer < Sequel::Model
    many_to_one :question
    one_to_many :goodanswer

    plugin :timestamps

    # rubocop:disable MethodLength
    def to_json(options = {})
      JSON(
        {
          type: 'answer',
          id: id,
          question: question,
          contnet: content,
          writer_id: Howtosay::Account.where(id:writer_id).all[0]
        }, options
      )
    end
    # rubocop:enable MethodLength
  end
end