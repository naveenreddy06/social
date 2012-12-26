class Unsigned::SessionsController < Unsigned::BaseController

  before_filter :check_authentication, :except => [:logout]
  
  def create
    @user = (User.where("login.email" => params[:email]).first)
    if @user and  @user.verified and  @user.login.authenticate(params[:password])
      session[:user_id] =  @user.id
      set_all
      if params[:keep_me_signed_in].present? and params[:keep_me_signed_in]
        cookies[:auth_token] = { :value =>  @user.id, :expires => Time.now+1.year }
      end
    else
      @errors = ''
      if @user.nil?
        @errors += "The username entered does not belong to any account. Enter valid username"
      elsif !@user.verified
        @errors += "Email provided is not verified."
      else
        @errors += "Password is incorrect."
      end
    end
  end
  
  def logout
    session[:user_id] = nil
    redirect_to root_path
  end
  
end
