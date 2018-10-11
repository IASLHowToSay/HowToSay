# frozen_string_literal: true

module Howtosay
  # Error for invalid credentials
  class FailedRewriteAllocation < StandardError; end
  # 分配題目
  class AllocateRewriteQuestion
  
    def initialize(status, account)
      # require_people 每題需要多少人
      # require_questions 每個人需要做多少題
      @require_people = status.rewrite_people
      @require_questions = status.rewrite_amount
      @account = account
    end
  
    def rewrite_task(questions)
      task =[]
      questions.each do |question|
        # 此題尚未到達需求人數
        if question.rewrite_people < @require_people
          # 加入rewrite工作
          question_sequence = task.length + 1  
          task_data ={
            type: 0,
            sequence: question_sequence,
            cate_id: question.cate_id,
            question_id: question.id,
            account_id: @account.id,
            complete: false
          }
          t = Howtosay::Task.create(task_data)
          task << t
          # 把questions + 1
          people = question.rewrite_people + 1
          question.update(rewrite_people: people)
        end
        # 達成個人的份量
        if task.length == @require_questions
          break
        end
      end
    rescue StandardError
      raise(FailedRewriteAllocation, "Can\'t allocate the rewrite question for #{@account.name}")
    end
  
    def call()
      categories = Howtosay::Cate.all
      categories.each do |cate|
        if @account.teacher == cate.for_teacher
          questions = Howtosay::Question.where(cate_id: cate.id)
          rewrite_task(questions)
        end
      end
    end
  end
end