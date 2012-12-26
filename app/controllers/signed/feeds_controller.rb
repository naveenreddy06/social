require 'oembed'
class Signed::FeedsController < Signed::BaseController

  before_filter :set_flashes_to_null, :check_authentication

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

  def add_comment
   @feed = Feed.where("_id" => params[:feed_id]).first
   @comment = @feed.comments.create(:user_id => current_user.id, :comment => params[:comment])
  end

  def cool
    @cool = Feed.where("_id" => params[:feed_id]).first
    feed_user = UserFeed.where("user_id" => current_user.id, "feed_id" => @cool.id)
    if feed_user.empty?
      @cool.user_feeds.create(:user_id => current_user.id, :cool => "true" )
    else
      feed_user.last.update_attributes(:cool => "true" )
    end
  end

  def favourite
    @favourite = Feed.where("_id" => params[:feed_id]).first
    feed_user = UserFeed.where("user_id" => current_user.id, "feed_id" => @favourite.id)
    if feed_user.empty?
      @favourite.user_feeds.create(:user_id => current_user.id, :favourite => true )
    else
      feed_user.last.update_attributes(:favourite => true)
    end
  end

end
