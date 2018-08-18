# frozen_string_literal: true

require 'json'
require 'sequel'

module Howtosay
  # Models a Question
  class Question < Sequel::Model
    many_to_one :cate
    many_to_one :source
    one_to_many :goodquestions
    one_to_many :gooddetails

    plugin :timestamps

    # rubocop:disable MethodLength
    def to_json(options = {})
      JSON(
        {
          type: 'question',
          id: id,
          cate: cate,
          source: source,
          content: content
        }, options
      )
    end
    # rubocop:enable MethodLength
  end
end