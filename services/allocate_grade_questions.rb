# frozen_string_literal: true
require_relative '../models/goodquestion'

module Howtosay
  # Error for invalid credentials
  class FailedGradeAllocation < StandardError; end
  # 分配題目
  class AllocateGradeQuestion
  
    def initialize(status, account)
      # require_people 每題需要多少人
      # require_questions 每個人需要做多少題
      @require_people = status.grade_people
      @require_questions = status.grade_amount
      @account = account
    end
  
    def grade_task(questions)
      question_sequence = 0
      question_accum = 0
      questions.each do |question|
        # 此題尚未到達需求人數
        if question.grade_people < @require_people 
          question_accum = question_accum + 1
          # 查看是否有answer
          unless Answer.where(question_id: question.id).empty?
            question_sequence = question_sequence + 1  
            task_data ={
              type: 1,
              sequence: question_sequence,
              cate_id: question.cate_id,
              question_id: question.id,
              account_id: @account.id,
              complete: false
            }
            Howtosay::Task.create(task_data)

            people = question.grade_people + 1
            question.update(grade_people: people)
            #  若題目沒了，for 就會結束了，所以不會有空題的問題
            if question_accum == @require_questions
              break
            end
          end
        end
      end
    rescue StandardError
      raise(FailedGradeAllocation, "Cant allocate the grade question for #{@account.name}")
    end

    def call()
      categories = Howtosay::Cate.all
      categories.each do |cate|
        if @account.teacher == cate.for_teacher
          questions = Howtosay::Question.where(cate_id: cate.id)
          grade_task(questions)
        end
      end
    end
  end
end