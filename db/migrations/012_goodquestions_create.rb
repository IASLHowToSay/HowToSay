# frozen_string_literal: true

require 'sequel'

Sequel.migration do
  change do
    create_table(:goodquestions) do

      primary_key :id

      Integer :question_id, null: false
      Integer :rewriter_id, null: false
      Boolean :good

      foreign_key [:question_id], :questions
      foreign_key [:rewriter_id], table: :accounts
      
      DateTime :created_at
      DateTime :updated_at
      
    end
  end
end