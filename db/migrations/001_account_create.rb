# frozen_string_literal: true

require 'sequel'

Sequel.migration do
  change do
    create_table(:accounts) do
      primary_key :id

      String :name, unique: true, null: false 
      String :email, unique: true, null: false
      String :password
      Boolean :teacher # is teacher or student
      Boolean :can_rewrite# true:rewrite false:grade
      
      DateTime :created_at
      DateTime :updated_at
    end
  end
end