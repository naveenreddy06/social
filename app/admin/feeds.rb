ActiveAdmin.register Feed do

 config.clear_action_items!

 index do
   column :id
   column "Feed owner" do |feed|
    span link_to  feed.user.display_name.blank? ? feed.user.first_name.to_s + " " + feed.user.last_name.to_s : feed.user.display_name, admin_user_path(feed.user_id)
   end
   column "Post type" do |feed|
    feed.feed_type.post_type
   end
   column :public
   column "Abuse Count", :feed_count
   column "Date", :created_at
   column "Actions" do |feed|
     span link_to "View", admin_feed_path(feed)
    if feed.feed_count.to_i > 5
     span link_to "Delete", admin_feed_path(feed), :method => :delete
    end
   end
  end

  show do
    panel "Feed details" do
     attributes_table_for  feed do
      row("Feed") {feed.feed}
      row("Feed owner") { feed.user.display_name.blank? ? feed.user.first_name.to_s + " " + feed.user.last_name.to_s : feed.user.display_name}
      row("Post type") { feed.feed_type.post_type}
      row("public") {feed.public}
      row("Abuse Count") {feed.feed_count}
      row("Date") {feed.created_at}
      case feed.feed_type.post_type
       when "Photos"      
          row("Feed Image") {feed.feed_image.nil? ? "" : (image_tag feed.feed_image.feedimage) }
      when "Videos"
          row("Feed Video") {begin OEmbed::Providers.get(feed.feed_hash["video"], {:maxwidth => 355, :maxheight => 300}).html.html_safe rescue "Video not found or removed at source." end }
       when "Events"
        row("Event Image") {feed.event_image.nil? ? "" : (image_tag feed.event_images)}
        row("Event") {feed.feed_hash["event_name"]}
        row("Details") {feed.feed_hash["feed.feed"]}
        row("Event time") {feed.feed_hash["event_date"] + feed.feed_hash["event_time"]}
        row("Location") {feed.feed_hash["event_location"]}
       when "Deals"
        row("Deal Image") {feed.deal_image.nil? ? "" : (image_tag feed.deal_images)}
        row("Sale Price") {"$" + feed.feed_hash["deal_sale_price"]}
        row("Sale Link") {feed.feed_hash["deal_sale_link"]}
        row("Deal Date") {"expires: "+feed.feed_hash["deal_date"]}
      end
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
