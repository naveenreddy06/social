ActiveAdmin.register Circle do

  config.clear_action_items!

  filter :name, :as => :string

  index do
    column :name
    column :listed
    column :approve
    column :short_description
    column :keyword_tags
    column :hidden
    column "Actions" do |circle|
      span link_to "View", admin_circle_path(circle)
    end
  end

  show do
    attributes_table :name,:listed,:approve,:short_description,:keyword_tags,:hidden
    panel "User" do
      attributes_table_for circle.user do
     	row("First Name") {circle.user.first_name}
     	row("Last Name") {circle.user.last_name}
     end
    end
  end
  
end
