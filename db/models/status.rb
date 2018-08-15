# frozen_string_literal: true

require 'json'
require 'sequel'

module Howtosay
  # Models a Cate_Detail
  class Status < Sequel::Model

    plugin :timestamps

    # rubocop:disable MethodLength
    def to_json(options = {})
      JSON(
        {
          data: {
            type: 'status',
            attributes: {
              id: id,
              can_rewrite: can_rewrite
            }
          },
        }, options
      )
    end
    # rubocop:enable MethodLength
  end
end