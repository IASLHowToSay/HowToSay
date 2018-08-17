# frozen_string_literal: true

require 'json'
require 'sequel'

module Howtosay
  # Models a Account
  class Account < Sequel::Model

    many_to_one :organization
    
    plugin :timestamps

    def to_h
        {
          type: 'account',
          id: id,
          name: name,
          email: email,
          password: password,
          organization: organization,
          teacher: teacher,
          can_rewrite: can_rewrite,
          can_grade: can_grade,
          admin: admin
        }
    end
  
    def to_json(options = {})
      JSON(to_h, options)
    end
  end
end