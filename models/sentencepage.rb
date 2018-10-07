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
      current_task = all_task.where(complete: false).order(Sequel.asc(:sequence)).first
      details = Detail.where(cate_id: cate_id).all
      details.map! do |d|
        d.to_h
      end
      @final = current_task.to_h.merge!(total: total)
      @final = @final.to_h.merge!(details: details)
    end

    def to_json(options = {})
      JSON(@final, options)
    end
  end
end
