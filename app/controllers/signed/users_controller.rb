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
   case params[:form_type] 
    when "manage_connections"
     @connection = Connection.new
    when "manage_circles"
     @circle = Circle.new
    when "circle_info"
     @circle = Circle.where(:_id => params[:id].to_s).first
     @circle_detail = CircleDetail.new
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
  def add_circles_title
   begin
     @circle = current_user.circles.where("_id" => params[:id]).first
     if @circle
      @circle.update_attributes(params[:circle])
     else
      @circle = current_user.circles.create(params[:circle])
     end
      @circle = Circle.new
   rescue
     render :nothing => true
   end
  end

  def edit_circles
    @circle = current_user.circles.where("_id" => params[:id]).first
    render :action => :add_circles_title
  end

  def hide_circle
    @circlehidden = Circle.find params[:circle_id]
    @circle = Circle.new
    @circle_detail = CircleDetail.new
    if @circlehidden and (params[:circle_type] == "hide")
      @circlehidden.update_attributes(:hidden => true)
    else
      @circlehidden.update_attributes(:hidden => false)
    end
    render :action => :add_circles_title
  end

  def about
    @circle = Circle.find params[:id]
    @circle_detail = CircleDetail.new
    render :action => :add_circles_title
  end

  def sort_about
    @circle = Circle.find params[:id]
  end

  def get_members
    @circle = Circle.where("_id" => params[:id]).first
    if @circle
     @user_circles = UserCircle.where(:circle_id => @circle.id, :admin => false, :reject => false)
    end
  end

  def add_circle_details
   begin
     @circle = current_user.circles.where("_id" => params[:circle_detail][:circle_id]).first
     @circle_detail = @circle.circle_details.where("_id" => params[:id]).first
     if @circle_detail
       @circle_detail.update_attributes(params[:circle_detail])
     else
       @circle_detail = CircleDetail.create(params[:circle_detail])
     end
     @circle_detail = CircleDetail.new
     render :action => :add_circles_title
   rescue
     render :nothing => true
   end
  end

  def get_circle
    @circle = current_user.circles.where("_id" => params[:circle_id]).first
    @circle_detail = @circle.circle_details.where("_id" => params[:id]).first
    render :action => :add_circles_title
  end

  def delete_circle
    @circle_detail = CircleDetail.where("_id" => params[:id]).first
    @circle_detail.destroy
    if params[:edit_id] == params[:id]
      @circle = current_user.circles.where("_id" => params[:circle_id]).first
      @circle_detail = CircleDetail.new
      render :action => :add_circles_title
    else
      render :nothing => true
    end
  end

  def set_order
    cnt = 1
    @circle = Circle.where("_id" => params[:circle_id]).first
   params[:new_order].each do |id|
    if @circle.circle_details.where("id" => id).first
      @circle.circle_details.where("id" => id).first.update_attributes(:priority => cnt)
      cnt += 1
    end
   end
    render :nothing => true
  end

  def add_circle_photos
    @circle = current_user.circles.where("_id" => params[:id]).first
    if @circle and !params[:circle].blank?
      @circle.update_attributes(params[:circle])
    end
  end

  def destroy_image
    @circle = current_user.circles.where("_id" => params[:circle_id]).first
    if params[:img_type] == "circle_image"
      image = CircleImage.where("_id" => params[:id])
      image.destroy
    else
      image = CircleProfileImage.where("_id" => params[:id])
      image.destroy
    end
    render :action => :add_circle_photos
  end

  def delete_user
    @user_circle = UserCircle.where(:id => params[:id]).first
    if @user_circle
      @user_circle.destroy
    end
    @circle = Circle.where("_id" => params[:circle_id]).first
    @user_circles = UserCircle.where(:circle_id => params[:circle_id], :admin => false)
    render :action => :get_members
  end

  def approve_user
    @user_circle = UserCircle.where(:id => params[:id]).first
    if @user_circle
      @user_circle.update_attributes(:approve => false)
    end
    @circle = Circle.where("_id" => params[:circle_id]).first
    @user_circles = UserCircle.where(:circle_id => params[:circle_id], :admin => false, :reject => false)
    render :action => :get_members
  end

  def reject_user
    @user_circle = UserCircle.where(:id => params[:id]).first
    if @user_circle
      @user_circle.update_attributes(:reject => true)
    end
    @circle = Circle.where("_id" => params[:circle_id]).first
    @user_circles = UserCircle.where(:circle_id => params[:circle_id], :admin => false, :reject => false)
    render :action => :get_members
  end

  def unjoin_user
    @circle = Circle.where("_id" => params[:circle_id]).first
    @user_circle = UserCircle.where(:circle_id => @circle.id , :user_id => current_user.id).first
    if @user_circle
       @user_circle.destroy
    end
    session_circles
  end
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

    render :action => :add_category_title
  end


  def block
    if @friendrequest = UserFriend.where(:user_id => current_user.id , :friend_id => params[:id]).first
      @friendrequest.update_attributes("block" => "true")
    end
    render :action => :add_category_title
  end

   def unblock
     if @friendrequest = UserFriend.where(:user_id => current_user.id , :friend_id => params[:id]).first
       @friendrequest.update_attributes("block" => nil)
     end
     render :action => :add_category_title
  end

  def connection_types
    if @friendrequest = UserFriend.where(:user_id => current_user.id , :friend_id => params[:friend_id]).first
       @friendrequest.update_attributes("connection_id" => params[:conn_id])
    end
    render :action => :add_category_title
  end

  #======== End Connection ======================
end
