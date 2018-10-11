# frozen_string_literal: true

require 'roda'

module Howtosay
  # Web controller for Howtosay API

  # GET  api/v1/grade/[email]/[cate_id]
  # POST api/v1/grade/saveanswer
  class Api < Roda
    route('grade') do |routing|
      @grade_route = "#{@api_root}/grade"
      
      routing.on 'saveanswer' do
        # POST api/v1/grade/saveanswer
        routing.post do
          info = JsonRequestBody.parse_symbolize(request.body.read)
          good_answers = info[:good_answers]
          good_answers.each do |good_answer|
            Goodanswer.create(good_answer)
          end
          task = Task.where(id: info[:task_id]).first
          task.update(complete: true)  
          response.status = 201
          response['Location'] = "#{@rewrtie_route}/saveanswer"

        rescue StandardError => error
          routing.halt 404, { message: error.message }.to_json
        end
      end
      routing.on String do |email|
        routing.on String do |cate_id|
          routing.get do
            gradepage = Gradepage.new(email, cate_id)
            gradepage ? gradepage.to_json() : raise('gradepage not found')
          rescue StandardError => error
            routing.halt 404, { message: error.message }.to_json
          end
        end
      end
    end
  end
end