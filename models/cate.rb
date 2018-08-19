# frozen_string_literal: true

require 'json'
require 'sequel'

module Howtosay
  # Models a Cate
  class Cate < Sequel::Model
    one_to_many :details
    one_to_many :questions
    plugin :timestamps

    # rubocop:disable MethodLength
    def to_json(options = {})
      JSON(
        {
          type: 'cate',
          id: id,
          name: name,
          description: description
        }, options
      )
    end
    # rubocop:enable MethodLength
  end
end