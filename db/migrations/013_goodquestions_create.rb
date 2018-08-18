# frozen_string_literal: true

require 'sequel'

Sequel.migration do
  change do
    create_table(:goodquestions) do

      foreign_key :question_id, :questions, :null=>false
      foreign_key :writer_id, table: :accounts, :null=>false

      primary_key [:question_id, :writer_id]

      Boolean :good
      
      DateTime :created_at
      DateTime :updated_at
      
      index [:question_id, :writer_id]
    end
  end
end