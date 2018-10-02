# frozen_string_literal: true

module Howtosay
  # Error for invalid credentials
  class FailedAllocation < StandardError; end
  # 分配題目
  class AllocateQuestion

    def initialize(status, account)
      # task_people 每題需要多少人, task_amount 每個人需要做多少題
      @task_type, @require_people, @require_questions = decide_status(status)
      @account = account
    end

    def decide_status(status)
      if status.can_rewrite && !status.can_grade
        return 0, status.rewrite_people, status.rewrite_amount
      else
        return 1, status.grade_people, status.grade_amount
      end
    end

    def rewrite_task(questions)
      task =[]
      questions.each do |question|
        # 此題尚未到達需求人數
        if question.rewrite_people < @require_people
          # 加入rewrite工作
          question_sequence = task.length + 1  
          task_data ={
            type: @task_type,
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
      raise(FailedAllocation, "Can\'t allocate the rewrite question for #{@account.name}")
    end

    def grade_task(questions)
      task =[]
      questions.each do |question|
        # 此題尚未到達需求人數
        if question.grade_people < @require_people
        # 加入 grade 工作
          question_sequence = task.length + 1  
          task_data ={
            type: @task_type,
            sequence: question_sequence,
            cate_id: question.cate_id,
            question_id: question.id,
            account_id: @account.id,
            complete: false
          }
          t = Howtosay::Task.create(task_data)
          task << t
          # 把questions + 1
          people = question.grade_people + 1
          question.update(grade_people: people)
        end
        # 達成個人的份量
        if task.length == @require_questions
          break
        end
      end
    rescue StandardError
      raise(FailedAllocation, "Cant allocate the grade question for #{@account.name}")
    end

    def call()
      categories = Howtosay::Cate.all
      if @task_type == 0
        categories.each do |cate|
          if @account.teacher && cate.for_teacher
            questions = Howtosay::Question.where(cate_id: cate.id)
            rewrite_task(questions)
          end
          if !@account.teacher && !cate.for_teacher
            questions = Howtosay::Question.where(cate_id: cate.id)
            rewrite_task(questions)
          end
        end
      else
        categories.each do |cate|
          if @account.teacher && cate.for_teacher
            questions = Howtosay::Question.where(cate_id: cate.id)
            grade_task(questions)
          end
          if !@account.teacher && !cate.for_teacher
            questions = Howtosay::Question.where(cate_id: cate.id)
            grade_task(questions)
          end
        end
      end
    end
  end
end