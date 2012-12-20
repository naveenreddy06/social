module FeedHelper

  def fetch_feeds
    limit = 10
    case params[:type]
    when "circle"
      @circle = Circle.where("_id" => params[:id]).first
      @feeds = Feed.desc("updated_at").limit(limit).where({:channels => {"$in" => [@circle.id.to_s]}}).entries
    when "chronicle"
     @chronicle = Chronicle.where("_id" => params[:id]).first
     @feeds = Feed.desc("updated_at").limit(limit).where({:channels => {"$in" => [@chronicle.id.to_s]}}).entries
     @status = UserChronicle.where("user_id" => current_user.id, "chronicle_id" => @chronicle.id ).empty?
     if params[:chronicle_type] == "user"
       if UserChronicle.where("chronicle_id" => params[:id], "user_id" => current_user.id).first
          @feeds = Feed.desc("updated_at").limit(limit).where({:channels => {"$in" => [@chronicle.id.to_s]}}).entries
       end
     end
    when "connection"
      @connection = Connection.where("_id" => params[:id]).first
      friends = UserFriend.where(:connection_id => params[:id]).collect(&:friend_id)
      connections = UserFriend.where(:user_id.in => friends.to_a, :friend_id => current_user.id.to_s).collect(&:connection_id) + friends.to_a
      connections << @connection.id.to_s
      @feeds = Feed.desc("updated_at").limit(limit).where({:channels => {"$in" => connections}}).entries
    when "user"
       @feed_types = FeedType.all
        if params[:latest] == "lastestuser"
          @feeds = Feed.desc("updated_at").limit(limit).where(:user_id.in => current_user.user_friends.collect(&:friend_id)).entries
        else
         @feeds = Feed.desc("updated_at").limit(limit).where(:user_id => current_user.id).entries
        end
    when "follow"
        UserChronicle.create(:user_id => current_user.id, :chronicle_id => params[:id])
        session_user_chronicles
    when "unfollow"
        @chronicle = UserChronicle.where(:chronicle_id => params[:id], :user_id => params[:user_id]).first
        @chronicle.destroy
        session_user_chronicles
        render :nothing => true
    when "favourites"
        feed_ids = current_user.user_feeds.where(:favourite => true).collect(&:feed_id)
        @feed_types = FeedType.where("_id" => params[:feed_type_id]).entries
        if params[:last_favourite]
         @feeds = Feed.desc("updated_at").limit(limit).where(:_id.in => feed_ids, :feed_type_id => params[:feed_type_id], :updated_at.lte => params[:last_favourite].to_time ).entries
        else
         @feeds = Feed.desc("updated_at").limit(limit).where(:_id.in => feed_ids, :feed_type_id => params[:feed_type_id]).entries
        end
    else
      @feeds = Feed.desc("updated_at").limit(limit).where({:channels => {"$in" => session_all}}).entries
    end
  end

  def fetch_older_feeds
  end

end
