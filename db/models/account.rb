# frozen_string_literal: true

require 'json'
require 'sequel'

module Howtosay
  # Models a Account
  class Account < Sequel::Model
    one_to_many :tasks
    one_to_many :answers

    plugin :timestamps

    # rubocop:disable MethodLength
    def to_json(options = {})
      JSON(
        {
          data: {
            type: 'account',
            attributes: {
              id: id,
              name: name,
              email: email,
              password: password,
              teacher: teacher,
              can_rewrite: can_rewrite
            }
          },
        }, options
      )
    end
    # rubocop:enable MethodLength
  end
end