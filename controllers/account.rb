
require 'roda'

module Howtosay
  # Web controller for Howtosay API
  class Api < Roda
    route('accounts') do |routing|
      @account_route = "#{@api_root}/accounts"
      
      # 登入
      routing.on 'authenticate' do 
        routing.route('authenticate', 'accounts')
      end

      routing.on 'register' do
        # GET api/v1/accounts/register
        # 顯示註冊頁面
        routing.get do
          info = Registerpage.new()
          info ? info.to_json : raise('info not found')
        rescue StandardError => error
          routing.halt 404, { message: error.message }.to_json
        end
      end

      routing.on 'destroy_account' do
        # GET api/v1/accounts/destroy_account
        routing.post do
          account = Howtosay::Account.first()
          account.destroy
          {'testing':'destroy good'}.to_json
        end
      end

      routing.on String do |email|
        # GET api/v1/accounts/[email]
        routing.get do
          account = Account.first(email: email)
          account ? account.to_json : raise('Account not found')
        rescue StandardError => error
          routing.halt 404, { message: error.message }.to_json
        end
       
        routing.on 'allocate_questions' do
          # POST api/v1/accounts/[email]/allocate_questions
          routing.post do
          # 給予題目並將使用者的activate激活
            sync{
              account = Account.first(email: email)
              raise('Account not found') unless account
              status = System.first
              AllocateQuestion.new(status, account).call()
              account.update(activate: true)
              response.status = 201
              response['Location'] = "#{@account_route}/#{account.email}/allocate_questions"
            }
          rescue Sequel::MassAssignmentRestriction
            routing.halt 400, { message: 'Illegal Request' }.to_json
          rescue StandardError => error
            puts error.inspect
            routing.halt 500, { message: error.message }.to_json
          end
        end
      end

      # POST api/v1/accounts
      # 註冊帳號
      routing.post do
        # 建立新帳號
        status = System.first
        new_data = JSON.parse(routing.body.read)
        new_data.merge!(
          can_rewrite: status.can_rewrite,
          can_grade: status.can_grade,
          admin: false, # 之後有後台要改
          activate: false #一開始部會開通，除非分配完題目
        )
        new_account = Account.new(new_data)
        raise('Could not save account') unless new_account.save
        
        # 發送分配訊號
        email = new_account.email
        address = "http://localhost:9292/api/v1/accounts/#{email}/allocate_questions"
        s_response = SendAllocateQuestionsRequest.new(address).call()

        response.status = 201
        response['Location'] = "#{@account_route}/#{new_account.id}"
      rescue Sequel::MassAssignmentRestriction
        routing.halt 400, { message: 'Illegal Request' }.to_json
      rescue StandardError => error
        puts error.inspect
        routing.halt 500, { message: error.message }.to_json
      rescue SendAllocateQuestionsRequestError => error
        puts [error.class, error.message].join ': '
        routing.halt '400', { message: 'Can\'t send the allocation' }.to_json
      end
    end
  end
end