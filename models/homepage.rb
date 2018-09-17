# frozen_string_literal: true

require_relative 'cate'
require_relative 'system'
require_relative 'account'


module Howtosay
  # Behaviors of the get home page
  class Homepage

    def initialize(email)
      # user name
      account = Account.first(email)
      @name = account.name
      @is_teacher = account.teacher
      status = System.first()
      # system description, amount
      if status.can_rewrite == true && status.can_grade == false
        @description = status.rewrite_description
        @amount = status.rewrite_amount
      else
        @description = status.grade_description
        @amount = status.grade_amount
      end
      # cate
      @cates = Cate.all
      @cates.map! do |c|
        if c.name == "育"
          if @is_teacher
            c.to_h.merge!(amount: @amount)
          else
            c.to_h.merge!(amount: 0)
          end
        else
          c.to_h.merge!(amount: @amount)
        end
      end
    end

    def to_json(options = {})
      @info = {
        user: @name,
        description: @description,
        cates: @cates
      }
      JSON(@info, options)
    end
  end
end
