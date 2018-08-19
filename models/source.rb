# frozen_string_literal: true

require 'json'
require 'sequel'

module Howtosay
  # Models a Source
  class Source < Sequel::Model
    
    one_to_many :questions

    plugin :timestamps

    # rubocop:disable MethodLength
    def to_json(options = {})
      JSON(
        {
          type: 'source',
          id: id,
          name: name
        }, options
      )
    end
    # rubocop:enable MethodLength
  end
end