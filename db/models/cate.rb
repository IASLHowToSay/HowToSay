# frozen_string_literal: true

require 'json'
require 'sequel'

module Howtosay
  # Models a Account
  class Cate < Sequel::Model
    one_to_many :details

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