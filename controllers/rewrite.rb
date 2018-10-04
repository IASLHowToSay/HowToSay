# frozen_string_literal: true

require 'roda'

module Howtosay
  # Web controller for Howtosay API
  class Api < Roda
    route('rewrite') do |routing|
      @rewrtie_route = "#{@api_root}/rewrite"
      # POST api/v1/rewrite/goodquestion
      routing.on 'goodquestion' do
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
      routing.on String do |email|
        routing.on String do |cate_id|
          # GET api/v1/rewrite/[email]/[cate_id]
          routing.get do
            rewritepage = Rewritepage.new(email, cate_id)
            rewritepage ? rewritepage.to_json() : raise('rewritepage not found')
          rescue StandardError => error
            routing.halt 404, { message: error.message }.to_json
          end
        end
      end
    end
  end
end