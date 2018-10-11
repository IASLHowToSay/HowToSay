# frozen_string_literal: true

require_relative 'task'
require_relative 'account'
require_relative 'question'
require_relative 'detail'

module Howtosay
  class Sentencepage
    def initialize(email, cate_id)
      account = Account.first(email: email)
      all_task = Task.where(account_id: account.id).where(cate_id: cate_id)
      total = all_task.count
      @current_task = all_task.where(complete: false).order(Sequel.asc(:sequence)).first
      unless @current_task.nil?
        details = Detail.where(cate_id: cate_id).all
        details.map! {|d| d.to_h}
        @current_task = @current_task.to_h.merge!(details: details)
        @current_task = @current_task.to_h.merge!(total: total)
      else
        @current_task = nil
      end
    end

    def to_json(options = {})
      JSON(@current_task, options)
    end
  end
end
