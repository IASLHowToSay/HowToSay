require 'roda'
require 'sendgrid-ruby'
include SendGrid

module Howtosay
  # Web controller for Howtosay API
  class Api < Roda
    route('accounts') do |routing|
      @account_route = "#{@api_root}/accounts"
      
      # 登入
      routing.on 'authenticate' do 
        routing.route('authenticate', 'accounts')
      end

      routing.on 'forgetpassword' do
        # using SendGrid's Ruby Library
        # https://github.com/sendgrid/sendgrid-ruby
        # POST api/v1/accounts/forgetpassword
        routing.post do
          verification_data = JSON.parse(routing.body.read)
          email = verification_data['email']
          reset_url = verification_data['reset_url']
          puts verification_data
          account = Howtosay::Account.where(email: email).first
          if account
            from = Email.new(email: 'noreply@howtosay.com')
            to = Email.new(email: email)
            subject = '[Howtosay]更新密碼'
            html_content = " <p> #{account.name} 你好, </p>
              <p>Howtosay 收到您要忘記密碼的困擾</p></br>
              <p>請點擊此連結到更新密碼頁面 <a href=\"#{reset_url}\">更換密碼</a></p>
              <p>IASL祝您有美好的一天</p></br></br>
              <hr>
              <p>請不要回寄信，此信箱為系統發送信件，感謝! </br>"
            content = Content.new(type: 'text/html', value: html_content)
            mail = Mail.new(from, subject, to, content)
            sg = SendGrid::API.new(api_key: Api.config.SENDGRID_API_KEY)
            sg.client.mail._('send').post(request_body: mail.to_json)
            response.status = 202
            response['Location'] = "#{@account_route}/forgetpassword"
            {'message': '請去信箱中查看 noreply@howtosay.com 的信件'}.to_json()
          else
            raise('此帳號不存在！')
          end
        rescue StandardError => error
          routing.halt 404, { message: error.message }.to_json
        end
      end

      routing.on 'changepassword' do
        routing.post do
          new_data = JSON.parse(routing.body.read)
          account = Account.where(email: new_data['email']).first
          unless account == nil
            account.update(new_data)
            response.status = 201
            response['Location'] = "#{@account_route}/changepassword"
            {message: '密碼更新成功！'}.to_json()
          else
            raise('此帳號不存在！')
          end
        rescue StandardError => error
          routing.halt 404, { message: error.message }.to_json
        end
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
            admin: false, # 之後有後台要改
            activate: false #一開始部會開通，除非分配完題目
          )
          new_account = Account.new(new_data)
          raise('Could not save account') unless new_account.save
        
          # 發送分配訊號
          if status.can_rewrite && !status.can_grade
            AllocateRewriteQuestion.new(status, new_account).call()
          elsif !status.can_rewrite && status.can_grade
            AllocateGradeQuestion.new(status, new_account).call()
          end

          new_account.update(activate: true)
 
          response.status = 201
          response['Location'] = "#{@account_route}/#{new_account.id}"
        }
      rescue Sequel::MassAssignmentRestriction
        routing.halt 400, { message: 'Illegal Request' }.to_json
      rescue StandardError => error
        puts error.inspect
        routing.halt 500, { message: error.message }.to_json
      rescue SendAllocateQuestionsRequestError => error
        puts [error.class, error.message].join ': '
        routing.halt 400, { message: 'Can\'t send the allocation' }.to_json
      end
    end
  end
end