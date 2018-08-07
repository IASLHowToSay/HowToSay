# frozen_string_literal: true

require 'sequel'

Sequel.migration do
  change do
    create_table(:suers) do
      primary_key :id

      String :name, unique: true, null: false
      String :email, unique: true, null: false
      String :password
      String :role

      DateTime :created_at
      DateTime :updated_at
    end
  end
end