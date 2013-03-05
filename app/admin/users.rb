ActiveAdmin.register User do

  config.clear_action_items!

  filter :display_name, :as => :string
  filter :first_name, :as => :string
  filter :last_name, :as => :string

  collection_action :suspend do
    if params[:id]
      User.find(params[:id]).update_attributes(:suspend_till => Time.now + 7.days )
      redirect_to admin_users_path
    end
  end

  index do
    column :display_name
    column :first_name
    column :last_name
    column :verified
    column "Actions" do |user|
      span link_to "View", admin_user_path(user)
      if user.suspend_till.blank? || ( user.suspend_till < Time.now )
        span link_to "Suspend", suspend_admin_users_path(:id => user)
      else
       span "suspended"
      end
    end
  end

  show do
     attributes_table :display_name,:first_name,:last_name,:birthday,:phone,:verified,:time_zone
     panel "Login" do
     	attributes_table_for user.login do
     	  row("Email") {user.login.email}
     	end
     end
     panel "Connections" do
      unless user.connections.empty?
     	table_for user.connections do
          column :category_title
          column :hidden
     	end
      end
     end
     panel "Circles" do
      unless user.circles.empty?
     	table_for user.circles do
         column :name
         column :listed
         column :approve
         column :short_description
         column :keyword_tags
         column :hidden
     	end
      end
     end
     panel "Chronicles" do
      unless user.chronicles.empty?
     	table_for user.chronicles do
     	  column :chronicle_title
          column :published_date
     	  column :permission
     	end
      end
     end
   end

end
