
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
      end

      # POST api/v1/accounts
      # 註冊帳號
      routing.post do
        # 建立新帳號
        sync{
          status = System.first
          new_data = JSON.parse(routing.body.read)
          new_data.merge!(
            can_rewrite: status.can_rewrite,
            can_grade: status.can_grade,
            admin: false # 之後有後台要改
          )
          new_account = Account.new(new_data)
          raise('Could not save account') unless new_account.save
          # 給予題目
          AllocateQuestion.new(status, new_account).call()
          response.status = 201
          response['Location'] = "#{@account_route}/#{new_account.id}"
          if status.can_rewrite && !status.can_grade
            { message: "Account saved, and allocate rewrite question: #{status.rewrite_amount} sucessful!", account_data: new_account }.to_json
          end
          if !status.can_rewrite && status.can_grade
            { message: "Account saved, and allocate grade question: #{status.grade_amount} sucessful!", account_data: new_account }.to_json
          end
        }
      rescue FailedAllocation => error
        routing.halt 400, { message: error.message }.to_json
      rescue Sequel::MassAssignmentRestriction
        routing.halt 400, { message: 'Illegal Request' }.to_json
      rescue StandardError => error
        puts error.inspect
        routing.halt 500, { message: error.message }.to_json
      end
    end
  end
end