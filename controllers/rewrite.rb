# frozen_string_literal: true

require 'roda'

module Howtosay
  # Web controller for Howtosay API
  # 給予是否為好問題:                POST api/v1/rewrite/goodquestion
  # 顯示改寫階段標註是否為好問題的頁面: GET  api/v1/rewrite/[email]/[cate_id]/label
  # 顯示改寫階段賦予小類別及改寫句子頁: GET  api/v1/rewrite/[email]/[cate_id]/sentence
  class Api < Roda
    route('rewrite') do |routing|
      @rewrtie_route = "#{@api_root}/rewrite"
      routing.on 'goodquestion' do
        # label 階段 給予 question 是否為好的分類
        # POST api/v1/rewrite/goodquestion
        routing.post do
          info = JsonRequestBody.parse_symbolize(request.body.read)
          if Goodquestion.where(writer_id: info[:writer_id]).where(question_id: info[:question_id]).empty?
            goodquestion = Goodquestion.create(info)
          else
            goodquestion = Goodquestion.where(writer_id: info[:writer_id]).where(question_id: info[:question_id]).first
            goodquestion.update(info)
          end
          goodquestion ? goodquestion.to_json() : raise('goodquestion not found')
          response.status = 201
          response['Location'] = "#{@rewrtie_route}/goodquestion"
        rescue StandardError => error
          routing.halt 404, { message: error.message }.to_json
        end
      end
      routing.on 'saveanswer' do
        # POST api/v1/rewrite/saveanswer
        routing.post do
          answer_info = JsonRequestBody.parse_symbolize(request.body.read)
          puts answer_info
        end
      end
      routing.on String do |email|
        routing.on String do |cate_id|
          routing.on 'label' do
            # GET api/v1/rewrite/[email]/[cate_id]/label
            routing.get do
              labelpage = Labelpage.new(email, cate_id)
              labelpage ? labelpage.to_json() : raise('labelpage not found')
            rescue StandardError => error
              routing.halt 404, { message: error.message }.to_json
            end
          end
          routing.on 'sentence' do
            # GET api/v1/rewrite/[email]/[cate_id]/sentence
            routing.get do
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