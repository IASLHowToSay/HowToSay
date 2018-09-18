# frozen_string_literal: true

require 'sequel'

Sequel.migration do
  change do
    create_table(:systems) do
      
      Boolean :can_rewrite, default: false
      Integer :rewrite_amount
      Integer :rewrite_people
      String  :rewrite_description
      Boolean :can_grade, default: false
      Integer :grade_amount
      Integer :grade_people
      String  :grade_description

    end
  end
end