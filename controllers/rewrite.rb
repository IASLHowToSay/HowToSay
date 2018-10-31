# frozen_string_literal: true

require 'roda'

module Howtosay
  # Web controller for Howtosay API

  # GET  api/v1/rewrite/[email]/[cate_id]/label
  # GET  api/v1/rewrite/[email]/[cate_id]/sentence
  # POST api/v1/rewrite/saveanswer
  class Api < Roda
    route('rewrite') do |routing|
      @rewrtie_route = "#{@api_root}/rewrite"
      
      routing.on 'saveanswer' do
        # POST api/v1/rewrite/saveanswer
        routing.post do
          begin
            info = JsonRequestBody.parse_symbolize(request.body.read)
          
            unless info[:sentence].gsub(" ","") == ""
              # 存入 answer
              answer_info ={
                question_id: info[:question_id],
                content: info[:sentence],
                rewriter_id: info[:account_id]
              }
              answer = Answer.create(answer_info)
            end
            # 存入 good_question
            goodquestion_info ={
              question_id: info[:question_id],
              rewriter_id: info[:account_id],
              good: true
            } 
            Goodquestion.create(goodquestion_info)

            # 存入 good_detail
            gooddetail_info ={
              question_id: info[:question_id],
              rewriter_id: info[:account_id],
              detail_id: info[:detail_id]
            } 
            Gooddetail.create(gooddetail_info)
          
            # 完成題目，更新 task
            task = Task.where(id: info[:task_id]).first
            task.update(complete: true)
          
            response.status = 201
            response['Location'] = "#{@rewrtie_route}/saveanswer"

          rescue StandardError => error
            routing.halt 404, { message: error.message }.to_json
          end
        end
      end
      
      routing.on 'skip' do
        routing.post do
          begin
            info = JsonRequestBody.parse_symbolize(request.body.read)
          
            badquestion_info ={
              question_id: info[:question_id],
              rewriter_id: info[:account_id],
              good: false
            }
            Goodquestion.create(badquestion_info)
          
            # 完成題目，更新 task
            task = Task.where(id: info[:task_id]).first
            task.update(complete: true)

            response.status = 201
            response['Location'] = "#{@rewrtie_route}/skip"
          rescue StandardError => error
            routing.halt 404, { message: error.message }.to_json
          end
        end
      end

      routing.on String do |email|
        routing.on String do |cate_id|
          routing.on 'label' do
            # GET api/v1/rewrite/[email]/[cate_id]/label
            routing.get do
              begin
                labelpage = Labelpage.new(email, cate_id)
                unless labelpage.to_json() == JSON(nil)
                  labelpage.to_json()
                else
                  raise('labelpage not found')
                end
              rescue StandardError => error
                routing.halt 404, { message: error.message }.to_json
              end
            end
          end
          routing.on 'sentence' do
            # GET api/v1/rewrite/[email]/[cate_id]/sentence
            routing.get do
              begin
                sentencepage = Sentencepage.new(email, cate_id)
                sentencepage ? sentencepage.to_json() : raise('sentencepage not found')
              rescue StandardError => error
                routing.halt 404, { message: error.message }.to_json
              end
            end
          end
        end
      end
    end
  end
end