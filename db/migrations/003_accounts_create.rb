# frozen_string_literal: true

require 'sequel'

Sequel.migration do
  change do
    create_table(:accounts) do
      primary_key :id

      String  :name, null: false 
      String  :email, unique: true, null: false
      String  :password
      Integer :organization_id
      Boolean :teacher # is teacher or student
      Boolean :can_rewrite
      Boolean :can_grade
      Boolean :admin
      
      DateTime :created_at
      DateTime :updated_at

      foreign_key [:organization_id], table: :organizations
    end
  end
end