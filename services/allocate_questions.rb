# frozen_string_literal: true

module Howtosay

    # 分配題目
    # system 提供 rewrite 和 grade 需要幾題
    # account 提供 wtasks, gtasks 的 account_id
    # [account_id,question_id,sequence,complete]
    class Dispatcher
      def self.call(system, account)
        rewrite_amonut = system.rewrite_amount
        rewrite_people = system.rewrite_people
        grade_amonut = system.grade_amount
        grade_people = system.grade_people
        rewrite_index = Howtosay::Question.first(rewrite_people >  0)
        # 判斷 account 是 rewriter 或是 grader
        if account.can_rewrite
          rewrite_amonut.each do |sequence|
            # 找第一筆 question 並且 rewrite_people >= 0
            wtask ={
              account_id: account.id,
              question_id: source.id,
              content: question_info['content'],
              rewrite_people: rewrite_people,
              grade_people: grade_people
            }
            Howtosay::Question.create(question)
          end
        end
        
      end
    end
  end