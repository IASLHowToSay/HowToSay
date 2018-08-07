# frozen_string_literal: true

require 'json'
require 'sequel'

module Howtosay
  # Models a Cate_Detail
  class Cate_Detail < Sequel::Model
    one_to_many :cate_details

    plugin :timestamps

    # rubocop:disable MethodLength
    def to_json(options = {})
      JSON(
        {
          data: {
            type: 'cate',
            attributes: {
              id: id,
              name: name
            }
          },
          included: {
            cate_detail: cate_details
          }
        }, options
      )
    end
    # rubocop:enable MethodLength
  end
end