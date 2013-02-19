ActiveAdmin.register Emotion do

  config.clear_action_items!

  index do
    column :name
    column :emotion_type
    column "Actions" do |emotion|
      span link_to "View", admin_emotion_path(emotion)
    end
  end
 
end
