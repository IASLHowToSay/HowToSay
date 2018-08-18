# frozen_string_literal: true

require 'sequel'

Sequel.migration do
  change do
    create_table(:systems) do
      
      Boolean :can_register, default: true
      Boolean :can_rewrite, default: true
      Boolean :can_grade, default: true
      String  :description
    end
  end
end