# frozen_string_literal: true

require_relative 'cate'
require_relative 'system'
require_relative 'account'


module Howtosay
  # Behaviors of the get home page
  class Homepage

    def initialize(email)
      # user name
      @account = Account.first(email)
      @name = @account.name
      @teacher = @account.teacher
      status = System.first()
      # system description, amount
      if status.can_rewrite == true && status.can_grade == false
        @description = status.rewrite_description
      else
        @description = status.grade_description
      end
      # cate
      @cates = Cate.all
      @cates.map! do |c|
        amount = Task.where(account_id: @account.id).where(cate_id: c.id).count
        if c.name == "育"
          @teacher ? c.to_h.merge!(amount: amount) : c.to_h.merge!(amount: 0)
        else
          c.to_h.merge!(amount: amount)
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
