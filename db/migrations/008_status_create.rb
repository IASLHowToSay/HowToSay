# frozen_string_literal: true

require 'sequel'

Sequel.migration do
  change do
    create_table(:status) do
      
      primary_key :id

      Boolean :can_rewrite, default: true # true:rewrite false:grade

      DateTime :created_at
      DateTime :updated_at
    end
  end
end