ActiveAdmin.register AbusePost do
  config.clear_action_items!

  index do
    column :id 
    column "Post owner" do |ap|
     span link_to ap.user.display_name.blank? ? ap.user.first_name.to_s + " " + ap.user.last_name.to_s : ap.user.display_name, admin_user_path(ap.user_id) 
    end    
    column "Abuse Count", :feed_count
    column " Reported by" do |master|
      master.abuse_users.each do |au|
       span link_to au[0], admin_user_path(au[1]) 
      end
    end
    column "Date", :created_at
  end
  
end
