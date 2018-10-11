# frozen_string_literal: true

require_relative 'cate'
require_relative 'system'
require_relative 'account'


module Howtosay
  # Behaviors of the get home page
  class Homepage

    def initialize(email)
      # user name
      @account = Account.first(email)
      @i_am_a_teacher = @account.teacher
      
      # 系統敘述
      status = System.first()
      if status.can_rewrite == true && status.can_grade == false
        @description = status.rewrite_description
      else
        @description = status.grade_description
      end
      
      # 每個類別的進度
      @cates = Cate.all
      @cates.map! do |c|
        # 若 不是老師 i_am_a_teacher==false ，此類 for_teacher== false -> 學生且學生題目
        # 若 是老師 i_am_a_teacher==true ，此類 for_teacher== true -> 老師且老師題目
        if c.for_teacher == @i_am_a_teacher
          total = Task.where(account_id: @account.id).where(cate_id: c.id).count
          finish = Task.where(account_id: @account.id).where(cate_id: c.id).where(complete: true).count
          unless finish == total
            progress = "#{finish}/#{total}"
            c.to_h.merge!(progress: progress)
          else
            c.to_h.merge!(progress: '恭喜完成')
          end
        else
          c.to_h.merge!(progress: '不需作答')
        end
      end
    end

    def to_json(options = {})
      @info = {
        user: @account,
        description: @description,
        cates: @cates
      }
      JSON(@info, options)
    end
  end
end
