# frozen_string_literal: true

require 'json'
require 'sequel'

module Howtosay
  # Models a Cate_Detail
  class Detail < Sequel::Model
    many_to_one :cate
    one_to_many :questions

    plugin :timestamps

    # rubocop:disable MethodLength
    def to_json(options = {})
      JSON(
        {
          data: {
            type: 'detail',
            attributes: {
              id: id,
              name: name,
              cate_id: cate_id,
              description: description
            }
          },
          included: {
            cate: cate.to_json
          }
        }, options
      )
    end
    # rubocop:enable MethodLength
  end
end