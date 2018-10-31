# frozen_string_literal: true
require 'sendgrid-ruby'
include SendGrid

module Howtosay
  # Error for invalid credentials
  class UnSendRecoveryEmailError < StandardError

    def initialize(msg = nil)
        @email = msg
    end

    def message
      "Something wrong with SendGrid send to #{@email}!"
    end
  end
  
  class SendRecoveryEmail

    def initialize(config)
      @config = config
    end

    def call(email, name, reset_url)
      begin
        from = Email.new(email: 'no-reply@howtosay.com')
        to = Email.new(email: email)
        subject = '[Howtosay]更新密碼'
        html_content = " <p> #{name} 你好, </p>
          <p>Howtosay 收到您要忘記密碼的困擾</p></br>
          <p>請點擊此連結到更新密碼頁面 <a href=\"#{reset_url}\">更換密碼</a></p>
          <p>IASL祝您有美好的一天</p></br></br>
          <hr>
          <p>請不要回寄信，此信箱為系統發送信件，感謝! </br>"
        content = Content.new(type: 'text/html', value: html_content)
        mail = Mail.new(from, subject, to, content)
        sg = SendGrid::API.new(api_key: @config.SENDGRID_API_KEY)
        sg.client.mail._('send').post(request_body: mail.to_json)
      rescue StandardError
        raise UnSendRecoveryEmailError, email
      end
    end
  end
end