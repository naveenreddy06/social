ActiveAdmin.register Feed do

 config.clear_action_items!

 index do
   column :id
   column :public
   column "Abuse Count", :feed_count
   column "Actions" do |feed|
     span link_to "View", admin_feed_path(feed)
    if feed.feed_count.to_i > 5
     span link_to "Delete", admin_feed_path(feed), :method => :delete
    end
   end
  end

  show do
    attributes_table :feed,:public
    panel "feed_types" do
      attributes_table_for feed.feed_type do
     	row("Post Type") {feed.feed_type.post_type}
      end
    end
    panel "User Feeds" do
      unless feed.user_feeds.empty?
        table_for feed.user_feeds do
     	  column :cool do
     	     UserFeed.where("feed_id" => feed.id, :cool => true).count
     	  end
     	  column :favourite do
            UserFeed.where("feed_id" => feed.id, :favourite => true).count
          end
          column :shared do
     	    UserFeed.where("feed_id" => feed.id, :shared => true).count
          end
     	end
      end
     end
     panel "Comments Count" do
     	span "#{feed.comments.count}"
     end
  end

end
