# frozen_string_literal: true

require 'sequel'

Sequel.migration do
  change do
    create_table(:details) do
      primary_key :id

      String :name, null: false
      Integer :cate_id, null: false
      String :description

      DateTime :created_at
      DateTime :updated_at

      foreign_key [:cate_id], table: :cates
      
    end
  end
end