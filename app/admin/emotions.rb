ActiveAdmin.register Emotion do

  config.clear_action_items!

  index do
    column :name
    column :emotion_type
    column :emotion_image
    column "Actions" do |emotion|
      span link_to "View", admin_emotion_path(emotion)
    end
  end

  form do |f|                         
    f.inputs "Emotion Details" do       
      f.input :emotion_type                  
      f.input :name  
      f.input :emotion_image            
      f.input :order 
    end                               
    f.actions                         
  end  
 
end
