# frozen_string_literal: true

require 'sequel'

Sequel.migration do
  change do
    create_table(:gooddetails) do
      primary_key :question_id

      Integer :writer_id, null: false
      Integer :detail_id, null: false
      Boolean :good
      
      DateTime :created_at
      DateTime :updated_at

      foreign_key [:writer_id], table: :accounts
      foreign_key [:detail_id], table: :details

    end
  end
end