ActiveAdmin.register UserType do

  actions :all, :except => [:destroy]

  filter :name, :as => :string  

  index do                            
    column :name                             
    column "Actions" do |ut|
      span link_to "View", admin_user_type_path(ut)
      span link_to "Edit", edit_admin_user_type_path(ut)
    end                
  end    
  
end
