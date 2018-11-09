# frozen_string_literal: true

require 'sequel'

Sequel.migration do
  change do
    create_table(:gooddetails) do
      
      primary_key :id

      Integer :question_id, null: false
      Integer :rewriter_id, null: false
      Integer :detail_id, null: false

      foreign_key [:question_id], table: :questions
      foreign_key [:rewriter_id], table: :accounts
      foreign_key [:detail_id], table: :details
      
      DateTime :created_at
      DateTime :updated_at
      
    end
  end
end