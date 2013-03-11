class Notify < ActionMailer::Base
  default from: "donot-reply@relaylife.com"

  def verify_registration(user)
    @user = user
    mail(:to => user.login.email, :subject => "Verify your email")
  end


  def forgot_password_activation(user)
    @user = user
    mail(:to => user.login.email, :subject => "Password Reset")
  end

end






