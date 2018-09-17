# frozen_string_literal: true

module Howtosay

    # 分配題目
    # system 提供 rewrite 和 grade 需要幾題
    # account 提供 wtasks, gtasks 的 account_id
    # [account_id,question_id,sequence,complete]
    class Dispatcher
      def self.call(system, account)
        rewrite_amonut = system.rewrite_amount
        grade_amonut = system.grade_amount
        
      end
    end
  end