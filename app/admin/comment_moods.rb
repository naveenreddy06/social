ActiveAdmin.register CommentMood do
  config.clear_action_items!
  index do
    column :name
    column :enabled_image
    column :disabled_image
    column :order
    column "Actions" do |cm|
      span link_to "View", admin_comment_mood_path(cm)
    end
  end
  
end
