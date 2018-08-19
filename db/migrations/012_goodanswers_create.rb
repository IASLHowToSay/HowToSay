# frozen_string_literal: true

require 'sequel'

Sequel.migration do
  change do
    create_table(:goodanswers) do

      foreign_key :answer_id, :answers, :null=>false
      foreign_key :grade_id, table: :accounts, :null=>false

      primary_key [:answer_id, :grade_id]

      Boolean :good
      
      DateTime :created_at
      DateTime :updated_at
      
      index [:answer_id, :grade_id]

    end
  end
end