# frozen_string_literal: true

require 'sequel'

Sequel.migration do
  change do
    create_table(:questions) do
      primary_key :id

      Integer :cate_id, null: false
      Integer :source_id, null: false
      String :content, null: false 
     
      DateTime :created_at
      DateTime :updated_at

      foreign_key [:cate_id], table: :cates
      foreign_key [:source_id], table: :sources

    end
  end
end