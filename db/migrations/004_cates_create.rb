# frozen_string_literal: true

require 'sequel'

Sequel.migration do
  change do
    create_table(:cates) do
      primary_key :id

      String :name, unique: true, null: false
      String :description
      Boolean :for_teacher # for teacher or student
      DateTime :created_at
      DateTime :updated_at
      
    end
  end
end