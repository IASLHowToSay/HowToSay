# frozen_string_literal: true

require 'json'
require 'sequel'

module Howtosay
  # Models a Detail
  class Gooddetail < Sequel::Model
    
    many_to_one :question

    plugin :timestamps

    # rubocop:disable MethodLength
    def to_json(options = {})
      JSON(
        {
          type: 'gooddetail',
          question_id: question_id,
          writer_id: writer_id,
          detail_id: detail_id,
          good: good
        }, options
      )
    end
    # rubocop:enable MethodLength
  end
end