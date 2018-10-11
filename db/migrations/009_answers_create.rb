# frozen_string_literal: true

require 'sequel'

Sequel.migration do
  change do
    create_table(:answers) do
      primary_key :id

      Integer :question_id, null: false
      String :content
      Integer :rewriter_id, null: false # the account who write the answer
      DateTime :created_at
      DateTime :updated_at

      foreign_key [:question_id], table: :questions
      foreign_key [:rewriter_id], table: :accounts

    end
  end
end