# frozen_string_literal: true

require 'sequel'
Sequel.migration do
    change do
        create_table(:task) do

            foreign_key :account_id, table: :accounts, :null=>false
            foreign_key :question_id, :questions, :null=>false

            primary_key [:account_id, :question_id]
            
            Integer :sequence
            Boolean :complete , default: false
            
            DateTime :created_at
            DateTime :updated_at

            index [:account_id, :question_id]
        end
    end
end
