# frozen_string_literal: true

require 'sequel'

Sequel.migration do
  change do
    create_table(:goodanswers) do
      primary_key :id

      Integer :answer_id, null: false
      Integer :account_id, null: false
      String :good, null: false

      DateTime :created_at
      DateTime :updated_at
      
    end
  end
end