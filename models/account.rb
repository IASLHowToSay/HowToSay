# frozen_string_literal: true

require 'json'
require 'sequel'

module Howtosay
  # Models a Account
  class Account < Sequel::Model

    many_to_one :organization
    one_to_many :tasks
    
    plugin :association_dependencies, tasks: :destroy
    plugin :timestamps, update_on_create: true

    def password=(new_password)
      self.salt = SecureDB.new_salt
      self.password_hash = SecureDB.hash_password(salt, new_password)
    end
    
    # 只會回答true or false
    def password?(try_password)
      try_hashed = SecureDB.hash_password(salt, try_password)
      try_hashed == password_hash
    end

    def to_h
        {
          type: 'account',
          id: id,
          name: name,
          email: email,
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