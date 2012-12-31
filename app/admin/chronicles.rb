ActiveAdmin.register Chronicle do

  config.clear_action_items!

  filter :chronicle_title, :as => :string
  filter :published_date, :as => :string

  index do
    column :chronicle_title
    column :published_date
    column :permission
    column "Actions" do |chronicle|
      span link_to "View", admin_chronicle_path(chronicle)
    end
  end

  show do
    attributes_table :id,:chronicle_title,:published_date,:permission
    panel "User" do
      attributes_table_for chronicle.user do
     	row("First Name") {chronicle.user.first_name}
     	row("Last Name") {chronicle.user.last_name}
      end
     end
  end
  
end
