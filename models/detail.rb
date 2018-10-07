# frozen_string_literal: true

require 'json'
require 'sequel'

module Howtosay
  # Models a Detail
  class Detail < Sequel::Model
    many_to_one :cate

    plugin :timestamps

    def to_h
      {
        type: 'detail',
        id: id,
        name: name,
        cate_id: cate_id,
        description: description
      }
    end

    # rubocop:disable MethodLength
    def to_json(options = {})
      JSON(to_h, options)
    end
    # rubocop:enable MethodLength
  end
end