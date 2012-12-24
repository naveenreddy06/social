class Signed::FeedsController < Signed::BaseController
  
  def index 
    @feeds = Feed.all.entries
    @feed_types = FeedType.all
  end
  
  def create
    @feed = Feed.create(params[:feed])
   end
  
  def fetch_form
     @feed = Feed.new(:feed_type_id => params["select_id"])
     @feed_type = FeedType.where("_id" => params["select_id"]).first unless params[:select_id].nil?
     @feed_type = FeedType.first if params[:select_id].nil?
     @chronicle = Chronicle.where("_id" => params[:chronicle_id]).first if params[:chronicle_id].present?
     @circle = Circle.where("_id" => params[:circle_id]).first if params[:circle_id].present?
  end
  
  def fetch_friends
    @friends = current_user.my_friends.collect{|f| [f.id, f.first_name ]}
  end
  
end
