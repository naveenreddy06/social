class Signed::UsersController < Signed::BaseController

  def show
   @user = current_user
  end

  def edit
   @user = User.find(params[:id])
  end

  def update
   @user = User.find(params[:id])
   if @user.update_attributes(params[:user])
   end
  end

  #========= Circle management ==================

  #======== End Circle ==========================

  #========= Chronicle management ===============

  #======== End Chronicle =======================

  #========= Connection management ==============

  #======== End Connection ======================
end
