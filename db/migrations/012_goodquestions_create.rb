# frozen_string_literal: true

require 'sequel'

Sequel.migration do
  change do
    create_table(:goodquestions) do

      primary_key :id

      Integer :question_id, null: false
      Integer :writer_id, null: false
      Boolean :good

      foreign_key [:question_id], :questions
      foreign_key [:writer_id], table: :accounts
      
      DateTime :created_at
      DateTime :updated_at
      
    end
  end
end