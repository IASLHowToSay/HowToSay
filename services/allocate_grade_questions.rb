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
      question_limit = 0
      questions.each do |question|
        # 此題尚未到達需求人數
        if question.grade_people < @require_people
          question_limit = question_limit + 1
          # 查看是否是個 good question
          good_question = Goodquestion.where(question_id: question.id)
          vote_sum = good_question.count
          puts "vote_sum: #{vote_sum}"
          vote_good = good_question.where(good: true).count
          puts "vote_good #{vote_good}"
          # 偶數人投票
          if vote_sum%2 == 0 && vote_sum != 0
            if vote_good >= (vote_sum/2)
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
            end
          # 奇數投票
          else
            puts (vote_sum/2)
            if vote_good > (vote_sum/2)
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
            end
          end
          # 計算 是否到達 require_questions 含 bad question 未放入 task 中
          # 把questions + 1
          people = question.grade_people + 1
          question.update(grade_people: people)
          if question_limit == @require_questions
            break
          end
        end
      #   # 達成個人的份量
      #   if task.length == @require_questions
      #     break
      #   end
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