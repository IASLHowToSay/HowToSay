# frozen_string_literal: true

require 'json'
require 'sequel'

module Howtosay
  # Models a Account
  class Question < Sequel::Model
    one_to_many :answers
    one_to_many :tasks
    one_to_many :goodquestions
    many_to_one :cate
    many_to_one :detail
    many_to_one :timestamps
    plugin :timestamps

    # rubocop:disable MethodLength
    def to_json(options = {})
      JSON(
        {
          data: {
            type: 'question',
            attributes: {
              id: id,
              cate_id: cate_id,
              detail_id: detail_id,
              tip_id: tip_id,
              content: content
            }
          },
          included: {
            cate: cate.to_json,
            detail: detail.to_json,
            tip: tip.to_json
          }
        }, options
      )
    end
    # rubocop:enable MethodLength
  end
end