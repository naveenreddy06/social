class Signed::UsersController < Signed::BaseController

  def show
   @user = current_user
  end

  def update
   @user = User.find(params[:id])
   if @user.update_attributes(params[:user])
    flash[:notice] = "updated"
   end
  end

  def manage
    case params[:form_type]
     when "edit_wall_profile"
       @wall_detail = WallDetail.new
    end
    if request.headers['X-PJAX']
        render :layout => false
    end
  end

  def account_form
    render :text => params[:form_type]
  end

  def add_walls
    wall = current_user.wall.nil? ? current_user.build_wall : current_user.wall
    @wall_detail = wall.wall_details.where("id" => params[:id]).first
    if @wall_detail
      @wall_detail.update_attributes(params[:wall_detail])
    else
      @wall_detail = wall.wall_details.new params[:wall_detail]
      current_user.save
    end
    @wall_detail = @wall_detail.errors.empty? ? WallDetail.new : @wall_detail
  end

  def edit_detail
    @wall_detail = current_user.wall.wall_details.where("_id" => params[:id]).first
    render :action => :add_walls
  end
  def hide_wall_detail
    @wall_detail = current_user.wall.wall_details.where("_id" => params[:wall_detail_id]).first
    if @wall_detail and (params[:type] == 'hide')
       @wall_detail.update_attributes(:hidden => true)
    else
      @wall_detail.update_attributes(:hidden => false)
    end
    @wall_detail = WallDetail.new
     render :action => :add_walls
  end

  def delete
    current_user.wall.wall_details.where("_id" => params[:id]).first.destroy
    @wall_detail = WallDetail.new
    if params[:edit_id] == params[:id]
     render :action => :add_walls
    else
     render :nothing => true
    end
  end

  #========= Circle management ==================

  #======== End Circle ==========================

  #========= Chronicle management ===============

  #======== End Chronicle =======================

  #========= Connection management ==============

  #======== End Connection ======================
end
