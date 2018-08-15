# frozen_string_literal: true

require 'json'
require 'sequel'

module Howtosay
  # Models a Cate_Detail
  class Tip < Sequel::Model
    one_to_many :questions

    plugin :timestamps

    # rubocop:disable MethodLength
    def to_json(options = {})
      JSON(
        {
          data: {
            type: 'tip',
            attributes: {
              id: id,
              description: description
            }
          },
        }, options
      )
    end
    # rubocop:enable MethodLength
  end
end