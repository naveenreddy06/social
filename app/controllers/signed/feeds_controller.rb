require 'oembed'
class Signed::FeedsController < Signed::BaseController

  before_filter :set_flashes_to_null, :check_authentication

  def index
    @title = nil
    limit = 15
    case params[:feed_type]
    when "latest_news_feeds"
      @feeds = Feed.desc("updated_at").where(:user_id.ne => current_user.id, :channels.in => session_all).entries
      @title = "Latest News Feed"
    when "my_posts"
      @feeds = Feed.desc("updated_at").limit(limit).where(:user_id => current_user.id ).entries
      @title = "My Posts"
    when "circle"
      @circle = Circle.find(params[:circle_id])
      @feeds = Feed.desc("updated_at").limit(limit).where(:channels.in => [@circle.id.to_s]).entries
      @title = @circle.name.capitalize
    when "chronicle"
      @chronicle = Chronicle.find(params[:chronicle_id])
      @feeds = Feed.desc("updated_at").limit(limit).where(:channels.in => [@chronicle.id.to_s]).entries
      @title = @chronicle.chronicle_title.capitalize
      @status = (@chronicle.user_id.to_s == current_user.id.to_s) ? true : false
    when "connections"
      @connection = Connection.find(params[:connection_id])
      users = []
      UserFriend.where(:connection_id => @connection.id.to_s).each do |user|
        users << user.friend_id.to_s
      end
      users.uniq!
      @feeds = Feed.desc("updated_at").limit(limit).where(:channels.in => users + [@connection.id.to_s]).entries
      @title = @connection.category_title.capitalize

    when "Favorites"
      @feeds = []
      @feed_type = FeedType.find(params[:type_id])
      UserFeed.limit(limit).where(:feed_type_id => @feed_type.id, :favorite => true, :user_id => current_user.id).each do |feed|
        @feeds << feed.feed
      end
      @title = "Favorites - #{@feed_type.post_type.capitalize}"

    else
      @feeds = Feed.desc("updated_at").where(:channels.in => session_all).entries
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
        @feed.user_feeds.create((update_tag.merge :user_id => current_user.id).merge :feed_type_id => @feed.feed_type_id)
      else
        feed_user.update_attributes(update_tag)
      end
    end
  end
end
