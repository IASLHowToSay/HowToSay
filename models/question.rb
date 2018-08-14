# frozen_string_literal: true

require 'json'
require 'sequel'

module Howtosay
  # Models a Question
  class Question < Sequel::Model
    many_to_one :cate
    many_to_one :detail
    many_to_one :tip

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
            cate: cate,
            details: detail,
            tip: tip,

          }
        }, options
      )
    end
    # rubocop:enable MethodLength
  end
end