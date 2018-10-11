# frozen_string_literal: true

require 'json'
require 'sequel'

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
          rewriter: Howtosay::Account.where(id:rewriter_id).first
        }, options
      )
    end
    # rubocop:enable MethodLength
  end
end