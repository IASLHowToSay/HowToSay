# frozen_string_literal: true

require 'json'
require 'sequel'

module Howtosay
  # Models a Detail
  class Detail < Sequel::Model
    many_to_one :cate

    plugin :timestamps

    # rubocop:disable MethodLength
    def to_json(options = {})
      JSON(
        {
          type: 'detail',
          id: id,
          name: name,
          cate_id: cate_id,
          description: description
        }, options
      )
    end
    # rubocop:enable MethodLength
  end
end