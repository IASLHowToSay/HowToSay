# frozen_string_literal: true

require 'sequel'
Sequel.migration do
    change do
        create_table(:tasks) do
            
            primary_key :id
            Integer :type, default: 0
            Integer :sequence
            Integer :question_id
            Integer :account_id
            Boolean :complete , default: false
            DateTime :created_at
            DateTime :updated_at

            foreign_key [:question_id], table: :questions
            foreign_key [:account_id], table: :accounts
        end
    end
end
