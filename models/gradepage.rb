# frozen_string_literal: true

require_relative 'task'
require_relative 'account'
require_relative 'question'


module Howtosay
  # Behaviors of the get cate page
  class Gradepage
    def initialize(email, cate_id)
      # user name
      @account = Account.first(email: email)
      @all_task = Task.where(account_id: @account.id).where(cate_id: cate_id)
      @total = @all_task.count
      @current_task = @all_task.where(complete: false).order(Sequel.asc(:sequence)).first
      # 為了防止 grade 不需作答的類別出錯 因為這個 @current_task.question_id
      unless @current_task.nil?
        answers = Answer.where(question_id: @current_task.question_id).all
        @current_task = @current_task.to_h.merge!(answers: answers)
        @current_task = @current_task.to_h.merge!(total: @total)
      else
        @current_task = nil
      end
    end

    def to_json(options = {})
      JSON(@current_task, options)
    end
  end
end
