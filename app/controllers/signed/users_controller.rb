class Signed::UsersController < Signed::BaseController

  def show
   @user = current_user
  end

  def update
   @user = User.find(params[:id])
   if @user.update_attributes(params[:user])
   end
  end

  def manage
    if request.headers['X-PJAX']
        render :layout => false
      end
  end

  def account_form
    render :text => params[:form_type]
  end

  #========= Circle management ==================

  #======== End Circle ==========================

  #========= Chronicle management ===============

  #======== End Chronicle =======================

  #========= Connection management ==============

  #======== End Connection ======================
end
