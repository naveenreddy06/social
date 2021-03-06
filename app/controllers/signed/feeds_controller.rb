require 'oembed'
class Signed::FeedsController < Signed::BaseController

  before_filter :set_flashes_to_null, :check_authentication

  def index
    @title = nil
    @limit = 15
    latest = params[:last_feed] || Time.now
    case params[:feed_type]
    when "latest_news_feeds"
      @feeds = Feed.desc("updated_at").limit(@limit).where(:user_id.ne => current_user.id, :channels.in => session_all, :updated_at.lt => latest).entries
      @title = "Latest News Feed"
      @last_feed = @feeds.last.updated_at unless @feeds.empty?
    when "my_posts"
      @feeds = Feed.desc("updated_at").limit(@limit).where(:user_id => current_user.id, :updated_at.lt => latest ).entries
      @title = "My Posts"
      @last_feed = @feeds.last.updated_at unless @feeds.empty?
    when "circle"
      @circle = Circle.find(params[:circle_id])
      @feeds = Feed.desc("updated_at").limit(@limit).where(:channels.in => [@circle.id.to_s], :updated_at.lt => latest).entries
      @title = @circle.name.capitalize
      @last_feed = @feeds.last.updated_at unless @feeds.empty?
    when "chronicle"
      @chronicle = Chronicle.find(params[:chronicle_id])
      @feeds = Feed.desc("updated_at").limit(@limit).where(:channels.in => [@chronicle.id.to_s], :updated_at.lt => latest ).entries
      @title = @chronicle.chronicle_title.capitalize
      @status = (@chronicle.user_id.to_s == current_user.id.to_s) ? true : false
      @last_feed = @feeds.last.updated_at unless @feeds.empty?
    when "connections"
      @connection = Connection.find(params[:connection_id])
      users = []
      UserFriend.where(:connection_id => @connection.id.to_s).each do |user|
        users << user.friend_id.to_s
      end
      users.uniq!
      @feeds = Feed.desc("updated_at").limit(@limit).where(:channels.in => users + [@connection.id.to_s], :updated_at.lt => latest).entries
      @title = @connection.category_title.capitalize
      @last_feed = @feeds.last.updated_at unless @feeds.empty?
    when "Favorites"
      @feeds = []
      emotion = Emotion.find(params[:type_id])
      @feed_type = FeedType.first
      user_feeds = UserFeed.limit(@limit).where(:emotion_id => emotion.id, :favorite => true,:user_id => current_user.id, :updated_at.lt => latest)
      @last_feed = user_feeds.last.updated_at unless user_feeds.empty?
      user_feeds.each do |feed|
        @feeds << feed.feed
      end
      @title = "Favorites - #{emotion.name}"

    else
      @feeds = Feed.desc("updated_at").limit(@limit).where(:channels.in => session_all, :updated_at.lt => latest).entries
      @last_feed = @feeds.last.updated_at unless @feeds.empty?
      @title = "All Feeds"
    end
    @feed_types = FeedType.all
    @message = Message.new
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
   @comment = @feed.comments.create(:user_id => current_user.id, :comment => params[:comment], :comment_mood_id => params[:comment_mood_id]) if @feed
  end

  def feed_tag
    begin
      @feed = Feed.find(params[:feed_id])
    rescue
      @feed = false
    end
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

  def emotions_tag
    begin
      @feed = Feed.find(params[:feed_id])
    rescue
      @feed = false
    end
    update_tag = params[:update_tag]
    if @feed
      feed_user = UserFeed.where("user_id" => current_user.id, "feed_id" => @feed.id).first
      if !feed_user
        @feed.user_feeds.create((update_tag.merge :user_id => current_user.id).merge :emotion_id => params[:type_id])
      else
        feed_user.update_attributes(update_tag.merge :emotion_id => params[:type_id])
      end
    end
    render :action => :feed_tag
  end
  def deletepost
    begin
      @feed = Feed.where("_id" => params[:feed_id]).first
    rescue
      @feed = false
    end
    case params[:type]
     when "delete"
       if @feed
         @feed.destroy
       end
     when "hide"
       if @feed
         feed_user = UserFeed.where("user_id" => current_user.id, "feed_id" => @feed.id)
         if feed_user.empty?
           @feed.user_feeds.create(:user_id => current_user.id, :hidden => true )
         else
           feed_user.last.update_attributes(:hidden => true)
         end
       end
     when "abuse"
       if @feed
          feed_user = UserFeed.where("user_id" => current_user.id, "feed_id" => @feed.id)
         if feed_user.empty?
           @feed.user_feeds.create(:user_id => current_user.id, :abuse => true )
           @feed.update_attributes(:feed_count => @feed.feed_count.to_i + 1 )
         else
           feed_user.last.update_attributes(:abuse => true)
           @feed.update_attributes(:feed_count => @feed.feed_count.to_i + 1 )
         end
       end      
    end
  end

end
