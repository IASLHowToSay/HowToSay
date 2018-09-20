# frozen_string_literal: true

require 'json'
require 'sequel'

module Howtosay
  # Models a Question
  class Question < Sequel::Model
    many_to_one :cate
    many_to_one :source
    one_to_many :tasks
    
    plugin :association_dependencies, tasks: :destroy
    plugin :timestamps

    # rubocop:disable MethodLength
    def to_json(options = {})
      JSON(
        {
          type: 'question',
          id: id,
          cate: cate,
          source: source,
          content: content,
          rewrite_people: rewrite_people,
          grade_people: grade_people
        }, options
      )
    end
    # rubocop:enable MethodLength
  end
end