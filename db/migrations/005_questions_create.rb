# frozen_string_literal: true

require 'sequel'

Sequel.migration do
  change do
    create_table(:questions) do
      primary_key :id

      Integer :cate_id, null: false
      Integer :cate_detail_id, null: false
      Integer :tip_id, null: false
      String :content, null: false 
      Integer :yes, default: 0
      Integer :no, default: 0
     
      DateTime :created_at
      DateTime :updated_at

      foreign_key [:cate_id], table: :cates
      foreign_key [:cate_detail_id], table: :cate_details
      foreign_key [:tip_id], table: :tips

    end
  end
end