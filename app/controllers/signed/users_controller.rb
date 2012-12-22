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
   @wall_detail = WallDetail.new
   if params[:form_type] == "manage_connections"
     @connection = Connection.new
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

  def set_order
    cnt = 1
    params[:new_order].each do |id|
    if current_user.wall.wall_details.where("id" => id).first
      current_user.wall.wall_details.where("id" => id).first.update_attributes(:priority => cnt)
      cnt += 1
    end
   end
    render :nothing => true
  end

  def add_photos
    if current_user.update_attributes(params[:user])
     flash[:notice] = "updated"
    else
     # Put flash[:error] if required.
    end
    render :action =>  :add_walls
  end

  def destroy_image
    image = ''
    if params[:img_type] == "banner"
      image = BannerImage.where("_id" => params[:id])
    elsif params[:img_type] == "profile"
      image = ProfileImage.where("_id" => params[:id])
    end
    image.destroy
    render :action =>  :add_walls
  end
  #========= Circle management ==================

  #======== End Circle ==========================

  #========= Chronicle management ===============

  #======== End Chronicle =======================

  #========= Connection management ==============
  def add_category_title
    begin
     @connection = current_user.connections.where("_id" => params[:id]).first
       if @connection
  	 @connection.update_attributes(params[:connection])
       else
        @connection = current_user.connections.create(params[:connection])
        current_user.save
       end
     @connection = Connection.new
    rescue
     render :nothing => true
   end
  end

  def edit_category
    @connection = current_user.connections.where("_id" => params[:id]).first
    render :action => :add_category_title
  end

  def delete
    @connection = current_user.connections.where("_id" => params[:id]).first
    if @connection and (params[:type] == "hide")
      @connection.update_attributes(:hidden => true)
    else
      @connection.update_attributes(:hidden => false)
    end
    @connection = Connection.new
      render :action => :add_category_title
  end
  #======== End Connection ======================
end
