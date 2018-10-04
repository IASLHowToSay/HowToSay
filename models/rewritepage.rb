# frozen_string_literal: true

require_relative 'task'
require_relative 'account'
require_relative 'question'


module Howtosay
  # Behaviors of the get cate page
  class Rewritepage
    def initialize(email, cate_id)
      # user name
      @account = Account.first(email: email)
      @all_task = Task.where(account_id: @account.id).where(cate_id: cate_id)
      @total = @all_task.count
      @current_task = @all_task.where(complete: false).order(Sequel.asc(:sequence)).first
    end

    def to_json(options = {})
      JSON(@current_task.to_h.merge!(total: @total), options)
    end
  end
end
