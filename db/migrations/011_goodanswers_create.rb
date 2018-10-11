# frozen_string_literal: true

require 'sequel'

Sequel.migration do
  change do
    create_table(:goodanswers) do
      
      primary_key :id

      Integer :answer_id, null: false
      Integer :grader_id, null: false
      Boolean :good
  
      foreign_key [:answer_id], :answers
      foreign_key [:grader_id], table: :accounts
      
      DateTime :created_at
      DateTime :updated_at

    end
  end
end