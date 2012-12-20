class Unsigned::HomeController < Unsigned::BaseController
  
  def index
  end

  def verified
  end


  def registered_successfully
  end

  def resend_email
    
  end

  def resend_email_click
    @user = (User.where("login.email" => params[:email]).first)
    if @user
      @user.send_verification 
      redirect_to registered_successfully_unsigned_home_index_path
    else
      render :action => :resend_email
    end
  end

  def register
   @user = User.new
   @user.build_login

  end

  def help

  end

 # ====================Forgot password ===================================
  def forgot_password
  end

 #retreive password ajax def
  def retreive
    @user = (User.where("login.email" => params[:email]).first)
    if @user and @user.verified
      @user.send_forgot_password
      flash[:notice] = "A link has been sent to this email account ,kindly follow the instructions to reset your password  "
    else
      flash[:error] = "Invalid Login"
    end
  end

 #==========================End Forgot password===============================
  def account_compromised

  end

 #account compromised retreive ajax def
  def account_compromised_retreive
    @user = (User.where("login.master_email" => params[:master_email]).first)
    if @user and @user.verified
      @user.send_forgot_password
    else
      flash[:error] = "Invalid Login"
    end
  end

 #========================================================================
  def change_password_form
    @user = User.where("login.email" => params[:user][:login_attributes][:email]).first
    @user.update_attributes(params[:user])
  end

 #forgot  login email
  def forgot_username
    user = User.where("login.master_email" => params[:master_email]).first
    @login = user.login if user
    flash[:error] = "invalid master email please enter again"
  end

  def change_password
  end

  def account_com_update
    #flash[:error] = "invalidness"
  end

  def set_password
    @user = User.where("verification_token" => params[:token]).first
  end
  
  def create_user
    @user = User.new(params[:user])
    if @user.save
      redirect_to registered_successfully_unsigned_home_index_path
    else
      render register_unsigned_home_index_path 
    end
  end
  
  def verify_email
    user = User.where("verification_token" => params[:token]).first
    if user
      user.verified = true
      user.save(:validate => false)
      render  verified_unsigned_home_index_path
    else
     render "unsigned/home/index"
    end
  end

  private

  def redirect_if_logged
    if logged_in?
      redirect_to root_path
    end
  end
end
