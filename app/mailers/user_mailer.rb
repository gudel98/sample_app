require 'sendgrid-ruby'

class UserMailer < ApplicationMailer
  include SendGrid

  def account_activation(user)
    @user = user
    content = "<h1>Sample App</h1>

<p>Hi #{@user.name},</p>

<p>
Welcome to the Sample App! Click on the link below to activate your account:
</p>

Your activation token: #{@user.activation_token}"
    send_mail(user, "Account activation", content)
  end

  def password_reset(user)
    @user = user
    content = "<h1>Password reset</h1>

<p>To reset your password click the link below:</p>

Your new password: #{@user.reset_token}

<p>This link will expire in two hours.</p>

<p>
If you did not request your password to be reset, please ignore this email and
your password will stay as it is.
</p>"
    send_mail(user, "Password reset", content)
  end

  private

  def send_mail(user, subject, content)
    from = Email.new(email: 'test@example.com')
    to = Email.new(email: user.email)
    content = Content.new(type: 'text/html', value: content)
    mail = Mail.new(from, subject, to, content)

    sg = SendGrid::API.new(api_key: ENV['SENDGRID_API_KEY'])
    response = sg.client.mail._('send').post(request_body: mail.to_json)
    puts response.status_code
    puts response.body
    puts response.headers
  end
end
