# frozen_string_literal: true

module Howtosay
  # Error for invalid credentials
  class FailedAllocation < StandardError; end
  # 分配題目
  class AllocateQuestion

    def initialize(status, account)
      @task_type, @task_amount = decide_status(status)
      @account = account
    end

    def decide_status(status)
      if status.can_rewrite && !status.can_grade
        return 0, status.rewrite_amount
      else
        return 1, status.grade_amount
      end
    end

    def rewrite_task()
      task =[]
      Howtosay::Question.each do |question|
        # 當問題還需要人作答及還沒領完單個人的份量
        if question.rewrite_people > 0 && task.length < @task_amount
          # 加入rewrite工作
          question_sequence = task.length + 1  
          task_data ={
            type: @task_type,
            sequence: question_sequence,
            question_id: question.id,
            account_id: @account.id,
            complete: false
          }
          t = Howtosay::Task.create(task_data)
          task << t
          # 把questions 減 rewrite_people
          people = question.rewrite_people - 1
          question.update(rewrite_people: people)
        end
        if task.length == @task_amount
          break
        end
      end
    rescue StandardError
      raise(FailedAllocation, "Cant allocate the rewrite question for #{@account.name}")
    end

    def grade_task()
      task =[]
      Howtosay::Question.each do |question|
        # 當問題還需要人作答及還沒領完單個人的份量
        if question.grade_people > 0 && task.length < @task_amount
          # 加入grade工作
          question_sequence = task.length + 1  
          task_data ={
            type: @task_type,
            sequence: question_sequence,
            question_id: question.id,
            account_id: @account.id,
            complete: false
          }
          t = Howtosay::Task.create(task_data)
          task << t
          # 把questions 減 grade_people
          people = question.grade_people - 1
          question.update(grade_people: people)
        end
        if task.length == @task_amount
          break
        end
      end
    rescue StandardError
      raise(FailedAllocation, "Cant allocate the grade question for #{@account.name}")
    end

    def call()
      if @task_type == 0
        rewrite_task()
      else
        grade_task()
      end
    end
  end
end