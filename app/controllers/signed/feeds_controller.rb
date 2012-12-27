require 'oembed'
class Signed::FeedsController < Signed::BaseController

  before_filter :set_flashes_to_null, :check_authentication

  def index
    @title = nil
    @status = false
    case params[:feed_type]
    when "latest_news_feeds"
      @feeds = []
      @title = "Latest News Feed"
    when "circle"
      @circle = Circle.find(params[:circle_id])
      @feeds = Feed.desc("created_at").where(:channels.in => [@circle.id.to_s]).entries
      @title = @circle.name.capitalize
    when "chronicle"
      @chronicle = Chronicle.find(params[:chronicle_id])
      @feeds = Feed.desc("created_at").where(:channels.in => [@chronicle.id.to_s]).entries
      @title = @chronicle.chronicle_title.capitalize
      @status = (@chronicle.user_id == current_user.id.to_s)
    else
      @feeds = Feed.desc("created_at").where(:channels.in => session_all).entries
    end
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

  def feed_tag
    @feed = Feed.find(params[:feed_id])
    update_tag = params[:update_tag]
    if @feed
      feed_user = UserFeed.where("user_id" => current_user.id, "feed_id" => @feed.id).first
      if !feed_user
        @feed.user_feeds.create(update_tag.merge :user_id => current_user.id)
      else
        feed_user.update_attributes(update_tag)
      end
    end
  end
end
