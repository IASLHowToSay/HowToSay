# frozen_string_literal: true

require 'sequel'

Sequel.migration do
  change do
    create_table(:answers) do
      primary_key :id

      Integer :question_id, null: false
      String :content
      Integer :writer_id, null: false # the account who write the answer
      String :yes_member
      String :no_member
      Integer :yes
      Integer :no
      DateTime :created_at
      DateTime :updated_at

      foreign_key [:question_id], table: :questions
      foreign_key [:writer_id], table: :accounts

    end
  end
end