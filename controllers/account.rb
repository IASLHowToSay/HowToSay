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

      routing.on 'forgetpassword' do
        # using SendGrid's Ruby Library
        # https://github.com/sendgrid/sendgrid-ruby
        # POST api/v1/accounts/forgetpassword
        routing.post do
          begin
            verification_data = JSON.parse(routing.body.read)
            email = verification_data['email']
            reset_url = verification_data['reset_url']
            account = Howtosay::Account.where(email: email).first
            if account
              SendRecoveryEmail.new(Api.config).call(email, account.name, reset_url)
              response.status = 202
              response['Location'] = "#{@account_route}/forgetpassword"
              {'message': '請去信箱中查看 noreply@howtosay.com 的信件'}.to_json()
            else
              raise('此帳號不存在！')
            end
          rescue UnSendRecoveryEmailError => error
            routing.halt 500, { message: error.message }.to_json
          rescue StandardError => error
            routing.halt 404, { message: error.message }.to_json
          end
        end
      end

      routing.on 'changepassword' do
        routing.post do
          begin
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
      end

      routing.on 'register' do
        # GET api/v1/accounts/register
        # 顯示註冊頁面
        routing.get do
          begin
            info = Registerpage.new()
            info ? info.to_json : raise('info not found')
          rescue StandardError => error
            routing.halt 404, { message: error.message }.to_json
          end
        end
      end

      routing.on String do |email|
        # GET api/v1/accounts/[email]
        routing.get do
          begin
            account = Account.first(email: email)
            account ? account.to_json : raise('Account not found')
          rescue StandardError => error
            routing.halt 404, { message: error.message }.to_json
          end
        end
      end

      # POST api/v1/accounts
      # 註冊帳號
      routing.post do
        # 建立新帳號
        begin
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
              if Question.where(rewrite_people: status.rewrite_people).count == Question.count
                Question.all.each do |q|
                  q.update(rewrite_people: 0)
                end
              end
              AllocateRewriteQuestion.new(status, new_account).call()
            elsif !status.can_rewrite && status.can_grade
              if Question.where(grade_people: status.grade_people).count == Question.count
                Question.all.each do |q|
                  q.update(grade_people: 0)
                end
              end
              AllocateGradeQuestion.new(status, new_account).call()
            end

            new_account.update(activate: true)
  
            response.status = 201
            response['Location'] = "#{@account_route}/#{new_account.id}"
          }
        rescue Sequel::MassAssignmentRestriction
          routing.halt 400, { message: 'Illegal Request' }.to_json
        rescue FailedGradeAllocation => error
          puts [error.class, error.message].join ': '
          routing.halt 500, { message: 'Can\'t allocate the grade' }.to_json
        rescue FailedRewriteAllocation => error
          puts [error.class, error.message].join ': '
          routing.halt 500, { message: 'Can\'t allocate the grade' }.to_json
        rescue StandardError => error
          puts error.inspect
          routing.halt 500, { message: error.message }.to_json
        end
      end
    end
  end
end