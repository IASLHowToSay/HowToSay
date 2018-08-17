# frozen_string_literal: true

require 'sequel'

Sequel.migration do
  change do
    create_table(:goodanswers) do
      primary_key :answer_id

      Integer :grader_id, null: false
      Boolean :good
      
      DateTime :created_at
      DateTime :updated_at

      foreign_key [:answer_id], table: :answers
      foreign_key [:grader_id], table: :accounts

    end
  end
end