# frozen_string_literal: true

require 'sequel'

Sequel.migration do
  change do
    create_table(:goodquestions) do
      primary_key :id

      Integer :question_id, null: false
      Integer :account_id, null: false
      String :good, null: false

      DateTime :created_at
      DateTime :updated_at
      
    end
  end
end