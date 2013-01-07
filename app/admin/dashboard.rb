ActiveAdmin.register_page "Dashboard" do

  menu :priority => 1, :label => proc{ I18n.t("active_admin.dashboard") }

  content :title => proc{ I18n.t("active_admin.dashboard") } do

   columns do
     column do
       panel "Stats" do
         div do
           "Number of members:  #{User.count}"
         end
         div do
           "Number of signups today: #{User.where(:created_at => Time.now.all_day).count}"
         end
         div do
           "Number of signups this week: #{User.where(:created_at => Time.now.all_week).count}"
         end
         div do
           "Number of signups this month: #{User.where(:created_at => Time.now.all_month).count}"
         end
         div do
           div do
            "Number of posts today: #{Feed.where(:created_at => Time.now.all_day).count}"
           end
           div do
             "Updates: #{Feed.where(:created_at  => Time.now.all_day, :feed_type_id => FeedType.where(:post_type => 'Update').first.id).count}"
           end
           div do
             "Photos: #{Feed.where(:created_at => Time.now.all_day, :feed_type_id => FeedType.where(:post_type => 'Photos').first.id).count}"
           end
           div do
             "Videos: #{Feed.where(:created_at => Time.now.all_day, :feed_type_id => FeedType.where(:post_type => 'Videos').first.id).count}"
           end
           div do
             "Events: #{Feed.where(:created_at => Time.now.all_day, :feed_type_id => FeedType.where(:post_type => 'Events').first.id).count}"
           end
           div do
             "Deals: #{Feed.where(:created_at => Time.now.all_day, :feed_type_id => FeedType.where(:post_type => 'Deals').first.id).count}"
           end
         end
         div do
           "Number of total posts: #{Feed.count}"
         end
       end
     end
   end

  end # content
end
